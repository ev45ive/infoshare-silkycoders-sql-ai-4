# Zasady i checklisty: analiza zgłoszenia

## Poziomy dowodu
Każde stwierdzenie w handoffie i raportach ma znacznik.

| Znacznik | Znaczenie | Przykład |
| --- | --- | --- |
| `[ZGŁ]` | Wprost ze zgłoszenia (cytat) | "Sierpień się nie spina" |
| `[DOK]` | Z dokumentacji w repo | definicja z `docs/slownik-metryk.md` |
| `[KOD]` | Z kodu lub DDL w repo | treść widoku, procedury, tabeli |
| `[DB]` | Z wyniku zapytania do bazy | używane w skillach z dostępem do bazy |
| `[WNIOSEK]` | Interpretacja agenta z podanych dowodów | "to wygląda na ponowny eksport" |
| `[ZAŁ]` | Założenie do potwierdzenia | "zakładam netto przed zwrotami" |

Zasady:
- Nie podawaj `[WNIOSEK]` ani `[ZAŁ]` jako faktu. Oznaczaj je wyraźnie.
- Nie używaj słów "prawdopodobnie", "chyba" bez znacznika niepewności.
- Wniosek z kodu to nie wynik z bazy. Mów, który jest który.

## Checklista kompletności zgłoszenia
Zaznacz, czego brakuje, i zamień braki w pytania.

- [ ] Kto zgłasza, z jakiej roli, kiedy.
- [ ] Jaki problem lub zadanie, własnymi słowami zgłaszającego.
- [ ] Jaka metryka lub raport, z jaką definicją (przed/po zwrotach, netto/brutto, kanał).
- [ ] Jaki okres i zakres (sklepy, kanały, kategorie).
- [ ] Skąd pochodzi liczba zgłaszającego i liczba "nasza" (system, raport, filtry).
- [ ] Jaka jest oczekiwana forma odpowiedzi (liczba, wyjaśnienie, raport, korekta).
- [ ] Jaki termin i czy jest aktualny względem dzisiejszej daty.
- [ ] Jak rozpoznamy, że zadanie jest zrobione (kryterium sukcesu).
- [ ] Czy są powiązane zgłoszenia lub zmiany w toku.
- [ ] Czy dane lub odpowiedź zawierają dane osobowe.

## Czerwone flagi
- **Termin w przeszłości** względem bieżącej daty. Zapytaj o nowy termin.
- **Dwie definicje tej samej metryki** w repo lub zgłoszeniach (np. zmiana ujęcia zwrotów). Zapytaj, która obowiązuje, i nie zmieniaj definicji w trakcie analizy.
- **Liczba bez źródła**. Nie porównuj, dopóki nie wiesz, skąd pochodzi.
- **Prośba o zmianę** w widoku lub ETL w trakcie analizy. Zapisz jako osobne zadanie.
- **Dane osobowe** w zgłoszeniu. Nie kopiuj ich do handoffu, maskuj.

## Czego unikać
- Nie zaczynaj od rozwiązania. Najpierw problem, potem pytania, potem plan.
- Nie zadawaj więcej niż kilku pytań naraz. Priorytetyzuj.
- Nie powtarzaj treści zgłoszenia jako analizy.
- Nie wysyłaj nic na zewnątrz. Szkice zostają w plikach.

## Repo
- Odpowiadaj po polsku. Nazwy obiektów i kolumn po angielsku, dokładnie jak w DDL.
- Nie zgaduj nazw tabel i kolumn: sprawdź `RetailDW/Tables/`, `RetailDW/Views/`, `docs/slownik-metryk.md`.
