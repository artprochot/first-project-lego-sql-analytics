WITH ranked_sets AS (
    SELECT 
        year,
        set_name,
        num_parts,
        theme_name,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY num_parts DESC
        ) AS rnk
    FROM vw_sets_master
    WHERE year >= 2015 AND num_parts > 0
)
SELECT 
    year,
    rnk,
    set_name,
    theme_name,
    num_parts
FROM ranked_sets
WHERE rnk <= 3
ORDER BY year DESC, rnk ASC;

WITH yearly_stats AS (
    SELECT 
        year,
        COUNT(*) AS total_sets
    FROM vw_sets_master
    WHERE year >= 1980
    GROUP BY year
)
SELECT 
    year,
    total_sets,
    -- Użyj LAG(), aby pobrać total_sets z poprzedniego wiersza (posortowanego po roku):
    LAG(total_sets, 1) OVER (ORDER BY year) AS prev_year_sets,
    
    -- Oblicz procentowy wzrost: ROUND((obecny - poprzedni) * 100.0 / poprzedni, 2)
    ROUND(
        (total_sets - LAG(total_sets, 1) OVER (ORDER BY year)) * 100.0 
        / LAG(total_sets, 1) OVER (ORDER BY year), 
        2
    ) AS yoy_growth_pct
FROM yearly_stats
ORDER BY year ASC;

SELECT 
    CASE 
        WHEN num_parts = 0 THEN '0. Brak części / Akcesoria'
        WHEN num_parts BETWEEN 1 AND 99 THEN '1. Małe / Pocket (1-99)'
        WHEN num_parts BETWEEN 100 AND 499 THEN '2. Średnie (100-499)'
        WHEN num_parts BETWEEN 500 AND 1999 THEN '3. Duże (500-1999)'
        ELSE '4. Giganty / Flagowce (2000+)'
    END AS set_size_category,
    COUNT(*) AS total_sets,
    ROUND(AVG(num_parts), 0) AS avg_parts,
    MAX(num_parts) AS max_parts
FROM vw_sets_master
GROUP BY set_size_category
ORDER BY set_size_category ASC;
                    
                    