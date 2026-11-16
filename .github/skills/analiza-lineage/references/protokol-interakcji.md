# Protokół interakcji

Cel: analityk w każdej chwili wie, co robi agent, i może zmienić kurs. Obowiązuje w każdym kroku.

## Pętla kroku
1. **Zapowiedź** (przed działaniem), 1–3 zdania: którą warstwę badamy, co sprawdzę, po co.
2. **Działanie**: jedna warstwa lub jedno zapytanie na krok.
3. **Raport kroku** w stałym formacie:
   - **Co zrobiłem** (pliki przeczytane, zapytania z pełnym SQL i ID `Qnn`)
   - **Wynik** (mała tabela: wejście, transformacja, wyjście)
   - **Co to znaczy** (ze znacznikiem dowodu)
   - **Co wiemy / co jest niejasne**
   - **Ogniwo lineage**: jedna linia "warstwa A → warstwa B: co się dzieje"
4. **Zapis**: SQL do `zapytania.sql`, wpis do `progress.md`, ogniwo do roboczego mapowania, decyzje i pytania do `handoff.md`.
5. **Bramka**: `vscode_askQuestions`.

Czytanie kilku plików DDL tej samej warstwy można łączyć w jeden krok.

## Zgoda na bazę a bramki
Zgoda na SELECT na sesję (krok 0) pozwala wykonać zapytanie po zapowiedzi. **Bramka po wyniku jest obowiązkowa**, więc analityk widzi każde zapytanie i wynik przed następnym.

## Bramka
Opcje dopasuj do kroku. Nagłówek (`header`) unikalny, np. `krok_4`.

Typowy zestaw:
- **Idziemy dalej do następnej warstwy** (rekomendowane)
- **Zmieniamy plan / dodaję uwagę** (np. inny przypadek referencyjny, inny kierunek)
- **Pogłębij tę warstwę** (dodatkowy dowód)
- **Pokaż / zapisz zapytania**
- **Wstrzymaj**

## Obsługa odpowiedzi
- Wybrana opcja: wykonaj.
- **Tekst wolny jest poleceniem lub korektą**, nie zgodą na dalej. Najpierw wykonaj, co napisano. Jeśli to pytanie ("czy z kodu, czy z bazy?"), odpowiedz wprost i ponów bramkę.
- Brak wyboru i brak tekstu: zapytaj krócej jeszcze raz. Nie zakładaj zgody.
- Krok pominięty: zapisz w handoffie jako ryzyko ("nie sprawdzono: ...").
- Prośba o ograniczenie obciążenia bazy: zawęź zakres (okres, próbka, agregat) i zapisz w "Decyzjach".
- Uwaga zmienia plan: zaktualizuj go w handoffie i potwierdź zmianę.

## Komunikacja
- Po polsku, krótko, tabele i krótkie diagramy Mermaid zamiast długich akapitów.
- Zawsze mów, skąd jest informacja (`[KOD]`, `[DB]`, ...).
- Mów wprost, czego nie sprawdzono.
- Po kilku warstwach pokaż skrócony, narastający diagram ścieżki, żeby analityk widział całość.

## Wznowienie
Na początku czytaj `handoff.md` i `progress.md`. Pokaż 3 zdania podsumowania i zapytaj, czy kontynuować od "Następny krok".
