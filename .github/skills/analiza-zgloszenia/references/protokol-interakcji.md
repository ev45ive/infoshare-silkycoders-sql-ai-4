# Protokół interakcji

Cel: analityk w każdej chwili wie, co robi agent, i może zmienić kurs. Obowiązuje w każdym kroku.

## Pętla kroku
1. **Zapowiedź** (przed działaniem), 1–3 zdania: cel kroku, co zrobię, co to potwierdzi lub zmieni.
2. **Działanie**: jedna rzecz naraz (jedno ustalenie, jeden dokument).
3. **Raport kroku** w stałym formacie:
   - **Co zrobiłem**
   - **Wynik** (mała tabela)
   - **Co to znaczy** (ze znacznikiem dowodu)
   - **Co wiemy / co jest niejasne**
4. **Zapis**: dopisz do `progress.md`. Decyzje i pytania dopisz do `handoff.md`.
5. **Bramka**: `vscode_askQuestions`.

Kroki czysto przygotowawcze (np. przeczytanie kilku plików) można łączyć w jeden krok z jednym raportem.

## Bramka
Opcje dopasuj do kroku, nie używaj ogólników. Nagłówek (`header`) unikalny, np. `krok_3`.

Typowy zestaw:
- **Idziemy dalej** (rekomendowane)
- **Zmieniamy plan** (analityk poda uwagę)
- **Dopytaj / pokaż szczegóły**
- **Wstrzymaj**

## Obsługa odpowiedzi
- Wybrana opcja: wykonaj.
- **Tekst wolny jest poleceniem lub korektą**, nie zgodą na dalej. Najpierw wykonaj, co napisano. Jeśli to pytanie ("czy z kodu, czy z bazy?"), odpowiedz wprost i ponów bramkę.
- Brak wyboru i brak tekstu: zapytaj krócej jeszcze raz. Nie zakładaj zgody.
- Krok pominięty przez analityka: zapisz w handoffie jako ryzyko ("nie sprawdzono: ...").
- Uwaga analityka zmienia plan: zaktualizuj plan w handoffie i potwierdź zmianę.

## Komunikacja
- Po polsku, krótko, tabele zamiast długich akapitów.
- Zawsze mów, skąd jest informacja (znacznik dowodu).
- Mów wprost, czego nie sprawdzono.
- Nie wykonuj kilku kroków pod rząd bez bramki.

## Wznowienie
Na początku czytaj `handoff.md` i `progress.md`. Pokaż 3 zdania podsumowania i zapytaj, czy kontynuować od "Następny krok".
