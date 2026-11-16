# Zasady i checklisty: analiza danych

## Połączenie
- Narzędzia `mssql_*` są odroczone: załaduj je przez wyszukiwanie narzędzi przed użyciem.
- Znajdź serwer (`mssql_list_servers`), połącz (`mssql_connect`, profil tylko jeśli analityk go wskazał). Nie zgaduj nazwy bazy: w razie błędu wylistuj bazy.
- `connectionId` jest sesyjny i może wygasnąć. Nie traktuj go jako stałej. W handoffie zapisuj serwer i bazę, nie hasła ani connection stringi.
- Po utracie połączenia połącz ponownie i poinformuj analityka.

## Zgoda na bazę
- Raz na sesję zapytaj o zgodę na zapytania SELECT tylko do odczytu. Zapisz w "Decyzjach".
- Poza zgodą: INSERT, UPDATE, DELETE, DDL, EXEC procedur (w tym `etl.*`). Wymagają osobnej, wyraźnej zgody i zwykle nie powinny być wykonywane w analizie.
- Brak zgody: pracuj na kodzie i dokumentach i oznacz wnioski jako `[KOD]`.

## Bezpieczeństwo zapytań
- Tylko SELECT i CTE. Bez tabel tymczasowych i zmiennych tabelarycznych, jeśli nie są konieczne.
- Domyślnie **agregaty**. Szczegóły tylko z `TOP (n)` (n ≤ 20) i uzasadnieniem.
- Przed szczegółem policz (`COUNT(*)`), ile wierszy zwróci zapytanie.
- Filtruj po kluczu lub zakresie dat. Nie stosuj funkcji na filtrowanej kolumnie (zakres `>= ... AND < ...`).
- Nie skanuj pełnej historii dużych tabel bez zgody. Zaproponuj próbkę lub okres. Zgłoś analitykowi, że to obciążenie bazy.
- Nie zrzucaj metadanych (`INFORMATION_SCHEMA`, `sys.columns`) szerokim zapytaniem. Definicje czytaj z DDL w `RetailDW/`.
- Nie wypisuj danych osobowych. Jeśli są w wyniku, maskuj w raporcie.
- Wynik zbyt duży: skróć zapytanie, nie przeklejaj całości.

## Parametry narzędzia zapytań
- `queryTypes`: tylko wartości z listy narzędzia (np. `SELECT`, `JOIN`, `CTE`). `GROUP_BY` jest nieprawidłowe.
- `queryIntent`: np. `data_analysis`, `data_exploration`, `troubleshooting`.

## Styl SQL (źródło: `docs/sql-best-practices.md`)
- Słowa kluczowe wielkimi literami, jawne `INNER JOIN` / `LEFT JOIN`, brak `SELECT *`.
- `NOT EXISTS` zamiast `NOT IN`, `NULLIF` przed dzieleniem, `ISNULL` dla miar po `LEFT JOIN`.
- Nazwy obiektów w nawiasach `[ ]`, schemat zawsze podany.
- Nie zgaduj nazw tabel i kolumn: sprawdź `RetailDW/Tables/`, `RetailDW/Views/`. Typ kolumny (np. tekst w `src`) sprawdź przed filtrem dat.

## Dowody
- Każda liczba w raporcie: znacznik (`[DB]`, `[KOD]`, `[DOK]`, `[WNIOSEK]`, `[ZAŁ]`) i ID zapytania.
- Wniosek z kodu (np. "ETL nie deduplikuje") to nie potwierdzenie w danych. Oznacz i, jeśli to ważne, potwierdź zapytaniem.
- Dopasowanie liczby co do grosza wskazuje mechanizm, ale go nie dowodzi. Opisz mechanizm i podaj, co jeszcze trzeba sprawdzić.
- Liczby podawaj z jednostką, okresem i zakresem.

## Hipotezy
- Formułuj falsyfikowalnie: test, oczekiwany wynik, kryterium odrzucenia.
- Tanie i prawdopodobne najpierw.
- Jedno zapytanie na krok. Werdykt dopiero po komplecie testów hipotezy.
- Nie zmieniaj hipotezy po fakcie, by pasowała do wyniku. Nową hipotezę dopisz jako nową.

## Checklista przed raportem końcowym
- [ ] Liczba bazowa odtworzona i źródło raportu potwierdzone.
- [ ] Każda hipoteza ma werdykt i uzasadnienie.
- [ ] Most (rekonsyliacja) zamyka się do 0,00 albo reszta jest nazwana.
- [ ] Każda liczba ma ID zapytania, a zapytanie jest w `zapytania.sql`.
- [ ] Zakres i okres liczb zgadzają się z pytaniem (te same filtry, ta sama definicja metryki).
- [ ] Wiadomo, czego nie sprawdzono, i jest to w ryzykach.
- [ ] Brak danych osobowych w raporcie.
- [ ] Szkic odpowiedzi nie obiecuje tego, czego nie potwierdzono.
- [ ] Termin i status zgłoszenia zaktualizowane w handoffie.
