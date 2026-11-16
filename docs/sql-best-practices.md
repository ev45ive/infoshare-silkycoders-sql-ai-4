# Dobre praktyki T-SQL w hurtowni danych (retail / moda)

Dokument opisuje konwencje nazewnictwa, formatowania, projektowania zapytań, typów danych, modelowania, wydajności, ładowania danych i bezpieczeństwa w hurtowni danych firmy odzieżowej. Obowiązuje dla developerów i analityków pracujących na SQL Server 2022.

Zasady: składnia T-SQL (SQL Server 2022), nazwy obiektów po angielsku, komentarze w kodzie po polsku, komentarze inline tylko tam, gdzie logika jest złożona lub niejasna.

## Spis treści

- [1. Nazewnictwo](#1-nazewnictwo)
- [2. Formatowanie kodu](#2-formatowanie-kodu)
- [3. Projektowanie zapytań](#3-projektowanie-zapytań)
- [4. Typy danych](#4-typy-danych)
- [5. Modelowanie](#5-modelowanie)
- [6. Wydajność](#6-wydajność)
- [7. Ładowanie i jakość danych](#7-ładowanie-i-jakość-danych)
- [8. Bezpieczeństwo](#8-bezpieczeństwo)
- [9. Dokumentacja obiektów](#9-dokumentacja-obiektow)
- [10. Wzorcowe zapytanie](#10-wzorcowe-zapytanie)

# 1. Nazewnictwo

Ustalamy spójne nazwy obiektów i kolumn, tak aby z nazwy było widać warstwę, rolę i typ obiektu.

- Wymiary: prefiks `dim_` (np. `dim_product`, `dim_store`, `dim_date`, `dim_size`).
- Tabele faktów: prefiks `fact_` (np. `fact_sales`, `fact_returns`).
- Staging: prefiks `stg_` (np. `stg_sales_raw`).
- Widoki raportowe: prefiks `vw_` (np. `vw_sales_weekly`).
- Procedury: prefiks `usp_`. Nie używaj `sp_`, bo SQL Server szuka takich procedur najpierw w `master`.
- Indeksy: `cix_<tabela>_<kolumny>` (klastrowany), `ix_<tabela>_<kolumny>` (nieklastrowany), `ncci_<tabela>` (columnstore).
- Ograniczenia: `pk_<tabela>`, `fk_<tabela>_<tabela_docelowa>`, `uq_<tabela>_<kolumny>`, `df_<tabela>_<kolumna>`.
- Kolumny w języku angielskim, `snake_case`, bez polskich znaków i spacji.
- Klucz techniczny: `<encja>_sk` (np. `product_sk`). Klucz daty: `date_key` jako `INT` w formacie `YYYYMMDD`.
- Klucz biznesowy: `<encja>_code` lub `<encja>_number` (np. `product_code`, `receipt_number`).
- Klucz obcy w fakcie ma tę samą nazwę co w wymiarze (np. `product_sk`).
- Miary nazywamy od agregacji: `net_sales_amount`, `quantity_sold`, `refund_amount`.
- Flagi logiczne z prefiksem `is_` lub `has_` (np. `is_promotion`). Typ `BIT`.
- Waluta w nazwie, gdy jest istotna (np. `amount_pln`).
- Kolumny audytowe w każdej tabeli: `load_dts`, `record_source`, `etl_batch_id`, `row_hash`.
- SCD typu 2: `valid_from`, `valid_to`, `is_current`. Nie mieszaj z `effective_*` w innych tabelach.
- Wymiary zawierają wiersz „nieznany” z kluczem `-1`, aby klucze obce w faktach nie były `NULL`.
- Nie używaj słów zarezerwowanych (`order`, `user`, `date`, `status`, `value`, `key`). Jeśli występują w źródle, zmień nazwę przy przejściu przez warstwy.

```sql
-- Wymiar produktu: klucz techniczny, klucz biznesowy, flaga, nazwa po angielsku
CREATE TABLE dbo.dim_product
(
    product_sk   INT           NOT NULL CONSTRAINT pk_dim_product PRIMARY KEY,
    product_code VARCHAR(30)   NOT NULL,
    product_name NVARCHAR(200) NOT NULL,
    is_active    BIT           NOT NULL CONSTRAINT df_dim_product_is_active DEFAULT 1,
    load_dts     DATETIME2(0)  NOT NULL CONSTRAINT df_dim_product_load_dts DEFAULT SYSDATETIME(),
    record_source VARCHAR(50)  NOT NULL
);

-- Wiersz „nieznany” dla klucza obcego bez dopasowania
INSERT INTO dbo.dim_product (product_sk, product_code, product_name, record_source)
VALUES (-1, 'UNKNOWN', 'Nieznany produkt', 'SYSTEM');

-- Indeks nieklastrowany pod filtr po sklepie w tabeli faktów
CREATE NONCLUSTERED INDEX ix_fact_sales_store_sk
    ON dbo.fact_sales (store_sk);
```

# 2. Formatowanie kodu

Ustalamy jednolity wygląd zapytań, żeby były czytelne w code review i łatwe do porównania.

- Słowa kluczowe wielkimi literami (`SELECT`, `FROM`, `INNER JOIN`).
- Jedna kolumna w osobnej linii w `SELECT` i `GROUP BY`.
- Jawne typy JOIN (`INNER JOIN`, `LEFT JOIN`); nigdy samo `JOIN`.
- Warunki `ON` w osobnych liniach, gdy są złożone.
- Aliasy krótkie i czytelne (`f` dla faktów, `d` dla dat, `s` dla sklepów), zawsze z `AS`.
- Bez `SELECT *` w kodzie produkcyjnym, widokach i procedurach. Wymieniaj kolumny jawnie.
- Średnik na końcu każdej instrukcji.

```sql
SELECT
    f.date_key,
    f.store_sk,
    SUM(f.net_amount) AS net_sales_amount   -- miara liczona po kluczach, bez zwrotów
FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_store AS s
    ON  s.store_sk  = f.store_sk
    AND s.is_active = 1                     -- tylko sklepy aktywne w hurtowni
GROUP BY
    f.date_key,
    f.store_sk;
```

# 3. Projektowanie zapytań

Ustalamy, jak pisać zapytania, które są poprawne przy `NULL`, korzystają z indeksów i nie mnożą wierszy.

- Używaj CTE o jednym celu. CTE nie jest materializowane, więc każde odwołanie oznacza ponowne przeliczenie.
- Filtruj bez funkcji na kolumnie: filtr po `date_key` (`INT`), a nie `YEAR(full_date)`.
- `UNION ALL` zamiast `UNION`, gdy deduplikacja nie jest potrzebna (`UNION` wymusza sortowanie lub hash).
- `NOT EXISTS` zamiast `NOT IN`, bo `NULL` w podzapytaniu `NOT IN` daje pusty wynik.
- Obsługa `NULL`: `ISNULL` dla miar po `LEFT JOIN`, `NULLIF` przed dzieleniem.
- Unikaj kursorów; preferuj operacje zbiorowe.
- Sprawdzaj kardynalność po każdym JOIN-ie, bo wiele faktów na jednym kluczu powoduje mnożenie wierszy (fan-out).

```sql
-- Źle: funkcja na kolumnie uniemożliwia użycie indeksu
-- WHERE YEAR(d.full_date) = 2026

-- Dobrze: zakres po kluczu daty (działa z indeksem i partycjonowaniem)
SELECT
    f.store_sk,
    f.net_amount
FROM dbo.fact_sales AS f
WHERE f.date_key >= 20260101
  AND f.date_key <  20270101;

-- Produkty bez sprzedaży: NOT EXISTS, bo NULL w NOT IN zwróciłby pusty wynik
SELECT
    p.product_sk
FROM dbo.dim_product AS p
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.fact_sales AS f
    WHERE f.product_sk = p.product_sk
);

-- Wskaźnik zwrotów: NULLIF chroni przed dzieleniem przez zero,
-- ISNULL zamienia brak zwrotów na 0 w wyniku
SELECT
    CAST(
        100.0 * ISNULL(r.refund_amount, 0.00)
        / NULLIF(s.net_sales_amount, 0.00)
        AS DECIMAL(9, 2)
    ) AS return_rate_pct
FROM
(
    SELECT SUM(f.net_amount) AS net_sales_amount
    FROM dbo.fact_sales AS f
    WHERE f.date_key >= 20260101
      AND f.date_key <  20260401
) AS s
CROSS JOIN
(
    SELECT SUM(r2.refund_amount) AS refund_amount
    FROM dbo.fact_returns AS r2
    WHERE r2.date_key >= 20260101
      AND r2.date_key <  20260401
) AS r;
```

# 4. Typy danych

Ustalamy typy, które nie tracą precyzji i nie zmieniają wyniku porównań.

- Klucze (surrogate i daty): `INT` lub `BIGINT`, nigdy `VARCHAR`.
- Pieniądze: `DECIMAL(18,2)`, nigdy `FLOAT` ani `REAL`.
- Daty: `DATE` lub `DATETIME2`. Ustal strefę czasową (czas sklepu czy UTC) i opisz ją w dokumentacji.
- Wartości logiczne: `BIT`, bez tekstowych flag typu `'T'`/`'N'`.
- Wybieraj najmniejszy typ, który mieści dane.

```sql
DECLARE @net_price  DECIMAL(18, 2) = 199.99;     -- pieniądze: DECIMAL, nie FLOAT
DECLARE @date_key   INT            = 20260316;   -- klucz daty YYYYMMDD
DECLARE @is_promo   BIT            = 0;          -- flaga logiczna
DECLARE @sale_date  DATE           = '2026-03-16';

-- Klucz daty wyliczamy arytmetycznie (bez FORMAT, który jest wolniejszy)
DECLARE @date_key_calc INT = YEAR(@sale_date) * 10000 + MONTH(@sale_date) * 100 + DAY(@sale_date);
```

# 5. Modelowanie

Ustalamy model gwiazdy i zasady historii, aby miary i wymiary dało się bezpiecznie łączyć.

- Model gwiazdy (star schema) jako domyślny.
- Granularność faktu zapisana w nagłówku obiektu (np. „1 wiersz = tydzień × sklep × produkt × rozmiar”).
- Miary addytywne (kwoty, ilości) w fakcie. Miary nieaddytywne (liczba paragonów, średnia wartość koszyka) liczymy na osobnym poziomie.
- SCD typu 2 tam, gdzie historia ma znaczenie (cena katalogowa, kategoria, format sklepu).
- Sprzedaż, zwroty i rabaty rozdzielone na osobne miary lub fakty.
- Kalendarz w `dim_date` z tygodniami, miesiącami 4-4-5 i okresami promocyjnymi.

```sql
-- SCD typu 2: cena obowiązująca w dniu sprzedaży
DECLARE @sale_date DATE = '2026-03-16';

SELECT
    p.product_sk,
    p.product_code,
    p.list_price
FROM dbo.dim_product AS p
WHERE p.product_code = 'TSH-001-BLK'
  -- Wersja obowiązuje od valid_from (włącznie) do valid_to (wyłącznie).
  -- Bieżąca wersja ma valid_to = '9999-12-31'.
  AND @sale_date >= p.valid_from
  AND @sale_date <  p.valid_to;
```

# 6. Wydajność

Ustalamy sposoby pisania zapytań i ładowania danych, które nie przeliczają tego samego dwa razy i pozwalają optymalizatorowi działać.

- Nie przeliczaj wielokrotnie tej samej agregacji. Dla dużych zbiorów używaj `#temp` z indeksem zamiast CTE używanego kilka razy.
- Indeks twórz po załadowaniu danych do `#temp`, a nie przed (szybszy zapis i mniej fragmentacji).
- Parametry procedur zamiast zmiennych lokalnych (`DECLARE`) w filtrach, bo optymalizator nie zna ich wartości przy kompilacji.
- Tabele faktów: columnstore i partycjonowanie po `date_key`.
- Unikaj skalarnych funkcji zdefiniowanych przez użytkownika w dużych zapytaniach.
- Widok nie może zawierać `DECLARE` ani parametrów. Logikę z parametrami umieść w procedurze `usp_` lub funkcji tabelarycznej `tvf_`.
- Weryfikacja: `SET STATISTICS IO, TIME ON`, Actual Execution Plan (rozbieżność estymacji, spill do tempdb), Query Store.

```sql
-- Wieloetapowa agregacja: wynik pośredni w #temp, potem indeks, potem użycie wielokrotne
SELECT
    d.week_start_date,
    f.store_sk,
    f.product_sk,
    f.size_sk,
    SUM(f.net_amount) AS net_sales_amount
INTO #sales_base
FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_date AS d
    ON d.date_key = f.date_key
WHERE f.date_key >= 20260101
  AND f.date_key <  20260401
GROUP BY
    d.week_start_date,
    f.store_sk,
    f.product_sk,
    f.size_sk;

-- Indeks po zapisie danych: klucz zgodny z JOIN-ami w dalszych krokach
CREATE CLUSTERED INDEX cix_sales_base
    ON #sales_base (week_start_date, store_sk, product_sk, size_sk);

-- Weryfikacja kosztu zapytań w bieżącej sesji
SET STATISTICS IO, TIME ON;
```

# 7. Ładowanie i jakość danych

Ustalamy zasady ładowania, które można bezpiecznie powtórzyć po awarii i które są sprawdzane po każdym przebiegu.

- Ładowanie w transakcji: `BEGIN TRANSACTION` / `COMMIT` w `TRY`, `ROLLBACK` w `CATCH`.
- Idempotentność: ponowne uruchomienie tej samej partii nie może duplikować danych (usuwanie po `etl_batch_id` przed wstawieniem).
- Ostrożnie z `MERGE` (znane problemy z wydajnością i wyścigami); preferuj osobne `UPDATE` i `INSERT`.
- Testy po ładowaniu: liczba wierszy, unikalność aktywnego klucza biznesowego, rekonsyliacja sum z systemem źródłowym.

```sql
DECLARE @batch_id INT = 42;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Idempotentność: usuwamy wyłącznie wiersze tej partii, więc ponowny start jest bezpieczny
    DELETE FROM dbo.fact_sales
    WHERE etl_batch_id = @batch_id;

    INSERT INTO dbo.fact_sales (date_key, store_sk, product_sk, net_amount, etl_batch_id)
    SELECT
        s.date_key,
        s.store_sk,
        s.product_sk,
        s.net_amount,
        @batch_id
    FROM dbo.stg_sales_raw AS s;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Wycofujemy tylko, gdy transakcja jest nadal otwarta
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

-- Test jakości: aktywny klucz biznesowy nie może występować więcej niż raz
SELECT
    p.product_code,
    COUNT(*) AS version_count
FROM dbo.dim_product AS p
WHERE p.is_current = 1
GROUP BY p.product_code
HAVING COUNT(*) > 1;
```

# 8. Bezpieczeństwo

Ustalamy dostęp minimalny, ochronę danych osobowych i brak sekretów w kodzie.

- Brak haseł, connection stringów i innych danych wrażliwych w skryptach SQL.
- Dane osobowe klientów (e-mail, telefon, nazwisko): maskowanie lub pseudonimizacja zgodnie z RODO.
- Minimalne uprawnienia: analityk czyta z warstwy `mart` i widoków, bez dostępu do stagingu.
- Skrypty SQL trzymamy w kontroli wersji (Git); zmiany schematu idą przez migracje.

```sql
-- Role: analityk czyta z warstwy mart, a staging jest zablokowany
GRANT SELECT ON SCHEMA::mart TO role_analyst;
DENY  SELECT ON SCHEMA::stg  TO role_analyst;

-- Pseudonimizacja: w raporcie pokazujemy tylko fragment e-maila
-- LEFT(…, 2) zachowuje dwa pierwsze znaki, reszta jest maskowana
SELECT
    c.customer_sk,
    LEFT(c.email, 2) + '***' AS email_masked
FROM dbo.dim_customer AS c;
```

# 9. Dokumentacja obiektów

Ustalamy, że każdy obiekt ma nagłówek i opis w bazie, dzięki czemu developer wie, co obiekt robi, bez czytania całego kodu.

- Nagłówek każdego widoku i procedury: nazwa, opis, ziarnistość, źródła, parametry, autor, historia zmian.
- Komentarze w kodzie po polsku, nazwy obiektów po angielsku.
- Opisy tabel i kolumn w bazie przez `MS_Description` (extended property).
- Słownik danych z jedną definicją każdej miary (np. „sprzedaż netto” = bez zwrotów, po rabatach, w PLN).

```sql
/*
=============================================================================
Nazwa:        usp_get_sales_weekly
Opis:         Tygodniowa sprzedaż netto w wybranym zakresie dat.
Ziarnistość:  1 wiersz = tydzień
Źródła:       fact_sales, dim_date
Parametry:    @date_from, @date_to (zakres włącznie, typ DATE)
Autor:        zespół analityczny
Zmiany:       2026-11-16 – wersja początkowa
=============================================================================
*/

-- Opis kolumny w bazie (widoczny w narzędziach i dokumentacji generowanej z bazy)
EXEC sys.sp_addextendedproperty
    @name       = N'MS_Description',
    @value      = N'Sprzedaż netto w PLN, po rabatach, bez zwrotów',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE',  @level1name = N'fact_sales',
    @level2type = N'COLUMN', @level2name = N'net_amount';
```

# 10. Wzorcowe zapytanie

Ustalamy wzorzec pełnej procedury raportowej: nagłówek, parametry, CTE o jednym celu, obsługa `NULL` i klucz daty. Ten przykład łączy zasady z sekcji 1–9.

- Logika z parametrami w procedurze `usp_`, nie w skrypcie z `DECLARE`.
- Zbiór kluczy z obu źródeł przez `UNION`, aby nie zgubić zwrotów bez sprzedaży w tym tygodniu.
- Wielokrotnie używane CTE to kandydaci na `#temp` z indeksem, gdy zbiór jest duży (sekcja 6).
- Każda miara z jawnym `ISNULL`, a wskaźnik z `NULLIF`.

```sql
/*
=============================================================================
Nazwa:        usp_get_sales_weekly_store_product_size
Opis:         Tygodniowa sprzedaż netto i zwroty per sklep, produkt i rozmiar.
Ziarnistość:  1 wiersz = tydzień × sklep × produkt × rozmiar
              Liczba paragonów nie jest addytywna, dlatego jej tu nie liczymy.
Źródła:       fact_sales, fact_returns, dim_date, dim_store, dim_product, dim_size
Parametry:    @date_from, @date_to (zakres włącznie, typ DATE)
Autor:        zespół analityczny
Zmiany:       2026-11-16 – wersja początkowa
=============================================================================
*/
CREATE OR ALTER PROCEDURE dbo.usp_get_sales_weekly_store_product_size
    @date_from DATE,
    @date_to   DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Zamiana dat na klucze daty (INT YYYYMMDD) – filtr działa z indeksem i partycjonowaniem
    DECLARE @date_key_from INT = YEAR(@date_from) * 10000 + MONTH(@date_from) * 100 + DAY(@date_from);
    DECLARE @date_key_to   INT = YEAR(@date_to)   * 10000 + MONTH(@date_to)   * 100 + DAY(@date_to);

    WITH sales_base AS
    (
        -- Sprzedaż bez zwrotów, w ziarnistości raportu
        SELECT
            d.week_start_date,
            f.store_sk,
            f.product_sk,
            f.size_sk,
            SUM(f.quantity_sold) AS quantity_sold,
            SUM(f.net_amount)    AS net_sales_amount
        FROM dbo.fact_sales AS f
        INNER JOIN dbo.dim_date AS d
            ON d.date_key = f.date_key
        WHERE f.date_key BETWEEN @date_key_from AND @date_key_to
          AND f.operation_type_code = 'SALE'
        GROUP BY
            d.week_start_date,
            f.store_sk,
            f.product_sk,
            f.size_sk
    ),
    returns_base AS
    (
        -- Zwroty w tej samej ziarnistości
        SELECT
            d.week_start_date,
            r.store_sk,
            r.product_sk,
            r.size_sk,
            SUM(r.quantity_returned) AS quantity_returned,
            SUM(r.refund_amount)     AS refund_amount
        FROM dbo.fact_returns AS r
        INNER JOIN dbo.dim_date AS d
            ON d.date_key = r.date_key
        WHERE r.date_key BETWEEN @date_key_from AND @date_key_to
        GROUP BY
            d.week_start_date,
            r.store_sk,
            r.product_sk,
            r.size_sk
    ),
    -- Zbiór kluczy z obu źródeł: zwrot może wystąpić bez sprzedaży w tym tygodniu.
    -- UNION (a nie UNION ALL) usuwa duplikaty kluczy występujące w obu zbiorach.
    combined_keys AS
    (
        SELECT week_start_date, store_sk, product_sk, size_sk FROM sales_base
        UNION
        SELECT week_start_date, store_sk, product_sk, size_sk FROM returns_base
    )
    SELECT
        k.week_start_date,
        s.store_code,
        p.product_code,
        p.product_name,
        sz.size_code,
        ISNULL(sb.quantity_sold, 0)       AS quantity_sold,
        ISNULL(rb.quantity_returned, 0)   AS quantity_returned,
        ISNULL(sb.net_sales_amount, 0.00) AS net_sales_amount,
        ISNULL(rb.refund_amount, 0.00)    AS refund_amount,
        -- Wskaźnik zwrotów w % sprzedaży netto; NULL, gdy brak sprzedaży (bez dzielenia przez zero)
        CAST(
            100.0 * ISNULL(rb.refund_amount, 0.00)
            / NULLIF(sb.net_sales_amount, 0.00)
            AS DECIMAL(9, 2)
        ) AS return_rate_pct
    FROM combined_keys AS k
    INNER JOIN dbo.dim_store   AS s  ON s.store_sk   = k.store_sk
    INNER JOIN dbo.dim_product AS p  ON p.product_sk = k.product_sk
    INNER JOIN dbo.dim_size    AS sz ON sz.size_sk   = k.size_sk
    -- LEFT JOIN: tydzień może mieć tylko sprzedaż albo tylko zwroty
    LEFT JOIN sales_base AS sb
        ON  sb.week_start_date = k.week_start_date
        AND sb.store_sk        = k.store_sk
        AND sb.product_sk      = k.product_sk
        AND sb.size_sk         = k.size_sk
    LEFT JOIN returns_base AS rb
        ON  rb.week_start_date = k.week_start_date
        AND rb.store_sk        = k.store_sk
        AND rb.product_sk      = k.product_sk
        AND rb.size_sk         = k.size_sk
    ORDER BY
        k.week_start_date,
        s.store_code,
        p.product_code,
        sz.size_code;
END;
```
