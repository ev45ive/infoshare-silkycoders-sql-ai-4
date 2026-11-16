# Protokół interakcji

Cel: analityk w każdej chwili wie, co robi agent, i może zmienić kurs. Obowiązuje w każdym kroku.

## Pętla kroku
1. **Zapowiedź** (przed działaniem), 1–3 zdania: cel kroku, co zrobię, co to potwierdzi lub obali.
2. **Działanie**: jedno zapytanie lub jedno ustalenie na krok.
3. **Raport kroku** w stałym formacie:
   - **Co zrobiłem** (z pełnym SQL w bloku kodu dla zapytań, ID `Qnn`)
   - **Wynik** (mała tabela, bez zrzutów danych)
   - **Co to znaczy** (ze znacznikiem dowodu)
   - **Co wiemy / co jest niejasne**
4. **Zapis**: SQL do `zapytania.sql`, wpis do `progress.md`, decyzje i pytania do `handoff.md`.
5. **Bramka**: `vscode_askQuestions`.

Kroki czysto przygotowawcze (np. przeczytanie kilku plików DDL) można łączyć w jeden krok z jednym raportem.

## Zgoda na bazę a bramki
Zgoda na SELECT na sesję (krok 0) pozwala wykonać zapytanie po zapowiedzi, bez osobnego pytania. **Bramka po wyniku i tak jest obowiązkowa**, więc analityk widzi każde zapytanie i wynik przed następnym.

## Bramka
Opcje dopasuj do kroku. Nagłówek (`header`) unikalny, np. `krok_7`.

Typowy zestaw:
- **Idziemy dalej** (rekomendowane)
- **Zmieniamy plan / dodaję uwagę**
- **Pokaż / zapisz zapytania** (z `zapytania.sql`)
- **Wykonaj ponownie** (to samo zapytanie, np. po korekcie danych)
- **Wstrzymaj**

Po zamknięciu hipotezy (werdykt) zapytaj osobno: przejść do kolejnej hipotezy, do rekonsyliacji czy wstrzymać.

## Obsługa odpowiedzi
- Wybrana opcja: wykonaj.
- **Tekst wolny jest poleceniem lub korektą**, nie zgodą na dalej. Najpierw wykonaj, co napisano. Jeśli to pytanie ("czy z kodu, czy z bazy?"), odpowiedz wprost, bez obrony, i ponów bramkę.
- Brak wyboru i brak tekstu: zapytaj krócej jeszcze raz. Nie zakładaj zgody.
- Krok pominięty przez analityka (np. rezygnacja z testu): zapisz w handoffie jako ryzyko ("nie sprawdzono: ...").
- Uwaga zmienia plan: zaktualizuj plan hipotez w handoffie i potwierdź zmianę.
- Prośba o ograniczenie obciążenia bazy: zawęź zakres (okres, próbka, agregat) i zapisz w "Decyzjach".

## Komunikacja
- Po polsku, krótko, tabele zamiast długich akapitów.
- Zawsze mów, skąd jest informacja (`[DB]`, `[KOD]`, ...). Gdy pytają "czy z bazy?", odpowiedz zgodnie z prawdą.
- Mów wprost, czego nie sprawdzono.
- Nie wykonuj kilku zapytań pod rząd bez bramki.

## Wznowienie
Na początku czytaj `handoff.md` i `progress.md`. Pokaż 3 zdania podsumowania i zapytaj, czy kontynuować od "Następny krok".
