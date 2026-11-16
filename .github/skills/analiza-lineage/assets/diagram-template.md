# Diagramy lineage: <obiekt> (<ID>)

## 1. Przepływ danych (od źródła do raportu)

```mermaid
flowchart LR
    A[Plik źródłowy<br/>data/...] --> B[src.<Tabela>Raw<br/>tekst, bez walidacji]
    B -->|etl.Load...<br/>TRY_CAST, walidacja| C[stg.<Tabela>]
    C -->|etl.Load...<br/>JOIN do wymiarów, miary| D[dbo.Fact...]
    E[dbo.Dim...] --> D
    D --> F[reporting.vw_...]
    F --> G[Raport / odbiorca]
```

Podpisz krawędzie transformacją lub filtrem. Zaznacz węzeł, w którym powstaje różnica, np. `style C fill:#fdd`.

## 2. Przebieg ładowania (sekwencja)

```mermaid
sequenceDiagram
    participant P as Pliki
    participant S as src
    participant T as stg
    participant F as dbo.Fact
    participant R as reporting
    P->>S: załadunek (nazwa pliku, czas)
    S->>T: konwersja i walidacja (wiersze odrzucone)
    T->>F: lookup wymiarów, wyliczenie miar
    F->>R: agregacja w widoku
```

## 3. Ścieżka przypadku referencyjnego (opcjonalnie)

```mermaid
flowchart TB
    R1[Raport: <wartość>] --> F1[Fakty: <wiersze, wartość>]
    F1 --> T1[Staging: <wiersze>]
    T1 --> S1[src: <wiersze>]
    S1 --> P1[Pliki: <nazwy>]
```

Wartości w węzłach pochodzą z bilansu w `lineage.md` (ID zapytań).
