# Kroki procesu: analiza danych

Każdy krok kończy się bramką ([protokół interakcji](./protokol-interakcji.md)). Kroki i bramki można rozszerzać bez zmiany `SKILL.md`.

## Krok 0. Start i dostęp do bazy
- Przeczytaj `handoff.md` i `progress.md`. Pokaż podsumowanie i "Następny krok".
- Zapytaj raz przez `vscode_askQuestions` o **zgodę na zapytania SELECT tylko do odczytu w tej sesji**. Zapisz zgodę w "Decyzjach" (data, kto, zakres). Zgoda nie obejmuje zapisu, DDL ani uruchamiania procedur.
- Połącz się (zob. [zasady](./zasady-i-checklisty.md#połączenie)). Potwierdź serwer i bazę analitykowi.
- Bramka: połączenie i baza są właściwe?

## Krok 1. Pytanie biznesowe i metryka
- Sformułuj pytanie w jednym zdaniu, wskaż metrykę, okres, zakres, jednostkę.
- Sprawdź definicję metryki w `docs/slownik-metryk.md` i widokach. Wskaż konflikty definicji.
- Bramka: analityk potwierdza lub poprawia pytanie i definicję.

## Krok 2. Odtworzenie liczby bazowej
- Ustal, z jakiego raportu lub widoku pochodzi liczba. Jeśli nieznane: wypisz kandydatów (z `RetailDW/Views/`) i testuj po kolei.
- Zapytanie odtwarzające liczbę (ten sam okres, te same filtry). Porównaj z liczbą ze zgłoszenia.
- Wynik: liczba odtworzona co do grosza (tak/nie), źródło liczby.
- Bramka: czy to ten raport? Jeśli nie, wracamy do kandydatów.

## Krok 3. Plan hipotez
- Na bazie [katalogu hipotez](./katalog-hipotez.md) i kontekstu zbuduj listę: hipoteza, test, oczekiwany wynik, kryterium odrzucenia, koszt zapytania, kolejność (tanie i prawdopodobne najpierw).
- Dla każdej hipotezy wypełnij [kartę hipotezy](../assets/karta-hipotezy-template.md) (w czacie wystarczy tabela, karty w `raport.md`).
- Bramka: analityk dodaje, usuwa, zmienia kolejność.

## Krok 4. Pętla hipotez
Dla każdej hipotezy:
1. Zapowiedź: co testujemy, co oczekujemy, co obali hipotezę.
2. Jedno zapytanie na krok (zob. [zasady](./zasady-i-checklisty.md#bezpieczeństwo-zapytań)). Zapisz je w `zapytania.sql` jako `Qnn`.
3. Raport kroku: SQL, wynik (mała tabela), znaczenie, co wiemy, co niejasne.
4. Bramka po **każdym zapytaniu** (kontynuuj hipotezę, zmień, pokaż/zapisz/powtórz zapytanie, wstrzymaj).
5. Po ostatnim zapytaniu hipotezy: **werdykt** = potwierdzona / odrzucona / częściowa / niejednoznaczna, z uzasadnieniem i liczbą.
6. Aktualizacja `progress.md` (status, znalezisko, indeks zapytań).
- Hipoteza potwierdzona nie kończy pętli automatycznie. Zapytaj, czy sprawdzać pozostałe, czy przejść do rekonsyliacji.

## Krok 5. Rekonsyliacja (most)
- Tabela: liczba A → korekty (każda ze źródłem Q) → liczba B → reszta nieprzypisana (powinna wynosić 0,00 lub być wyjaśniona).
- Jeśli reszta ≠ 0, nazwij ją wprost i zaproponuj kolejną hipotezę.
- Bramka: czy most jest przekonujący? Co jeszcze pokazać?

## Krok 6. Weryfikacja i ryzyka
- Sprawdź [checklistę przed raportem](./zasady-i-checklisty.md#checklista-przed-raportem-końcowym).
- Wypisz, czego **nie** sprawdzono (inne okresy, kanały, źródła) i jak to wpływa na pewność.
- Jeśli mechanizm powstania różnicy jest niejasny, zaproponuj [analiza-lineage](../../analiza-lineage/SKILL.md).
- Bramka: czy akceptujemy zakres weryfikacji?

## Krok 7. Raport i szkic odpowiedzi
- Wygeneruj `raport.md` z [szablonu](../assets/raport-analizy-template.md) i szkic odpowiedzi z [szablonu](../assets/szkic-odpowiedzi-template.md).
- Szkic nie jest wysyłany. Jeśli analiza wskazuje błąd po naszej stronie, napisz to wprost.
- Bramka: zatwierdzenie, zmiany treści lub dodatkowe sprawdzenie.

## Krok 8. Domknięcie
- Zaktualizuj `handoff.md` (status, wnioski, ryzyka, następny krok) i `progress.md`.
- Podsumuj w czacie: odpowiedź, most, ryzyka, pliki.
