---
name: analiza-lineage
description: "Interaktywna analiza lineage/provenance w hurtowni RetailDW: krok po kroku śledzi, skąd pochodzą dane i jak są liczone (raport/widok → fakt/wymiar → ETL → staging → src → plik źródłowy), wskazuje warstwę, w której powstaje różnica lub transformacja. Bramka z pytaniem po każdym kroku, na końcu raport z dowodami, diagramy Mermaid i mapowanie kolumn w docs/analizy/<ID>/. Use when: skąd pochodzi liczba lub kolumna, jak liczona jest miara, lineage, provenance, pochodzenie danych, ścieżka danych przez warstwy, w której warstwie powstaje rozbieżność, diagram przepływu danych."
argument-hint: "Obiekt do prześledzenia (metryka, kolumna, widok) lub <ID> istniejącej analizy"
---

# Analiza lineage / provenance

Trzeci skill w łańcuchu: [analiza-zgloszenia](../analiza-zgloszenia/SKILL.md) → [analiza-danych](../analiza-danych/SKILL.md) → **analiza-lineage**. Można go też uruchomić samodzielnie.
Cel: pokazać analitykowi, **skąd pochodzą dane i jak są liczone**, warstwa po warstwie, z dowodami. Na końcu raport, diagramy i mapowanie kolumn.

## Kiedy używać
- Trzeba wyjaśnić, skąd bierze się liczba, kolumna lub wiersz w raporcie.
- Trzeba znaleźć warstwę, w której powstaje różnica, duplikat, strata wierszy lub transformacja.
- Trzeba przygotować dokumentację przepływu danych (diagram, mapowanie kolumn).
- Nie używaj do ustalania zadania ([analiza-zgloszenia](../analiza-zgloszenia/SKILL.md)) ani do testowania hipotez o wartościach ([analiza-danych](../analiza-danych/SKILL.md)).

## Wejście
Obiekt do prześledzenia i, jeśli to możliwe, **przypadek referencyjny** (konkretny okres, transakcja lub agregat). Jeśli istnieje `docs/analizy/<ID>/handoff.md`, wczytaj go. Szablony handoffu i progressu są w [analiza-zgloszenia/assets](../analiza-zgloszenia/assets/).

## Wynik
W `docs/analizy/<ID>/`: `lineage.md` (raport), `mapowanie-kolumn.md`, `diagramy.md` (Mermaid), zaktualizowane `handoff.md` i `progress.md`, `zapytania.sql`.

## Proces (skrót, szczegóły w [kroki-procesu](./references/kroki-procesu.md))
1. **Start i zgoda na bazę**, wznowienie z handoffu.
2. **Cel i zakres**: obiekt, kierunek (od raportu w dół), przypadek referencyjny, granica (do pliku czy systemu źródłowego).
3. **Warstwa raportowa**: definicja miary, joiny, filtry.
4. **Fakty i wymiary**: ziarno, klucze, kolumny wyliczane.
5. **ETL**: transformacje, filtry, joiny, deduplikacja, ładowanie.
6. **Staging**: konwersje, odrzucenia.
7. **Warstwa src**: surowe dane, pliki, czas załadunku.
8. **Pliki i system źródłowy**.
9. **Bilans między warstwami**: wiersze i wartości, wskazanie warstwy różnicy.
10. **Raport, diagramy, mapowanie kolumn** i domknięcie.

Po **każdym** kroku bramka `vscode_askQuestions` zgodnie z [protokołem interakcji](./references/protokol-interakcji.md).

## Zasady, których nie wolno pominąć
- Każde ogniwo lineage ma dowód: `[KOD]` (definicja w repo) i, tam gdzie to istotne, `[DB]` (potwierdzenie w bazie). Wniosek z kodu to nie wynik z bazy.
- Zapytania tylko do odczytu, agregaty, limity. Zasady w [zasady-i-checklisty](./references/zasady-i-checklisty.md).
- Nie zmieniaj ETL, widoków ani danych. Zmiany to propozycje w raporcie.
- Przy każdej warstwie zapisz: wejście, wyjście, transformację, ryzyko utraty lub powielenia wierszy.

## Zasoby
| Zasób | Po co |
| --- | --- |
| [kroki-procesu](./references/kroki-procesu.md) | Szczegółowe kroki, pytania kontrolne, bramki |
| [zasady-i-checklisty](./references/zasady-i-checklisty.md) | Dowody, bezpieczeństwo zapytań, checklisty warstw i raportu |
| [warstwy-repo](./references/warstwy-repo.md) | Gdzie w repo leży każda warstwa i co w niej sprawdzać |
| [protokol-interakcji](./references/protokol-interakcji.md) | Format kroku i bramki |
| [lineage-template](./assets/lineage-template.md) | Raport lineage |
| [mapowanie-kolumn-template](./assets/mapowanie-kolumn-template.md) | Mapowanie kolumn źródło → cel |
| [diagram-template](./assets/diagram-template.md) | Diagramy Mermaid (przepływ, sekwencja) |
