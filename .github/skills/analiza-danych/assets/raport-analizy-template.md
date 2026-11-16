# Raport analizy: <temat> (<ID>)

> Data: <data> | Analityk: <imię> | Status: <wersja robocza / zatwierdzony>

## 1. Pytanie i odpowiedź
**Pytanie:** <pytanie biznesowe>

**Odpowiedź:** <1–3 zdania z kwotą i okresem>

**Pewność:** <wysoka / średnia / niska> (uzasadnienie w sekcji 6)

## 2. Liczby bazowe
| Liczba | Wartość | Źródło | Dowód |
| --- | --- | --- | --- |
| Raport (nasza) | <...> | <widok, filtry> | `[DB]` Q01 |
| Zgłaszający | <...> | <system> | `[ZGŁ]` |
| Różnica | <...> | wyliczenie | `[WNIOSEK]` |

## 3. Hipotezy i werdykty
| Hipoteza | Werdykt | Kluczowy wynik | Zapytania |
| --- | --- | --- | --- |
| H1 <nazwa> | <odrzucona> | <...> | Q02 |

## 4. Most (rekonsyliacja)
| Pozycja | Kwota | Dowód |
| --- | --- | --- |
| Liczba A | <...> | Q01 |
| Korekta 1: <opis> | <−...> | Q05 |
| Liczba B | <...> | wyliczenie |
| **Reszta nieprzypisana** | <0,00> | |

## 5. Dowody
- Zapytania: [zapytania.sql](./zapytania.sql)
- Rejestr: [progress.md](./progress.md)
- Kod / dokumentacja: <pliki, `[KOD]` / `[DOK]`>

## 6. Czego nie sprawdzono i ryzyka
- <np. inne okresy, kanały, mechanizm powstania>

## 7. Rekomendacje
- Wartość do zaraportowania: <...>
- Działania naprawcze (propozycje, nie wdrożone): <...>
- Następny krok: <np. analiza-lineage dla ścieżki obiektu X>
