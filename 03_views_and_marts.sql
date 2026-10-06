CREATE OR REPLACE VIEW vw_sets_master AS
SELECT 
    s.set_num, 
    s.name AS set_name, 
    s.year,
    s.num_parts,
    t.name AS theme_name,
    COALESCE(parent_t.name, 'Główny motyw') AS parent_theme_name
FROM sets s
LEFT JOIN themes t ON s.theme_id = t.id
LEFT JOIN themes parent_t ON t.parent_id = parent_t.id;

SELECT * FROM vw_sets_master LIMIT 10;

