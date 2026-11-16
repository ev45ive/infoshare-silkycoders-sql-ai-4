# Handoff: Rozjazd sprzedaży netto sierpień 2026 (E02-sierpien)

> Ostatnia aktualizacja: 2026-11-16 | Ostatni skill: analiza-zgloszenia | Status: w toku

## 1. Cel
Wyjaśnić różnicę 57 885,35 zł [WNIOSEK] między sprzedażą netto za sierpień 2026 wg controllingu (2 608 664,46 zł, kasy + online) a naszym raportem (2 666 549,81 zł) i ustalić, którą kwotę raportować.
Kryterium ukończenia: różnica rozbita na przyczyny z dowodem (zapytanie lub plik), a kwota do raportowania uzgodniona z controllingiem.

## 2. Źródło zgłoszenia
- Plik / wiadomość: [inbox/E02- sierpien sie nie spina.md](../../../inbox/E02-%20sierpien%20sie%20nie%20spina.md)
- Od / do / data: Tomasz Barski (controlling) / Zespół analiz / 18 wrz 2026, 16:42
- Termin: 19 wrz 2026, "do jutra do południa" (aktualny: nie, minął 2026-11-16)
- Powiązane: [inbox/zgłoszenie-częściowych-zwrotów.md](../../../inbox/zgłoszenie-częściowych-zwrotów.md) (zmiana Net Revenue o częściowe zwroty; poza zakresem, nie zmieniamy definicji w tej analizie)

## 3. Kontekst i definicje
| Element | Wartość | Dowód |
| --- | --- | --- |
| Metryka | Sprzedaż netto = suma `NetAmount`, przed zwrotami | `[DOK]` [slownik-metryk.md](../../slownik-metryk.md) |
| Okres | Sierpień 2026 | `[ZGŁ]` |
| Zakres | Kasy i system zamówień online (kanały `STORE`, `ONLINE`) | `[ZGŁ]` |
| Raport / źródło liczby | `reporting.vw_SalesDaily`, `reporting.vw_SalesWeekly` (SQL Server, `RetailDW/`) | `[KOD]` |
| Wyliczenie NetAmount | `(Quantity * UnitPrice - DiscountAmount) / 1.23` | `[KOD]` [etl.LoadSales.sql](../../../RetailDW/Procedures/etl.LoadSales.sql) |
| Źródło danych | `sales.csv`, 191 225 wierszy, kolumna `SourceFile` | `[DOK]` [manifest.json](../../../data/P0/manifest.json) |

Uwaga: [slownik-metryk.md](../../slownik-metryk.md) opisuje bazę PostgreSQL `retaildw`, a w workspace jest SQL Server. Zakładam SQL Server (potwierdzone przez analityka) [ZAŁ, do potwierdzenia przy kolejnym kroku].

## 4. Co wiemy
| # | Stwierdzenie | Dowód | Źródło |
| --- | --- | --- | --- |
| 1 | Controlling: 2 608 664,46 zł netto za sierpień 2026 | `[ZGŁ]` | inbox/E02 |
| 2 | Nasz raport: 2 666 549,81 zł | `[ZGŁ]` | inbox/E02 |
| 3 | Różnica 57 885,35 zł (nasz raport wyższy) | `[WNIOSEK]` (obliczenie) | pkt 1–2 |
| 4 | Sprzedaż netto w raporcie to suma `NetAmount` bez odjęcia zwrotów | `[KOD]` | vw_SalesDaily / vw_SalesWeekly |
| 5 | ETL `etl.LoadSales` nie deduplikuje wierszy; `SourceFile` nie jest filtrem | `[KOD]` | etl.LoadSales.sql |
| 6 | ETL odrzuca wiersze z błędną konwersją i bez dopasowania wymiaru (`JOIN`); liczba w `LoadLog.RowsRejected` | `[KOD]` | etl.LoadSales.sql |
| 7 | ETL działa jako pełne przeładowanie (truncate + load) | `[KOD]` | etl.LoadSales.sql |
| 8 | Słownik i repo opisują różne bazy (PostgreSQL vs SQL Server) | `[DOK]` + `[KOD]` | slownik-metryk.md, RetailDW/ |

