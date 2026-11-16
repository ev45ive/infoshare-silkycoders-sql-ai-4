# Progress: Rozjazd sprzedaży netto sierpień 2026 (E02-sierpien)

> Aktualizuj po każdym kroku. Statusy: `not-started`, `in-progress`, `completed`, `blocked`.

## Status etapów
| Etap | Status | Data | Uwagi |
| --- | --- | --- | --- |
| 0. Start (ID, folder) | completed | 2026-11-16 | ID `E02-sierpien`; istniejących handoffów nie czytano |
| 1. Wczytanie zgłoszenia | completed | 2026-11-16 | Fakty ze zgłoszenia, słownika, kodu ETL i widoków |
| 2. Sformułowanie problemu | completed | 2026-11-16 | Zaakceptowane przez analityka |
| 3. Co wiemy / zakładamy / nie wiemy | completed | 2026-11-16 | Patrz handoff pkt 4 |
| 4. Pytania | completed | 2026-11-16 | Szkic do controllingu zaakceptowany; zakres naszego raportu potwierdzony |
| 5. Ryzyka i zależności | completed | 2026-11-16 | Termin eskalowany; reszta zaakceptowana |
| 6. Plan i rekomendacja | not-started | | Kandydat: analiza-danych |
| 7. Zapis i domknięcie | not-started | | |

## Rejestr znalezisk
| Data | Etap | Znalezisko | Wynik / kwota | Dowód | Źródło (ID zapytania / plik) |
| --- | --- | --- | --- | --- | --- |
| 2026-11-16 | 1 | Controlling: sprzedaż netto sierpień 2026 | 2 608 664,46 zł | `[ZGŁ]` | inbox/E02- sierpien sie nie spina.md |
| 2026-11-16 | 1 | Nasz raport: sprzedaż netto sierpień 2026 | 2 666 549,81 zł | `[ZGŁ]` | inbox/E02- sierpien sie nie spina.md |
| 2026-11-16 | 1 | Różnica (nasz raport wyższy) | 57 885,35 zł | `[WNIOSEK]` | obliczenie z dwóch kwot powyżej |
| 2026-11-16 | 1 | NetAmount = (Qty * UnitPrice - Discount) / 1.23, bez odjęcia zwrotów | n/d | `[KOD]` | RetailDW/Procedures/etl.LoadSales.sql |
| 2026-11-16 | 1 | ETL bez deduplikacji; odrzucone wiersze liczone w LoadLog | n/d | `[KOD]` | RetailDW/Procedures/etl.LoadSales.sql |
| 2026-11-16 | 1 | Słownik opisuje PostgreSQL, repo ma SQL Server | n/d | `[DOK]` + `[KOD]` | docs/slownik-metryk.md |
| 2026-11-16 | 1 | Źródło raportu: SQL Server (`RetailDW/`) | n/d | `[ZGŁ]` (odpowiedź analityka) | pytanie w bramce kroku 1 |

## Rejestr zapytań
Pełny SQL w zapytania.sql (jeszcze nie utworzono). Tu tylko indeks.

| ID | Etap / krok | Cel | Wynik w skrócie | Wykonano |
| --- | --- | --- | --- | --- |
| | | | | |

## Dziennik kroków
| Data | Krok | Co zrobiono | Decyzja analityka |
| --- | --- | --- | --- |
| 2026-11-16 | 0 | Ustalono ID `E02-sierpien`; pominięto istniejące handoffy (zgodnie z poleceniem) | Brak uwag |
| 2026-11-16 | 1 | Wczytano zgłoszenie, słownik, zgłoszenie o zwrotach, kod ETL i widoki | Idziemy dalej; źródło: SQL Server |
| 2026-11-16 | 2 | Sformułowano problem i kryterium ukończenia | Akceptacja |
| 2026-11-16 | 3 | Podział: wiemy / zakładamy / nie wiemy; zapis handoffu i progressu | Idziemy dalej |
| 2026-11-16 | 4 | Szkic pytań do controllingu; pytania do analityka (zakres, data) | Wszystkie kanały i sklepy; data sprzedaży; szkic OK |

## Notatki agenta
- Różnica 57 885,35 zł może wynikać z przyczyn, które nie są jeszcze potwierdzone (patrz handoff pkt 7). Nie traktować jako wniosku.
- Termin z zgłoszenia (19 wrz 2026) minął. Nowy termin do ustalenia z controllingiem.
- Zmiana definicji z powiązanego zgłoszenia o zwrotach nie jest częścią tej analizy.
