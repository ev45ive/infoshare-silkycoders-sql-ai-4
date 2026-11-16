# Kroki procesu: analiza lineage

Domyślny kierunek: **od raportu w dół** (raport → ... → źródło). Na życzenie analityka można iść od źródła w górę. Każdy krok kończy się bramką ([protokół interakcji](./protokol-interakcji.md)). Kroki można rozszerzać bez zmiany `SKILL.md`. Gdzie szukać w repo: [warstwy-repo](./warstwy-repo.md).

## Krok 0. Start i dostęp do bazy
- Przeczytaj `handoff.md` i `progress.md` (jeśli są). Pokaż podsumowanie.
- Zapytaj raz o zgodę na zapytania SELECT tylko do odczytu w tej sesji i zapisz w "Decyzjach". Połącz się (zob. [zasady](./zasady-i-checklisty.md)).
- Bez zgody lub bez bazy: lineage z kodu, wszystkie ogniwa `[KOD]`, wprost to zaznacz.
- Bramka: ID analizy, folder, połączenie.

## Krok 1. Cel i zakres lineage
- Ustal: obiekt (metryka, kolumna, widok), po co (wyjaśnienie liczby, dokumentacja, audyt), kierunek, **granicę** (do `src`, do pliku, do systemu źródłowego).
- Ustal **przypadek referencyjny**: okres, transakcja lub agregat, który będziemy mierzyć w każdej warstwie.
- Bramka: analityk potwierdza zakres i przypadek.

## Krok 2. Warstwa raportowa
- Przeczytaj widok lub zapytanie raportowe. Wypisz: wyrażenie liczące miarę, źródłowe tabele, joiny (rodzaj), filtry, grupowanie, kolumny wyliczane.
- `[DB]` (opcjonalnie): odtwórz liczbę z przypadku referencyjnego w widoku.
- Wyjście: wpis w mapowaniu kolumn (kolumna raportu → wyrażenie) i pierwsze ogniwo diagramu.
- Bramka.

## Krok 3. Fakty i wymiary
- Przeczytaj DDL tabel faktów i wymiarów użytych w widoku: ziarno, klucze, ograniczenia unikalności, kolumny audytowe, kolumny wyliczane.
- Sprawdź: czy ziarno i unikalność chronią przed duplikatami? Czy wymiary mają wiersz "nieznany" (-1)?
- `[DB]`: liczba z przypadku referencyjnego w tabeli faktów (czy zgadza się z raportem?).
- Bramka.

## Krok 4. ETL
- Przeczytaj procedurę ładującą. Wypisz: źródło i cel każdego kroku, transformacje (wzory miar), filtry, rodzaje joinów (utrata lub powielenie wierszy), kolejność, tryb ładowania (pełny/przyrostowy), idempotencję, deduplikację, obsługę błędów, logowanie.
- Dla każdej transformacji dopisz wiersz do mapowania kolumn.
- Wyjście: lista "gdzie wiersz może zniknąć lub się powielić".
- Bramka.

## Krok 5. Staging
- Przeczytaj DDL tabel staging i krok ETL, który je zasila. Wypisz konwersje typów, walidacje, odrzucenia.
- `[DB]`: bilans `src` → `stg` dla przypadku referencyjnego (liczba wierszy wejścia i wyjścia, wiersze odrzucone).
- Bramka.

## Krok 6. Warstwa src
- Przeczytaj DDL tabel landing: typy (czy tekstowe), brak ograniczeń, kolumny identyfikujące plik i czas załadunku.
- `[DB]`: przypadek referencyjny w `src` (agregaty; duże tabele ostrożnie, zob. [zasady](./zasady-i-checklisty.md)).
- Bramka.

## Krok 7. Pliki i system źródłowy
- Sprawdź, skąd trafiają dane do `src`: pliki (`data/`, manifest), nazwy plików, daty plików, mechanizm załadunku (skrypty).
- Duże pliki: nie czytaj w całości. Użyj wyszukiwania, liczenia wierszy, próbki kilku linii.
- Zapisz, czego nie da się ustalić z repo (np. kto i kiedy eksportuje pliki) jako pytanie do analityka.
- Bramka.

## Krok 8. Bilans między warstwami
- Tabela per warstwa: wejście, wyjście, różnica, wyjaśnienie, dowód. Dla wierszy i dla wartości (miary).
- Wskaż warstwę, w której powstaje różnica, duplikat, strata lub zmiana definicji. Jeśli brak anomalii, napisz to wprost.
- Bramka: czy bilans jest przekonujący? Czegoś brakuje?

## Krok 9. Raport, diagramy, mapowanie
- Wygeneruj `lineage.md` z [szablonu](../assets/lineage-template.md), `mapowanie-kolumn.md` z [szablonu](../assets/mapowanie-kolumn-template.md) i `diagramy.md` z [szablonu](../assets/diagram-template.md).
- Sprawdź [checklistę raportu](./zasady-i-checklisty.md#checklista-raportu-lineage).
- Bramka: zatwierdzenie lub korekty.

## Krok 10. Domknięcie
- Zaktualizuj `handoff.md` (status, wnioski, ryzyka, rekomendacje, następny krok) i `progress.md`.
- Rekomendacje zmian (kontrole jakości, deduplikacja, ograniczenia unikalności, dokumentacja) zapisz jako **propozycje**, bez wdrażania.
- Podsumuj w czacie: ścieżka danych, warstwa różnicy, ryzyka, pliki.
