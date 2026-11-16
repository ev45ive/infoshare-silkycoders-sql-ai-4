# Handoff: rozjazd sprzedaży netto za sierpień 2026 (E02)

## 1. Cel analizy

Ustalić, skąd bierze się różnica 57 885,35 zł między naszym raportem a controllingiem i którą kwotę można zaraportować.

- Nasz raport: 2 666 549,81 zł
- Controlling (kasy + zamówienia online): 2 608 664,46 zł
- Różnica: 57 885,35 zł (ok. 2,2%)

## 2. Źródło / zgłoszenie

- Email: [inbox/E02- sierpien sie nie spina.md](inbox/E02-%20sierpien%20sie%20nie%20spina.md)
- Od: Tomasz Barski, controlling. Do: Zespół analiz. Temat: „Sierpień się nie spina — pilne”.
- Oczekiwana odpowiedź: „do jutra do południa” (wg daty emaila 18.09.2026, czyli 19.09.2026).
- Powiązane: [inbox/zgłoszenie-częściowych-zwrotów.md](inbox/zgłoszenie-częściowych-zwrotów.md) (zmiana ujęcia zwrotów w Net Revenue).

## 3. Podjęte decyzje

- Domyślna metryka do porównania: sprzedaż netto przed zwrotami (`NetAmount`), zgodnie z [docs/slownik-metryk.md](docs/slownik-metryk.md).
- Testy wykonywane po kolei wg kolejności hipotez (sekcja 5), od najszybszych.
- Zapytania na bazie uruchamia zespół lub po wyraźnej prośbie. Agent nie łączy się z bazą bez zgody.
- Nie zmieniamy definicji metryk ani widoków przed zamknięciem analizy.

## 4. Otwarte pytania

- [x] (odp.: `reporting.vw_SalesDaily`, zgodne co do grosza) Z którego raportu/widoku pochodzi kwota 2 666 549,81 zł? (kandydaci: `reporting.vw_SalesDaily`, `vw_SalesWeekly`, `vw_MarginAnalysis`, `vw_StoreScorecard`)
- [x] (odp.: przed zwrotami, `vw_SalesDaily` nie odejmuje zwrotów) Czy 2 666 549,81 zł jest przed czy po zwrotach?
- [x] (odp.: SQL Server, `RetailDW_Workshop`, wynik zgodny) Na której bazie liczono raport: SQL Server (T-SQL) czy PostgreSQL (`dw.fact_sales`)?
- [ ] Czy controlling może podać sumę za sierpień z podziałem na kanał (ONLINE / STORE) i sklep?
- [ ] Format `YearMonth` w `dim_date` (np. `2026-08` czy `202608`) do potwierdzenia.
- [ ] Termin z emaila (19.09.2026) minął. Czy termin jest aktualny, czy nowa data odpowiedzi?
- [ ] Jaka metoda VAT/zaokrągleń stosowana przez controlling (poziom pozycji czy paragonu)?

## 5. Plan działania

### Etap 0: Ustalenia (przed testami)
- Potwierdzić raport, bazę i ujęcie zwrotów (pytania 1–3 z sekcji 4).

### Etap 1: Zwroty (hipoteza H1, najszybsza)
- Test: suma `ReturnAmount / 1.23` za sierpień wg daty przyjęcia. Czy ok. 57 885 zł?
- Źródło: `reporting.vw_ProductPerformance` lub `fact_returns`.

### Etap 2: Duplikaty POS (H2)
- Test: identyczne pozycje w sierpniu załadowane dwa razy. Suma duplikatów vs 57 885 zł.
- Źródło: `src.SalesRaw` / `stg.Sales` / `fact_sales`.

### Etap 3: Kanał i sklep (H3)
- Test: sprzedaż netto wg `Channel` i sklepu. Porównanie z podziałem controllingu.
- Źródło: `reporting.vw_SalesDaily`.

### Etap 4: Granica dat (H4)
- Test: dni 31.07 i 1.09 — czy transakcje przesunięte między miesiącami.
- Źródło: `reporting.vw_SalesDaily`.

### Etap 5: VAT / rabat (H5, niska szansa)
- Test: `NetAmount` vs `GrossAmount / 1.23` i `GrossAmount - DiscountAmount` na próbce.

### Etap 6: Odpowiedź do controllingu
- Wskazać źródło różnicy, kwotę i rekomendowaną wartość do zaraportowania.
- Jeśli błąd po stronie hurtowni, napisać to wprost (wymóg z emaila).

