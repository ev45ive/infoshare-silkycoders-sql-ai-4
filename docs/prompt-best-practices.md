# Dobre praktyki pisania promptów

Dokument opisuje, jak budować prompty do pracy z asystentem AI przy zadaniach SQL i dokumentacji w hurtowni danych. Wnioski pochodzą z analizy rozmowy o dokumentacji T-SQL dla zespołu DWH w retailu.

## Spis treści

- [1. Co działało](#1-co-działało)
- [2. Czego brakowało](#2-czego-brakowało)
- [3. Szablon dobrego promptu](#3-szablon-dobrego-promptu)
- [4. Wyjaśnienie sekcji szablonu](#4-wyjaśnienie-sekcji-szablonu)

# 1. Co działało

Ustalamy elementy, które warto zachować w kolejnych promptach.

- Rola z domeną (np. „analityk DWH w retailu”) zawęża słownictwo i przykłady.
- Cel w jednym zdaniu.
- Zasady jako krótkie, sprawdzalne ograniczenia (wersja SQL Server, język nazw i komentarzy).
- Szablon formatu z placeholderami (`# <Nagłówek>`, `# <Sekcja>`), który daje przewidywalną strukturę.
- Iteracyjne doprecyzowanie krótkimi poleceniami („przy każdej sekcji dopisz blok SQL”), gdy kontekst jest już ustalony.

```text
Rola:   Jesteś asystentem analityka danych w DWH firmy odzieżowej w retailu.
Cel:    Napisz dokumentację dobrych praktyk z wzorcowym zapytaniem.
Zasady: Składnia MSSQL 2022; nazwy po angielsku, komentarze po polsku.
Format: # Nagłówek, spis treści, sekcje z listą praktyk, blok kodu.
```

# 2. Czego brakowało

Ustalamy, co dodać, aby wynik nie wymagał poprawek.

- Odbiorca i poziom szczegółu (junior, mid, senior).
- Konkretne dane wejściowe: nazwy tabel, kolumn i schematów albo wklejony DDL. Bez nich model zgaduje nazwy.
- Zakres i długość dokumentu.
- Ścieżka zapisu oraz wyraźne uprawnienie do tworzenia i nadpisywania plików. Bez tego asystent może błędnie odmówić zapisu.
- Kryteria akceptacji, czyli lista kontrolna, którą wynik musi spełnić.
- Słownictwo ustalone wcześniej (`dim_`, `fact_`, `*_sk`, `date_key` jako `INT` w formacie `YYYYMMDD`) podane od razu, a nie w poprawce.
- Ograniczenia wykonania: czy wolno łączyć się z bazą, commitować, uruchamiać kod.
- Literówki i niejasne sformułowania, które zmieniają sens (np. „dokumentacje praktyk zapytanie SQL”).

# 3. Szablon dobrego promptu

Ustalamy strukturę, którą wypełniamy przy każdym zadaniu.

```text
## Rola
Jesteś <konkretna rola> pracujący w <domena/firma/technologia>.

## Kontekst
- Odbiorca: <kto będzie czytał, poziom>
- System i wersja: <np. SQL Server 2022, DWH w modelu gwiazdy>
- Istniejące obiekty: <lista tabel/kolumn lub wklejony DDL>
- Słownik i konwencje: <np. prefiksy dim_/fact_, klucze *_sk>

## Cel
<Jedno zdanie: co ma powstać i po co.>

## Zadanie
1. <krok 1>
2. <krok 2>

## Zasady
- <ograniczenia techniczne, np. zakaz SELECT *>
- <zakres komentarzy, np. inline tylko przy złożonej logice>

## Format wyjścia
- Plik: <ścieżka, tryb: utwórz / nadpisz>
- Struktura: <sekcje w kolejności>
- Każda sekcja: <opis> + <lista praktyk> + <jeden blok kodu>
- Długość: <np. ok. 150 linii>

## Kryteria akceptacji
- <np. każdy blok kodu to poprawny T-SQL dla SQL Server 2022>
- <np. spis treści linkuje do wszystkich sekcji>

## Uprawnienia i ograniczenia wykonania
- Wolno: <np. tworzyć i nadpisywać pliki w docs/>
- Nie wolno: <np. łączyć się z bazą, commitować>
- Jeśli czegoś brakuje, zapytaj przed wygenerowaniem.
```

# 4. Wyjaśnienie sekcji szablonu

Ustalamy, dlaczego każda sekcja działa, żeby wiedzieć, kiedy można ją pominąć.

- **Rola**: ustawia perspektywę i słownictwo. Model dobiera przykłady z danej dziedziny.
- **Kontekst**: informuje o tym, czego model nie wie. Odbiorca decyduje o poziomie szczegółu, a prawdziwe nazwy obiektów eliminują zgadywanie.
- **Cel**: jedno zdanie streszczające efekt. Pozwala ocenić, czy odpowiedź jest na temat.
- **Zadanie**: kroki w kolejności. Ułatwia rozbicie pracy i sprawdzenie kompletności.
- **Zasady**: ograniczenia, które muszą być spełnione. Krótkie i sprawdzalne ograniczenia działają lepiej niż ogólne zalecenia typu „pisz dobrze”.
- **Format wyjścia**: określa strukturę, miejsce zapisu i długość, dzięki czemu wynik nadaje się do użycia bez przeróbek.
- **Kryteria akceptacji**: zamieniają oczekiwania w listę kontrolną, którą model może sam sprawdzić.
- **Uprawnienia i ograniczenia wykonania**: wyjaśniają, co wolno zrobić w środowisku. Zapobiegają błędnej odmowie zapisu i niechcianym zmianom, np. połączeniu z bazą produkcyjną.
- **Reguła „zapytaj przed wygenerowaniem”**: ogranicza zgadywanie brakujących danych. Lepiej dopytać, niż wygenerować nieistniejące nazwy kolumn.
