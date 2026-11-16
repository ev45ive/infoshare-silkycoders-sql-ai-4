# Lineage: <obiekt> (<ID>)

> Data: <data> | Analityk: <imię> | Status: <wersja robocza / zatwierdzony>

## 1. Zakres
| Element | Wartość |
| --- | --- |
| Obiekt | <metryka / kolumna / widok> |
| Cel analizy | <wyjaśnienie liczby / dokumentacja / audyt> |
| Przypadek referencyjny | <okres, transakcja, agregat> |
| Kierunek | <od raportu w dół / od źródła w górę> |
| Granica | <do `src` / do pliku / do systemu źródłowego> |

## 2. Podsumowanie
<3–5 zdań: skąd pochodzi obiekt, jak jest liczony, w której warstwie powstaje różnica lub transformacja (albo "brak anomalii").>

## 3. Ścieżka danych
Diagram: [diagramy.md](./diagramy.md)

| Warstwa | Obiekt | Wejście | Transformacja / filtr | Wyjście | Ryzyko utraty/powielenia | Dowód |
| --- | --- | --- | --- | --- | --- | --- |
| Raportowa | `reporting.vw_...` | <...> | <wyrażenie miary> | <...> | <...> | `[KOD]` |
| Fakty | `dbo.Fact...` | <...> | <...> | <...> | <...> | `[KOD]` `[DB]` Q01 |
| ETL | `etl.Load...` | <...> | <...> | <...> | <...> | `[KOD]` |
| Staging | `stg....` | <...> | <...> | <...> | <...> | `[KOD]` `[DB]` Q02 |
| Landing | `src....` | <...> | <...> | <...> | <...> | `[KOD]` `[DB]` Q03 |
| Pliki | `data/...` | <...> | <...> | <...> | <...> | `[KOD]` |

## 4. Bilans między warstwami
Przypadek referencyjny: <...>

| Warstwa | Wiersze | Wartość miary | Różnica vs poprzednia | Wyjaśnienie | Dowód |
| --- | --- | --- | --- | --- | --- |
| Raport | <...> | <...> | | | Q01 |
| Fakty | <...> | <...> | <...> | <...> | Q02 |
| Staging | <...> | <...> | <...> | <...> | Q03 |
| Landing | <...> | <...> | <...> | <...> | Q04 |

**Warstwa różnicy:** <nazwa warstwy lub "brak anomalii">

## 5. Mapowanie kolumn
[mapowanie-kolumn.md](./mapowanie-kolumn.md)

## 6. Dowody
- Zapytania: [zapytania.sql](./zapytania.sql)
- Kod: <lista plików `[KOD]`>
- Dokumentacja: <lista `[DOK]`>

## 7. Luki wiedzy i ryzyka
- <czego nie da się ustalić z repo i bazy, np. kto generuje pliki>
- <czego nie sprawdzono>

## 8. Rekomendacje (propozycje, niewdrożone)
- <np. dodać kontrolę duplikatów w ETL, unikalność klucza, dokumentację>

## 9. Następny krok
<Np. potwierdzenie z właścicielem źródła, osobne zadanie na zmianę ETL.>