## 6. Progress (uzupełniać na bieżąco)

### Status etapów

| Etap | Status | Data | Uwagi |
| --- | --- | --- | --- |
| 0. Ustalenia | completed | 16.11.2026 | Połączenie: serwer `127.0.0.1,14332`, baza `RetailDW_Workshop`, connectionId `c9ab2c06-ce87-4034-b1a8-95c347ff5faf` |
| 1. Zwroty (H1) | completed | 16.11.2026 | Nie wyjaśnia różnicy: zwroty sierpnia netto 86 939,02 zł |
| 2. Duplikaty POS (H2) | completed | 16.11.2026 | Wyjaśnia różnicę co do grosza: 223 zduplikowane pozycje = 57 885,35 zł |
| 3. Kanał i sklep (H3) | not-started | | |
| 4. Granica dat (H4) | not-started | | |
| 5. VAT / rabat (H5) | not-started | | |
| 6. Odpowiedź do controllingu | in-progress | 16.11.2026 | Szkic zapisany w sekcji "Szkic odpowiedzi do controllingu" (niewysłany). Krok 13 (duplikaty w całej historii) pominięty na wyraźną prośbę; ryzyko otwarte |

### Szkic odpowiedzi do controllingu (niewysłany, do zatwierdzenia)

Dzień dobry Tomaszu,

Błąd leży po naszej stronie. Różnica 57 885,35 zł wynika z duplikatu w danych POS za 17.08.2026: plik `POS_20260817_02.csv` jest kopią pliku `POS_20260817.csv` (223 wiersze, 97 transakcji). Nasz proces ładowania nie wykrywa takich duplikatów i przeniósł je do hurtowni.

Poprawna wartość sprzedaży netto za sierpień to 2 608 664,46 zł (nasz raport pokazywał 2 666 549,81 zł).

Działania: usuniemy zduplikowane wiersze z hurtowni, przeliczymy raport i dodamy kontrolę duplikatów w procesie ładowania.

Pozdrawiam

Zastrzeżenia: nie sprawdzono duplikatów w innych miesiącach (krok 13); nie ustalono, kto wygenerował plik `_02`; termin z emaila (19.09.2026) nieaktualny.

Statusy: `not-started`, `in-progress`, `completed`, `blocked`.

### Rejestr znalezisk

