-- Zapytania analizy <ID>. Każde zapytanie ma ID, cel i wynik w skrócie.
-- Tylko odczyt (SELECT / CTE). Baza: <serwer / baza>.

-- ============================================================
-- Q01 | Krok: <nr> | Hipoteza: <H# lub "odtworzenie liczby">
-- Cel: <co sprawdza>
-- Wykonano: <data> | Wynik: <w skrócie>
-- ============================================================
-- Zastąp kolumny, obiekt i zakres dat (zakres bez funkcji na kolumnie).
SELECT  t.[column_name]
FROM    [schema].[object] AS t
WHERE   t.[date_column] >= '2000-01-01' AND t.[date_column] < '2000-02-01';
