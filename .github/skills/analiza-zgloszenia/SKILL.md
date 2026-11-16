---
name: analiza-zgloszenia
description: "Interaktywna analiza zgłoszenia, emaila lub prośby do zespołu danych: ustala problem/zadanie, co wiemy, czego brakuje, jakie pytania zadać zgłaszającemu, ryzyka i plan dalszych kroków. Zapisuje handoff i progress w docs/analizy/<ID>/. Use when: nowe zgłoszenie w inbox/, email od controllingu lub biznesu, prośba o analizę, rozjazd liczb, trzeba zrozumieć zadanie przed pracą na danych, przygotować pytania doprecyzowujące, założyć handoff."
argument-hint: "Ścieżka do zgłoszenia (np. inbox/E02-....md) lub opis zadania"
---

# Analiza zgłoszenia

Pierwszy skill w łańcuchu: **analiza-zgloszenia** → [analiza-danych](../analiza-danych/SKILL.md) → [analiza-lineage](../analiza-lineage/SKILL.md).
Cel: analityk i agent wspólnie rozumieją, **co dokładnie jest do zrobienia**, zanim ktokolwiek dotknie danych.

## Kiedy używać
- Pojawiło się zgłoszenie (plik w `inbox/`, email, wiadomość) i trzeba ustalić problem lub zadanie.
- Trzeba odpowiedzieć na pytanie: co wiemy, czego nie wiemy, kogo i o co dopytać.
- Trzeba założyć lub odświeżyć handoff dla kolejnych skilli.

Nie używaj do liczenia ani zapytań do bazy. To zadanie dla [analiza-danych](../analiza-danych/SKILL.md).

## Wynik
Folder `docs/analizy/<ID>/` z plikami:
- `handoff.md`: cel, źródło, definicje, co wiemy, decyzje, pytania, ryzyka, następny krok.
- `progress.md`: status etapów, rejestr znalezisk, dziennik kroków.
- opcjonalnie `pytania-do-zglaszajacego.md`: szkic wiadomości z pytaniami (niewysłany).

## Proces (skrót, szczegóły w [kroki-procesu](./references/kroki-procesu.md))
1. **Start**: ustal `<ID>`, sprawdź czy analiza już istnieje (wznów od sekcji "Następny krok").
2. **Wczytaj zgłoszenie** i powiązane dokumenty. Wypisz fakty dosłownie.
3. **Sformułuj problem** w 1–2 zdaniach i typ zadania. Analityk koryguje.
4. **Co wiemy / zakładamy / nie wiemy**, każdy fakt z poziomem dowodu.
5. **Pytania**: do analityka (od razu) i do zgłaszającego (szkic).
6. **Ryzyka i terminy**, w tym nieaktualny termin i konflikty definicji.
7. **Plan i rekomendacja** następnego skilla. Analityk akceptuje.
8. **Zapis** handoffu i progressu.

Po każdym kroku zatrzymaj się i zapytaj analityka przez `vscode_askQuestions` zgodnie z [protokołem interakcji](./references/protokol-interakcji.md).

## Zasady, których nie wolno pominąć
- Nie zgaduj i nie zakładaj. Brak informacji oznacz jako pytanie.
- Każdy fakt ma poziom dowodu (`[ZGŁ]`, `[DOK]`, `[KOD]`, `[WNIOSEK]`, `[ZAŁ]`). Zob. [zasady i checklisty](./references/zasady-i-checklisty.md).
- Nie łącz się z bazą w tym skillu.
- Nie wysyłaj wiadomości do zgłaszającego. Przygotuj szkic.

## Zasoby
| Zasób | Po co |
| --- | --- |
| [kroki-procesu](./references/kroki-procesu.md) | Szczegółowe kroki, wejścia, wyjścia, bramki |
| [zasady-i-checklisty](./references/zasady-i-checklisty.md) | Poziomy dowodu, checklista kompletności zgłoszenia, czerwone flagi |
| [protokol-interakcji](./references/protokol-interakcji.md) | Format kroku i bramki z pytaniem do analityka |
| [handoff-template](./assets/handoff-template.md) | Szablon `handoff.md` (używany też przez pozostałe skille) |
| [progress-template](./assets/progress-template.md) | Szablon `progress.md` (używany też przez pozostałe skille) |
| [pytania-doprecyzowujace-template](./assets/pytania-doprecyzowujace-template.md) | Szablon wiadomości z pytaniami do zgłaszającego |
