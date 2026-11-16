# RetailDW — lokalny punkt startowy

Ten katalog zawiera schemat RetailDW V0, projekt SQL, lokalny SQL Server w Dockerze oraz trzy pliki bazowych danych P0. Baza służy do pracy warsztatowej na własnym komputerze.

## Wymagania

- Windows z PowerShell 7 i działającym Docker Desktop.
- Około 3 GB wolnego miejsca na obrazy, wolumen bazy, backupy i pliki P0.
- Port 14332 wolny na komputerze. Kontener publikuje SQL Server wyłącznie na `127.0.0.1:14332`.
- .NET SDK jest potrzebny tylko do opcjonalnej kompilacji projektu SQL.

Plik `.env` ma jawnie warsztatową wartość hasła do lokalnego SQL Server. Jest częścią początkowej paczki. Nie używaj tej wartości w żadnym innym systemie ani środowisku.

## Przygotowanie bazy

Uruchom polecenia z katalogu repozytorium:

~~~powershell
pwsh ./scripts/dw.ps1 setup
~~~

Polecenie uruchamia kontener i tworzy bazę `RetailDW_Workshop`, 13 tabel, 3 procedury ETL, 6 widoków raportowych oraz wymiary daty, produktu i sklepu. Wymiary zawierają odpowiednio 761, 124 i 6 rekordów. `setup` zapisuje checkpoint `v0`. Gdy baza już istnieje i ma komplet 13 tabel, skrypt pozostawia jej stan bez zmian. Nie importuje CSV i nie uruchamia procedur ładujących.

## Import danych i osobne ładowanie

Paczka P0 zawiera sprzedaż, migawki zapasu i przyjęte zwroty. Manifest podaje kontrakt, docelową tabelę, nagłówki, liczbę wierszy i SHA256 każdego pliku.

~~~powershell
pwsh ./scripts/dw.ps1 import-p0
pwsh ./scripts/dw.ps1 etl -Feed all
pwsh ./scripts/dw.ps1 verify
~~~

`import-p0` sprawdza manifest, hashe, nagłówki i liczbę wierszy, a następnie w jednej transakcji dopisuje dane wyłącznie do tabel `src`. Nie uruchamia ETL. Dopiero osobne `etl -Feed all` wywołuje kolejno `etl.LoadSales`, `etl.LoadInventory` i `etl.LoadReturns`; każda procedura ponownie ładuje własny fakt ze wszystkich wierszy w odpowiadającej tabeli `src`. Po pełnym, udanym P0 zapisuje się checkpoint `p0`, jeśli taki jeszcze nie istnieje. `verify` pokazuje liczniki warstw, wymiary i ostatnie statusy ładowania.

Import zwykłej paczki do istniejącej tabeli `src` jest dopisywany. Sprawdź, czy paczka nie została wcześniej zaimportowana. Jeśli potrzebujesz pustego punktu startowego, świadomie przywróć `v0`:

~~~powershell
pwsh ./scripts/dw.ps1 restore -Name v0 -Force
pwsh ./scripts/dw.ps1 import-p0
pwsh ./scripts/dw.ps1 etl -Feed all
~~~

Manifest dla kolejnej paczki powinien zawierać tylko pola `pack`, `contract` i `files`; wpis pliku zawiera `path`, `table`, `contract`, `rows`, `sha256` i `columns`. Każdy cel importu musi należeć do schematu `src`. Przykład użycia:

~~~powershell
pwsh ./scripts/dw.ps1 import-pack -PackPath ./data/P0/manifest.json
~~~

Polecenie importu nie modyfikuje schematu i nie uruchamia ETL.

## Punkty odtworzenia

Po zmianie projektu, schematu albo danych zapisz nazwany backup przed dalszą pracą:

~~~powershell
pwsh ./scripts/dw.ps1 backup -Name przed-zmiana -Force
~~~

Odtworzenie całkowicie zastępuje bazę `RetailDW_Workshop` danymi z backupu i wymaga jawnego `-Force`:

~~~powershell
pwsh ./scripts/dw.ps1 restore -Name przed-zmiana -Force
~~~

Checkpointy i backupy są zapisywane w trwałym wolumenie Dockera. Usunięcie kontenera bez usunięcia wolumenu nie zmienia ich zawartości. Odtworzenie starego backupu cofa bazę, ale nie zmienia plików repozytorium.

## Zmiana SQL

Przed zastosowaniem migracji wykonaj backup. Następnie zastosuj jeden plik SQL zapisany w tym repozytorium:

~~~powershell
pwsh ./scripts/dw.ps1 backup -Name przed-migracja -Force
pwsh ./scripts/dw.ps1 apply-sql -Path ./path/to/change.sql
~~~

`apply-sql` dzieli plik po osobnych wierszach `GO`, odrzuca dyrektywy SQLCMD takie jak `:r` i nie uruchamia ETL. Ścieżka musi wskazywać plik wewnątrz repo. Przeczytaj plik i sprawdź jego zakres przed uruchomieniem.

Aby sprawdzić, czy projekt SQL się kompiluje, użyj:

~~~powershell
pwsh ./scripts/dw.ps1 build
~~~

Kompilacja wymaga SDK i dostępu do pakietu `Microsoft.Build.Sql`; nie jest potrzebna do lokalnego `setup`.

## Pobieranie kolejnego wydania

Najpierw zachowaj lub zatwierdź pracę w plikach. Na gałęzi warsztatowej cykl odrzucenia niezapisanych zmian plików i pobrania kolejnego commitu wygląda tak:

~~~powershell
git status
git reset --hard HEAD
git pull --ff-only
~~~

`git reset --hard HEAD` usuwa niezapisane zmiany w śledzonych plikach. Nie usuwa automatycznie plików nieśledzonych. `git pull --ff-only` pobiera commity bez tworzenia merge commit. Te polecenia dotyczą plików Git; nie cofają, nie przywracają ani nie migrują bazy w wolumenie Dockera. Po aktualizacji sprawdź wymagany stan SQL Server osobno według instrukcji wydania i w razie potrzeby użyj jawnie `backup`, `restore` albo `apply-sql`.

## Schemat i import

Projekt `RetailDW/RetailDW.sqlproj` definiuje wymiary, fakty, landing `src`, staging `stg`, procedury `etl` i widoki `reporting`. SQL Server V0 wykonuje pełne przeładowania. P0 jest przykładową historią do ćwiczeń; sama poprawna praca procedury nie potwierdza kompletności wszystkich możliwych plików źródłowych.
