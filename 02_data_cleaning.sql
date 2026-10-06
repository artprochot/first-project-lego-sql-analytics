USE lego_analytics;

-- =====================================================================
-- 1. NORMALIZACJA TEKSTU (USUWANIE ZBĘDNYCH BIAŁYCH ZNAKÓW / SPACJI)
-- =====================================================================
-- Wyłączamy tryb Safe Updates na czas operacji aktualizacji bez użycia klucza
SET SQL_SAFE_UPDATES = 0;

-- Usunięcie wiodących i kończących spacji z nazw zestawów, części i motywów
UPDATE sets 
SET name = TRIM(name);

UPDATE parts 
SET name = TRIM(name);

UPDATE themes 
SET name = TRIM(name);

-- Przywracamy domyślny tryb bezpieczeństwa
SET SQL_SAFE_UPDATES = 1;


-- =====================================================================
-- 2. AUDYT ANOMALII I ZESTAWÓW BEZ CZĘŚCI (NUM_PARTS = 0)
-- =====================================================================
-- Zestawienie pokazujące, w których rocznikach wydano najwięcej zestawów
-- z zerową liczbą klocków w katalogu (np. breloki, książki, błędy katalogu)
SELECT 
    year, 
    COUNT(*) AS zero_part_sets
FROM sets
WHERE num_parts = 0
GROUP BY year
ORDER BY zero_part_sets DESC
LIMIT 5;


-- =====================================================================
-- 3. DETEKCJA DUPLIKATÓW PRZY UŻYCIU FUNKCJI OKNA (ROW_NUMBER)
-- =====================================================================
-- Sprawdzamy, czy w katalogu zestawów nie pojawiły się powtórzone numery set_num.
-- rn = 1 oznacza pierwsze wystąpienie, rn > 1 wskazuje na zdublowany rekord.
WITH checked_duplicates AS (
    SELECT 
        set_num,
        name,
        ROW_NUMBER() OVER(PARTITION BY set_num ORDER BY name) AS rn
    FROM sets
)
SELECT * 
FROM checked_duplicates 
WHERE rn > 1;
-- Oczekiwany wynik: brak wierszy (potwierdzenie unikalności kluczy)

