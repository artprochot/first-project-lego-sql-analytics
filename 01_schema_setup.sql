-- Tworzenie i aktywacja bazy danych
CREATE DATABASE IF NOT EXISTS lego_analytics;
USE lego_analytics;

-- 1. Słownik kolorów
CREATE TABLE colors (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    rgb CHAR(6) NOT NULL,
    is_trans BOOLEAN NOT NULL DEFAULT FALSE
);

-- 2. Słownik kategorii części
CREATE TABLE part_categories (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 3. Słownik motywów z relacją nadrzędny-podrzędny
CREATE TABLE themes (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES themes(id) ON DELETE SET NULL
);

-- 4. Katalog unikalnych klocków
CREATE TABLE parts (
    part_num VARCHAR(30) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    part_cat_id INT NOT NULL,
    FOREIGN KEY (part_cat_id) REFERENCES part_categories(id)
);

-- 5. Tabela zestawów pudełkowych
CREATE TABLE sets (
    set_num VARCHAR(30) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    year INT NOT NULL CHECK (year >= 1949),
    theme_id INT NOT NULL,
    num_parts INT NOT NULL DEFAULT 0 CHECK (num_parts >= 0),
    FOREIGN KEY (theme_id) REFERENCES themes(id)
);

-- 6. Tabela wersji inwentarzy dla zestawów
CREATE TABLE inventories (
    id INT PRIMARY KEY,
    version INT NOT NULL DEFAULT 1,
    set_num VARCHAR(30) NOT NULL,
    FOREIGN KEY (set_num) REFERENCES sets(set_num) ON DELETE CASCADE
);

-- 7. Tabela zawartości inwentarza (faktów)
CREATE TABLE inventory_parts (
    inventory_id INT NOT NULL,
    part_num VARCHAR(30) NOT NULL,
    color_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    is_spare BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (inventory_id) REFERENCES inventories(id) ON DELETE CASCADE,
    FOREIGN KEY (part_num) REFERENCES parts(part_num),
    FOREIGN KEY (color_id) REFERENCES colors(id)
);