| Data | Etap | Znalezisko | Kwota / wynik | Źródło (zapytanie / plik) |
| --- | --- | --- | --- | --- |
| 16.11.2026 | 0 | `vw_SalesDaily` za sierpień: sprzedaż netto zgadza się z naszym raportem | 2 666 549,81 zł, 2154 wiersze | `reporting.vw_SalesDaily`, filtr po `SalesDate` |
| 16.11.2026 | 1 | Zwroty sierpnia (wg daty przyjęcia, `FactReturns`) | 675 szt., brutto 106 935,00 zł, netto 86 939,02 zł | `dbo.FactReturns` join `dbo.DimDate` |
| 16.11.2026 | 2 | Duplikaty w `FactSales` za sierpień: ten sam DateKey, StoreKey, TransactionNo, LineNumber, ProductKey | 223 grupy, każda po 2 identyczne wiersze, nadwyżka 223 wiersze = 57 885,35 zł netto | `dbo.FactSales` GROUP BY + HAVING COUNT(*) > 1 |
| 16.11.2026 | 2 | Bilans: 2 666 549,81 − 57 885,35 = 2 608 664,46 | Zgodne z kwotą controllingu co do grosza | Wyliczenie z wyników powyżej |
| 16.11.2026 | 2 | Wszystkie dane sierpnia w `FactSales` mają `LoadId` = 1 (1 batch, 10 738 wierszy) | Do wyjaśnienia, czy duplikaty pochodzą z jednego pliku | `dbo.FactSales` GROUP BY `LoadId` |
| 16.11.2026 | 2 (krok 6) | `src.SalesRaw`: format `SalesDate` to tekst `YYYY-MM-DD` | Potwierdzone na próbce (2026-08-10, POS_20260810.csv) | `src.SalesRaw`, SELECT TOP 5 |
| 16.11.2026 | 2 (krok 6) | `src.SalesRaw` za sierpień: klucz (TransactionNo, LineNumber, SKU, StoreCode) zdublowany | 223 klucze, 223 nadmiarowe wiersze, max 2 kopie; 0 kluczy w jednym pliku, 223 w różnych plikach | `src.SalesRaw` GROUP BY + COUNT(DISTINCT SourceFile) |
| 16.11.2026 | 2 (krok 7, lineage) | 16.11.2026 | 2 (krok 12, zakres historii) | W całej historii `src.SalesRaw` jest tylko jeden plik z sufiksem `_02` | 1 plik (`POS_20260817_02.csv`), 223 wiersze. Sprawdzono nazwy, nie zawartość pozostałych plików | `src.SalesRaw` LIKE `%_02.csv` (agregat) |
| 16.11.2026 | 2 (krok 11, liczba wierszy) | `POS_20260817_02.csv` to pełna kopia `POS_20260817.csv` z 17.08 | Oba pliki: 223 wiersze, 97 transakcji, wszystkie daty 2026-08-17. Wszystkie 223 wiersze `_02` mają pary w pierwszym pliku | `src.SalesRaw` GROUP BY `SourceFile` |
| 16.11.2026 | 2 (krok 10, pełne nazwy) | Wszystkie 223 pary to jedna para plików: `POS_20260817.csv` + `POS_20260817_02.csv` | 223 z 223 kluczy w jednej parze; sugeruje ponowny eksport tego samego dnia z sufiksem `_02` | `src.SalesRaw` GROUP BY pełne `SourceFile` |
| 16.11.2026 | 2 (krok 9, pary plików) | Oba wiersze każdej pary pochodzą z plików `POS_*` | 223 z 223 par: POS + POS; 0 par z innym prefiksem (np. WEB) | `src.SalesRaw` GROUP BY klucz, prefiks nazwy pliku (MIN/MAX SourceFile) |
| 16.11.2026 | 2 (krok 8, baza) | `stg.Sales` za sierpień: te same zdublowane klucze co w `src` | 223 klucze, 223 nadmiarowe wiersze; 0 w jednym pliku, 223 w różnych plikach. Potwierdza, że `stg` tylko przenosi duplikat | `stg.Sales` GROUP BY + COUNT(DISTINCT SourceFile), join `dbo.DimDate` |
| 16.11.2026 | 2 (krok 7, lineage, tylko kod) | `etl.LoadSales` nie deduplikuje: krok 1 przenosi do `stg.Sales` każdy wiersz, który przeszedł walidację TRY_CAST (bez DISTINCT, bez filtra po `SourceFile`); krok 2 wstawia każdy wiersz `stg` do `FactSales` | Duplikat przechodzi z `src` przez `stg` do `dbo` bez zmian | `RetailDW/Procedures/etl.LoadSales.sql` (kod, bez zapytania do bazy) |

### Rejestr decyzji

| Data | Decyzja | Kto zaakceptował |
| --- | --- | --- |
| 16.11.2026 | Połączenie z bazą `RetailDW_Workshop` przez `mssql_connect` (zgoda użytkownika na pętlę zapytań) | Użytkownik |
| 16.11.2026 | Kolejność testów: H1 → H2 → H3 → H4 → H5 | Użytkownik |

### Nowe otwarte pytania

- [ ] Skąd w `src.SalesRaw` wzięły się zduplikowane wiersze: dwa pliki POS z tą samą zawartością czy dwa wiersze w jednym pliku? (`SourceFile` ma 1257 różnych nazw)
- [ ] Czy duplikaty występują także w innych miesiącach? Czy ETL (`etl.LoadSales`) powinien odrzucać duplikaty po kluczu pozycji?
- [ ] Czy controlling potwierdza, że w ich 2 608 664,46 zł nie ma duplikatów (czyli 223 pozycje są błędem)?
- [ ] Termin odpowiedzi z emaila (19.09.2026) jest nieaktualny. Nowa data?

### Notatki agenta

- Pętla 1: H1 nie wyjaśnia różnicy (zwroty 86 939,02 zł netto > 57 885,35 zł). Zwroty są liczone wg daty przyjęcia, więc nie są przyczyną rozbieżności.
- Pętla 1: H2 wyjaśnia różnicę dokładnie. Wynik do potwierdzenia u controllingu i w źródle (`src.SalesRaw`).
- Tryb pracy: krok po kroku. Każdy krok (zapytanie) pokazywany i zatwierdzany przed wykonaniem. Wyniki z pętli 1 wykonano przed zatwierdzeniem, do ponownej weryfikacji w tym trybie.
- Uwaga: `vw_SalesDaily` dla sierpnia daje `GrossAmount` 3 279 851,00 i `DiscountAmount` 0,00. Netto × 1,23 nie daje dokładnie brutto (różnica ok. 5 zł), to zaokrąglenia, bez wpływu na wynik.