## 5. Decyzje
| Data | Decyzja | Kto zaakceptował |
| --- | --- | --- |
| 2026-11-16 | Źródło raportu: SQL Server (`RetailDW/`) | Analityk |
| 2026-11-16 | Sformułowanie problemu i kryterium ukończenia (krok 2) | Analityk |
| 2026-11-16 | Nie czytamy ani nie używamy istniejących handoffów E02 (`docs/handoff-E02-sierpien.md`); analiza od nowa | Analityk |
| 2026-11-16 | Nie zmieniamy definicji sprzedaży w trakcie analizy | Zasada z zasady-i-checklisty |
| 2026-11-16 | Ryzyka zaakceptowane; termin eskalowany | Analityk |
| 2026-11-16 | Nasz raport: wszystkie kanały i sklepy; okres wg daty sprzedaży | Analityk |
| 2026-11-16 | Szkic pytań do controllingu zaakceptowany (niewysłany) | Analityk |

## 6. Otwarte pytania
- [x] (blokujące) Zakres naszego raportu: wszystkie kanały i sklepy. Okres: data sprzedaży (`SalesDate` / `DateKey`). | do: analityk | odpowiedź z kroku 4
- [ ] (blokujące) Czy controlling liczy sprzedaż netto przed czy po zwrotach? | do: controlling (T. Barski) | po co: wykluczenie różnicy w definicji
- [ ] (blokujące) Czy kwota 2 608 664,46 zł obejmuje wszystkie kasy i cały online, czy tylko część? | do: controlling | po co: porównanie zakresu
- [ ] (blokujące) Nowy termin odpowiedzi (poprzedni minął). | do: controlling | po co: plan pracy
- [ ] (niekrytyczne) Czy controlling ma wykaz paragonów lub plik z kas, którym można porównać liczby? | do: controlling | po co: zejście do poziomu transakcji

## 7. Ryzyka i zastrzeżenia
- [ESKALOWANE] Termin minął (19 wrz 2026). Odpowiedź wymaga nowego terminu z controllingiem.
- [AKCEPTOWANE] Zmiana definicji z powiązanego zgłoszenia o zwrotach nie wchodzi w zakres; osobne zadanie.
- [AKCEPTOWANE] Dane osobowe: brak w zgłoszeniu poza nazwiskami nadawcy, nic do maskowania.
- [AKCEPTOWANE] Brak odpowiedzi controllingu na pytania o zwroty i zakres kwoty blokuje wniosek; plan obejmuje oba warianty.
- Możliwe przyczyny różnicy [ZAŁ], niepotwierdzone: duplikaty wierszy (brak deduplikacji, `SourceFile`); wiersze odrzucone przez ETL lub bez dopasowania wymiaru; różnica w ujęciu zwrotów; różnica w zakresie kanałów (kasy vs online).
- Nie sprawdzono danych CSV, zawartości bazy ani rozkładu `SourceFile`. Wnioski z kodu nie są wynikiem z bazy.
- Powiązane zgłoszenie o częściowych zwrotach może zmienić definicję sprzedaży netto. Nie zmieniamy definicji w tej analizie.
- Słownik opisuje PostgreSQL, repo ma SQL Server. Przed porównaniem trzeba potwierdzić, który system jest źródłem.

## 8. Następny krok
Krok 4 (pytania) wg [kroki-procesu](../../../.github/skills/analiza-zgloszenia/references/kroki-procesu.md): zatwierdzić listę pytań blokujących, przygotować szkic do controllingu w `pytania-do-zglaszajacego.md`, potem krok 5 (ryzyka) i krok 6 (plan, rekomendacja [analiza-danych](../../../.github/skills/analiza-danych/SKILL.md)).

## 9. Pliki analizy
- [progress.md](./progress.md)
