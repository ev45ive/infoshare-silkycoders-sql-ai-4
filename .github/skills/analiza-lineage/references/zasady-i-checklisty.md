# Zasady i checklisty: analiza lineage

## Dowody
- Znaczniki: `[KOD]` definicja w repo, `[DOK]` dokumentacja, `[DB]` wynik zapytania, `[WNIOSEK]` interpretacja, `[ZAŁ]` założenie do potwierdzenia, `[ZGŁ]` zgłoszenie.
- Każde ogniwo lineage ma `[KOD]`. Tam, gdzie wniosek zależy od stanu danych (duplikaty, odrzucenia), dodaj `[DB]`.
- Kod w repo może różnić się od tego, co działa w bazie. Jeśli to istotne, porównaj definicję w bazie z repo (wyciąg definicji pojedynczego obiektu, nie zrzut schematu) i zaznacz wynik.
- Gdy analityk pyta "z kodu czy z bazy?", odpowiedz zgodnie z prawdą.

## Połączenie i zgoda
- Zasady jak w analizie danych: jedna zgoda na sesję dla SELECT tylko do odczytu, zapisana w "Decyzjach". Brak zapisu, DDL i uruchamiania procedur `etl.*`.
- Narzędzia `mssql_*` załaduj przez wyszukiwanie narzędzi. Połącz przez `mssql_list_servers` i `mssql_connect`. `connectionId` jest sesyjny. Nie zapisuj haseł ani connection stringów.

## Bezpieczeństwo zapytań
- Tylko SELECT i CTE. Domyślnie agregaty, szczegóły z `TOP (n)`, n ≤ 20.
- Przed szczegółem policz wiersze (`COUNT(*)`).
- Filtruj po zakresie dat lub kluczu, bez funkcji na kolumnie. W `src` daty bywają tekstem: sprawdź typ i format na próbce, zanim użyjesz filtra.
- Nie skanuj pełnej historii dużych tabel bez zgody. Zaproponuj okres lub próbkę.
- Nie zrzucaj metadanych szerokimi zapytaniami. Definicje czytaj z DDL w `RetailDW/`.
- Nie wypisuj danych osobowych.
- Parametry narzędzia: `queryTypes` tylko z listy narzędzia (`SELECT`, `JOIN`, `CTE`; `GROUP_BY` jest nieprawidłowe), `queryIntent` np. `data_analysis`.
- Pełny SQL każdego zapytania pokaż w raporcie kroku i zapisz w `zapytania.sql` z ID `Qnn`.

## Co opisać w każdej warstwie
- [ ] Obiekt i ścieżka w repo.
- [ ] Wejście (skąd bierze dane) i wyjście (dokąd trafiają).
- [ ] Transformacje i wzory (miary, konwersje, zaokrąglenia, VAT).
- [ ] Filtry (WHERE, walidacje) i rodzaje joinów: gdzie wiersz może zniknąć lub się powielić.
- [ ] Ziarno i klucz. Czy unikalność jest wymuszona?
- [ ] Deduplikacja: jest czy brak.
- [ ] Tryb ładowania (pełny/przyrostowy), idempotencja, logowanie.
- [ ] Kolumny audytowe (`load_dts`, `record_source`, `etl_batch_id` lub odpowiedniki w DDL).
- [ ] Ryzyka i luki wiedzy.

## Czerwone flagi
- Brak ograniczenia unikalności na kluczu naturalnym w tabeli faktów.
- `INNER JOIN` do wymiaru bez obsługi braku dopasowania (wiersze cicho znikają).
- Dane w `src` jako tekst bez walidacji i konwersja z `TRY_CAST` (wiersze cicho odrzucane).
- Pełne przeładowanie (usuń i wstaw): stan zależy od aktualnej zawartości `src`.
- Brak deduplikacji między plikami o podobnych nazwach (np. ponowny eksport).
- Różne definicje tej samej miary w różnych widokach.

## Checklista raportu lineage
- [ ] Zakres, obiekt i przypadek referencyjny opisane na początku.
- [ ] Każda warstwa ma opis wg listy "Co opisać w każdej warstwie".
- [ ] Bilans wierszy i wartości między warstwami z dowodami (`Qnn`).
- [ ] Wskazana warstwa różnicy lub jasne "brak anomalii".
- [ ] Mapowanie kolumn kompletne dla miar i kluczy objętych zakresem.
- [ ] Diagram przepływu zgodny z tabelą warstw i mapowaniem.
- [ ] Rozdzielone `[KOD]` i `[DB]`. Wnioski oznaczone jako `[WNIOSEK]`.
- [ ] Luki wiedzy (np. kto generuje pliki) zapisane jako pytania.
- [ ] Rekomendacje oznaczone jako propozycje, bez wdrożeń.
- [ ] Brak danych osobowych.
