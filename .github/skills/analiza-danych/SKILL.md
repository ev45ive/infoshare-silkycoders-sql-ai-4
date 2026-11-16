---
name: analiza-danych
description: "Interaktywna analiza danych w hurtowni RetailDW: szukanie konkretnych odpowiedzi na pytania biznesowe z dowodami i uzasadnieniem, np. skąd rozjazd liczb, dlaczego raport pokazuje inną kwotę, odtworzenie liczby krok po kroku, testowanie hipotez zapytaniami SQL (SQL Server). Pętla hipotez z bramką po każdym kroku, handoff i progress w docs/analizy/<ID>/. Use when: rozjazd sprzedaży, rekonsyliacja z controllingiem, weryfikacja hipotezy, odtworzenie liczby z raportu, pytanie biznesowe wymagające zapytań do bazy."
argument-hint: "Pytanie biznesowe lub <ID> istniejącej analizy w docs/analizy/"
---

# Analiza danych

Drugi skill w łańcuchu: [analiza-zgloszenia](../analiza-zgloszenia/SKILL.md) → **analiza-danych** → [analiza-lineage](../analiza-lineage/SKILL.md).
Cel: odpowiedzieć na pytanie biznesowe liczbami, z dowodami (zapytania, wyniki) i uzasadnieniem. Analityk widzi każdy krok i decyduje o kolejnym.

## Kiedy używać
- Jest pytanie biznesowe lub liczba do wyjaśnienia (np. różnica między raportem a controllingiem).
- Trzeba odtworzyć liczbę z raportu i przetestować hipotezy o przyczynie.
- Nie używaj do ustalania zadania (to [analiza-zgloszenia](../analiza-zgloszenia/SKILL.md)) ani do śledzenia pochodzenia kolumn przez warstwy (to [analiza-lineage](../analiza-lineage/SKILL.md)).

## Wejście
`docs/analizy/<ID>/handoff.md` i `progress.md`. Jeśli ich brak, zaproponuj najpierw [analiza-zgloszenia](../analiza-zgloszenia/SKILL.md). Szablony handoffu i progressu są w [analiza-zgloszenia/assets](../analiza-zgloszenia/assets/).

## Wynik
W `docs/analizy/<ID>/`: zaktualizowane `handoff.md` i `progress.md`, `zapytania.sql` (każde zapytanie z ID), `raport.md` oraz szkic odpowiedzi (niewysłany).

## Proces (skrót, szczegóły w [kroki-procesu](./references/kroki-procesu.md))
1. **Start i zgoda na bazę**: wznowienie z handoffu, jedna zgoda na sesję dla zapytań SELECT, połączenie.
2. **Pytanie i metryka**: definicja, okres, zakres, jednostka.
3. **Odtworzenie liczby bazowej** z raportu lub widoku.
4. **Plan hipotez**: test, oczekiwany wynik, kolejność ([katalog hipotez](./references/katalog-hipotez.md)).
5. **Pętla hipotez**: jedno zapytanie na krok, werdykt na hipotezę.
6. **Rekonsyliacja**: most od liczby A do liczby B, reszta nieprzypisana.
7. **Weryfikacja i ryzyka**: co nie zostało sprawdzone.
8. **Raport i szkic odpowiedzi**, domknięcie handoffu.

Po **każdym** kroku bramka `vscode_askQuestions` zgodnie z [protokołem interakcji](./references/protokol-interakcji.md).

## Zasady, których nie wolno pominąć
- Zapytania tylko do odczytu, agregaty, limity wyniku. Szczegóły w [zasady-i-checklisty](./references/zasady-i-checklisty.md).
- Pełny SQL zawsze pokazany w raporcie kroku i zapisany w `zapytania.sql`.
- Każda liczba ma znacznik dowodu i ID zapytania. Wniosek z kodu to nie wynik z bazy.
- Dopasowanie liczby co do grosza nie jest dowodem mechanizmu. Zaproponuj [analiza-lineage](../analiza-lineage/SKILL.md).
- Nie zgaduj nazw kolumn: sprawdź DDL w `RetailDW/`.

## Zasoby
| Zasób | Po co |
| --- | --- |
| [kroki-procesu](./references/kroki-procesu.md) | Szczegółowe kroki i bramki |
| [zasady-i-checklisty](./references/zasady-i-checklisty.md) | Dostęp do bazy, bezpieczeństwo zapytań, SQL, checklisty |
| [katalog-hipotez](./references/katalog-hipotez.md) | Typowe przyczyny rozjazdów i jak je testować |
| [protokol-interakcji](./references/protokol-interakcji.md) | Format kroku i bramki |
| [karta-hipotezy-template](./assets/karta-hipotezy-template.md) | Karta pojedynczej hipotezy |
| [zapytania-template](./assets/zapytania-template.sql) | Format wpisu w `zapytania.sql` |
| [raport-analizy-template](./assets/raport-analizy-template.md) | Raport końcowy z dowodami i mostem |
| [szkic-odpowiedzi-template](./assets/szkic-odpowiedzi-template.md) | Szkic odpowiedzi do zgłaszającego |
