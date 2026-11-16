# Katalog hipotez: rozjazdy liczb

Lista startowa. Dopisuj nowe przyczyny, gdy wystąpią w praktyce. Dostosuj testy do konkretnych tabel (sprawdź DDL).

| Hipoteza | Typowy objaw | Ogólny test | Uwagi |
| --- | --- | --- | --- |
| Zwroty i korekty | Różnica zbliżona do sumy zwrotów | Suma zwrotów za okres (data przyjęcia vs data sprzedaży), netto i brutto | Sprawdź, czy zwroty zawierają VAT. Różnica większa niż różnica liczb zwykle wyklucza |
| Duplikaty ładowania | Różnica = suma identycznych wierszy | Grupowanie po kluczu naturalnym pozycji z `HAVING COUNT(*) > 1`, porównanie atrybutów kopii | Brak unikalności klucza w tabeli faktów dopuszcza duplikaty. Mechanizm sprawdź w lineage |
| Granica okresu | Różnica w dniach skrajnych miesiąca | Suma dla ostatniego i pierwszego dnia sąsiednich okresów | Data transakcji vs data rozliczenia, strefa czasowa |
| Kanał / sklep / filtr | Różnica skupiona w jednym segmencie | Podział liczby wg kanału i sklepu, porównanie z podziałem zgłaszającego | Raport może mieć inne filtry niż zestawienie zgłaszającego |
| VAT, rabat, zaokrąglenia | Mała, rozproszona różnica | Porównanie netto z brutto/stawką VAT i rabatem na próbce | Zaokrąglenia na poziomie pozycji vs paragonu |
| Odrzucone wiersze w ETL | Mniej wierszy w faktach niż w źródle | Bilans wierszy źródło → staging → fakt, log ładowania | Odrzucenia przez konwersję typów lub brak wymiaru |
| Utrata lub mnożenie wierszy na joinach | Wiersze znikają lub się powielają po dołączeniu wymiaru | Liczba wierszy przed i po joinie do wymiaru, klucze bez dopasowania, wiele dopasowań | Np. `INNER JOIN` do wymiaru wyklucza wiersze bez dopasowania `[KOD]` w `etl.LoadSales` |
| Różnica definicji metryki | Obie liczby poprawne, ale liczone inaczej | Porównanie definicji (przed/po zwrotach, netto/brutto, zakres) | Źródło: `docs/slownik-metryk.md` |
| Spóźnione lub poprawione dane | Liczba zmienia się w czasie | Porównanie `load_dts` / `ExtractedAt` z datą raportu | Zgłaszający liczył na innym stanie danych |
| Transakcje testowe / anulowane | Różnica w określonych sklepach lub kodach | Wiersze o nietypowych kodach, ujemnych ilościach lub zerowej cenie | Wymaga potwierdzenia reguł biznesowych |
| Waluta / przeliczenia | Różnica proporcjonalna | Porównanie kursów i walut w źródle | Dotyczy tylko, jeśli dane są wielowalutowe |

## Jak używać
1. Wybierz hipotezy pasujące do objawu (kwota, rozkład, proporcje).
2. Dla każdej wypełnij kartę hipotezy.
3. Zacznij od tanich zapytań o największym prawdopodobieństwie.
4. Po potwierdzeniu hipotezy zapytaj analityka, czy testować pozostałe.
