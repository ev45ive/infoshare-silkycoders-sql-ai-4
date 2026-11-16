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

- [ ] Z którego raportu/widoku pochodzi kwota 2 666 549,81 zł? (kandydaci: `reporting.vw_SalesDaily`, `vw_SalesWeekly`, `vw_MarginAnalysis`, `vw_StoreScorecard`)
- [ ] Czy 2 666 549,81 zł jest przed czy po zwrotach?
- [ ] Na której bazie liczono raport: SQL Server (T-SQL) czy PostgreSQL (`dw.fact_sales`)?
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
| 0. Ustalenia | not-started | | |
| 1. Zwroty (H1) | not-started | | |
| 2. Duplikaty POS (H2) | not-started | | |
| 3. Kanał i sklep (H3) | not-started | | |
| 4. Granica dat (H4) | not-started | | |
| 5. VAT / rabat (H5) | not-started | | |
| 6. Odpowiedź do controllingu | not-started | | |

Statusy: `not-started`, `in-progress`, `completed`, `blocked`.

### Rejestr znalezisk

| Data | Etap | Znalezisko | Kwota / wynik | Źródło (zapytanie / plik) |
| --- | --- | --- | --- | --- |
| | | | | |

### Rejestr decyzji

| Data | Decyzja | Kto zaakceptował |
| --- | --- | --- |
| | | |

### Nowe otwarte pytania

- [ ]

### Notatki agenta

-
