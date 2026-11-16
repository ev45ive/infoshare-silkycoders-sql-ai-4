# Kroki procesu: analiza zgłoszenia

Każdy krok kończy się bramką ([protokół interakcji](./protokol-interakcji.md)). Kroki można rozszerzać bez zmiany `SKILL.md`.

## Krok 0. Start
- Wejście: ścieżka zgłoszenia lub opis od analityka.
- Ustal `<ID>` analizy (np. numer zgłoszenia + krótki temat: `E02-sierpien`). Jeśli brak oczywistego ID, zapytaj.
- Sprawdź, czy istnieje `docs/analizy/<ID>/handoff.md`. Jeśli tak: pokaż 3-zdaniowe podsumowanie i zapytaj, czy wznawiamy od "Następny krok".
- Jeśli nie: utwórz folder i pliki z [handoff-template](../assets/handoff-template.md) i [progress-template](../assets/progress-template.md) dopiero po kroku 3 (gdy znamy problem).
- Bramka: potwierdź ID i folder.

## Krok 1. Wczytanie zgłoszenia
- Przeczytaj zgłoszenie w całości. Przeczytaj powiązane pliki z `inbox/` i `docs/` (np. `docs/slownik-metryk.md`, `docs/analiza-bazy.md`), jeśli są wskazane lub oczywiście związane.
- Wypisz **fakty dosłowne**: nadawca, data, termin, liczby, nazwy raportów, okres, cytat oczekiwania.
- Wyjście: lista faktów z cytatami (`[ZGŁ]`).
- Bramka: czy czegoś brakuje lub czy są inne powiązane zgłoszenia?

## Krok 2. Sformułowanie problemu
- Napisz problem lub zadanie w 1–2 zdaniach. Wskaż typ: rozjazd liczb, nowa metryka, zmiana raportu, błąd danych, pytanie ad hoc, inne.
- Wskaż oczekiwany rezultat wg zgłaszającego i kryterium ukończenia.
- Bramka: analityk poprawia sformułowanie. Nie idź dalej bez akceptacji.

## Krok 3. Co wiemy, co zakładamy, czego nie wiemy
- Tabela: stwierdzenie / poziom dowodu / źródło / status (wiemy, założenie, brak).
- Sprawdź w repo to, co da się ustalić bez pytania: definicje metryk, DDL, widoki. Podaj plik.
- Dopiero teraz utwórz `handoff.md` i `progress.md`.
- Bramka: czy zgadzamy się z podziałem? Co przenieść między kolumnami?

## Krok 4. Pytania
- Podziel na: (a) pytania do analityka (zadaj od razu przez `vscode_askQuestions`), (b) pytania do zgłaszającego (szkic wg [pytania-doprecyzowujace-template](../assets/pytania-doprecyzowujace-template.md)).
- Oznacz każde pytanie: **blokujące** (bez odpowiedzi nie ruszamy) lub **niekrytyczne**.
- Dla każdego pytania podaj, po co jest potrzebna odpowiedź.
- Bramka: analityk odpowiada, dodaje, usuwa pytania.

## Krok 5. Ryzyka i zależności
- Zastosuj czerwone flagi z [zasady-i-checklisty](./zasady-i-checklisty.md): termin, konflikt definicji, dane osobowe, powiązane zgłoszenia, zmiana, której nie wolno wprowadzać przed zamknięciem analizy.
- Bramka: które ryzyka akceptujemy, które eskalujemy?

## Krok 6. Plan i rekomendacja
- Zaproponuj etapy (3–7), kryterium ukończenia każdego i kolejność.
- Zarekomenduj następny skill:
  - jest liczba do wyjaśnienia lub pytanie biznesowe: [analiza-danych](../../analiza-danych/SKILL.md),
  - trzeba prześledzić pochodzenie lub sposób liczenia: [analiza-lineage](../../analiza-lineage/SKILL.md).
- Bramka: akceptacja planu lub korekta.

## Krok 7. Zapis i domknięcie
- Uzupełnij `handoff.md` (sekcja "Następny krok" musi pozwolić zacząć pracę nowemu agentowi bez czytania czatu) i `progress.md`.
- Podsumuj w czacie: problem, kluczowe pytania, plan, ścieżki plików.
- Bramka końcowa: przejść do następnego skilla czy wstrzymać?
