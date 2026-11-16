# Warstwy repozytorium RetailDW

Mapa miejsc do sprawdzenia w lineage. Aktualizuj, gdy architektura się zmienia. Nie zgaduj nazw: potwierdź w plikach.

| Warstwa | Schemat | Gdzie w repo | Co sprawdzić |
| --- | --- | --- | --- |
| Raportowa | `reporting` | `RetailDW/Views/reporting.vw_*.sql` | Wyrażenia miar, joiny, filtry, grupowanie, nagłówek (ziarnistość, źródła) |
| Fakty i wymiary | `dbo` | `RetailDW/Tables/dbo.*.sql` | Ziarno, klucze, unikalność, kolumny audytowe, wyliczane |
| ETL | `etl` | `RetailDW/Procedures/etl.Load*.sql` | Kroki, wzory miar, joiny do wymiarów, tryb ładowania, obsługa błędów, log |
| Log ładowania | `dbo` | `RetailDW/Tables/dbo.LoadLog.sql` | Liczba wierszy odczytanych, załadowanych, odrzuconych, status, batch |
| Staging | `stg` | `RetailDW/Tables/stg.*.sql` | Typy po konwersji, kolumny identyfikujące plik i batch |
| Landing | `src` | `RetailDW/Tables/src.*Raw.sql` | Typy (tekst), brak ograniczeń, plik źródłowy, czas załadunku |
| Dane początkowe wymiarów | `dbo` | `RetailDW/Scripts/Seed/`, `RetailDW/Scripts/PostDeployment.sql` | Skąd pochodzą wymiary i wiersz "nieznany" |
| Pliki źródłowe | n/d | `data/P0/` (CSV, `manifest.json`) | Nazwy i liczba plików, manifest, format dat |
| Załadunek plików | n/d | `scripts/dw.ps1` (`Import-Pack`, `Run-ETL`) | Import plików z manifestu do `src` (SqlBulkCopy), uruchamianie ETL, kolejność |
| Definicje metryk | n/d | `docs/slownik-metryk.md` | Obowiązująca definicja miary |
| Konwencje | n/d | `docs/sql-best-practices.md` | Nazewnictwo, kolumny audytowe, zasady ładowania |
| Opis bazy | n/d | `docs/analiza-bazy.md` | Architektura, proces ETL z diagramami (sekcja 6), pułapki i ograniczenia (sekcja 8) |

## Typowe ścieżki
Sprzedaż: `reporting.vw_*` → `dbo.FactSales` (+ `DimDate`, `DimStore`, `DimProduct`) → `etl.LoadSales` → `stg.Sales` → `src.SalesRaw` → pliki w `data/P0/`.

Zwroty i zapasy mają analogiczne ścieżki (`FactReturns`, `FactInventoryDaily`, procedury `etl.LoadReturns`, `etl.LoadInventory`). Potwierdź w plikach, zanim użyjesz tej mapy.

## Uwagi
- Potwierdź, że definicja w repo odpowiada temu, co działa w bazie, jeśli wniosek od tego zależy.
- Dokumentacja może opisywać dwie platformy (SQL Server i PostgreSQL). Pracujemy na SQL Server, chyba że analityk wskaże inaczej.
