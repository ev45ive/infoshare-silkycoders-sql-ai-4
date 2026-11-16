# Mapowanie kolumn: <obiekt> (<ID>)

Jeden wiersz na kolumnę lub miarę w zakresie analizy. Czytaj od celu (raport) do źródła.

| Kolumna docelowa | Obiekt docelowy | Wyrażenie / transformacja | Kolumna źródłowa | Obiekt źródłowy | Typ źródło → cel | Reguła (filtr, join) | Dowód |
| --- | --- | --- | --- | --- | --- | --- | --- |
| <np. NetAmount> | `reporting.vw_...` | `SUM(<kolumna faktu>)` | <...> | `dbo.Fact...` | <DECIMAL → DECIMAL> | <JOIN do wymiarów> | `[KOD]` |
| <...> | `dbo.Fact...` | <wzór> | <...> | `stg....` | <...> | <...> | `[KOD]` |
| <...> | `stg....` | `TRY_CAST(<...>)` | <...> | `src....` | <NVARCHAR → ...> | <wiersz odrzucony przy braku konwersji> | `[KOD]` |

## Uwagi
- Zaokrąglenia, VAT, rabaty i inne wzory podaj dosłownie z kodu.
- Kolumny audytowe (np. identyfikator batcha, plik źródłowy) zapisz osobnymi wierszami.
