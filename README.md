🧱 LEGO Analytics Data Warehouse & SQL Case Study

A comprehensive end-to-end SQL data analytics project based on the multi-table relational Rebrickable database. The project implements relational database modeling, bulk loading pipelines, data quality sanity checks, denormalized reporting views, and advanced business insights using MySQL 8.0.
📌 Project Architecture & Workflow

Raw CSV Data (Rebrickable)
│
▼
[01_schema_setup.sql]      --> Relational modeling (DDL, PK/FK, constraints)
│
▼
[Bulk Data Pipeline]       --> High-throughput bulk ingest (LOAD DATA LOCAL INFILE)
│
▼
[02_data_cleaning.sql]     --> Data sanitization, trimming & window-based deduplication
│
▼
[03_views_and_marts.sql]   --> Analytical marts & self-referencing hierarchy views
│
▼
[04_advanced_analytics.sql]--> Window functions, CTEs, YoY growth & market segmentation
🗄️ Relational Schema Design

The schema (lego_analytics) models catalog items, taxonomy, and physical set inventories across 7 core entities:

    colors: Color palette reference with RGB codes and transparency indicators.

    part_categories: Functional grouping of parts.

    parts: Unique brick geometries mapped to categories.

    themes: Self-referencing hierarchical taxonomy (parent_id -> id).

    sets: Official retail boxed sets (year >= 1949, part counts).

    inventories: Versioned manifests linking sets to actual parts.

    inventory_parts: High-volume fact table detailing part quantities and spare piece indicators.

🛠️ Tools & Methodology

    Database & Client: MySQL 8.0 (InnoDB Engine), MySQL Workbench 8.0.

    AI-Assisted Engineering: Developed with the support of Gemini Pro acting as an interactive AI pair-programming assistant and thought partner for architecture reviews, query refactoring, edge-case validation, and business insight derivation.

    Workflow & Best Practices: Modular script architecture (01–04), Git version control, reproducible DDL/DML pipelines, and structured SQL documentation.

💻 Key SQL Concepts Implemented

    Relational Integrity: Foreign keys with ON DELETE CASCADE and ON DELETE SET NULL, CHECK constraints, DEFAULT values.

    Data Quality Engineering: String normalization (TRIM), catalog anomaly inspection (num_parts = 0), duplicate detection using ROW_NUMBER() OVER (PARTITION BY ...) inside Common Table Expressions (CTEs).

    Hierarchical Views: Self-referencing LEFT JOIN operations resolving recursive parent-child theme structures with fallback values via COALESCE.

    Advanced Analytics:

        DENSE_RANK() OVER (PARTITION BY year ORDER BY num_parts DESC) for yearly top-performer rankings.

        LAG() OVER (ORDER BY year) for Year-over-Year (YoY) product portfolio expansion metrics.

        Conditional cohort binning using multi-branch CASE WHEN constructs.

📊 Key Business Insights & Analytical Findings
1. Historical Crisis & The 2005 Turnaround (YoY Analysis)

Using LAG() to analyze set release dynamics from 1980 onward revealed:

    The 2001–2003 Crisis: A sharp contraction in newly released product lines reflected LEGO's near-bankruptcy period driven by over-diversification and cost inefficiencies.

    The 2005 Rebound: The highest single-year growth surge in new set releases, aligning directly with the restructuring strategy (focusing back on core brick systems and high-yield licensed IP like Star Wars).

2. Product Volume Segmentation

Categorization of sets into volume brackets revealed a steep Pareto distribution:

    Impulse & Small Sets (< 100 parts): Dominate catalog volume, serving as entry-level impulse purchases.

    Flagship / UCS Tier (2,000+ parts): Represent fewer than 30 sets historically in early catalog snapshots, underscoring their exclusivity and targeted collector positioning.

📂 Repository Structure

    01_schema_setup.sql – DDL scripts: table definitions & constraints

    02_data_cleaning.sql – Sanitation, trimming, duplicate audits

    03_views_and_marts.sql – vw_sets_master analytical view

    04_advanced_analytics.sql – CTEs, Window functions, YoY & segmentation

    README.md – Project documentation

🚀 How to Replicate

    Clone this repository to your local machine.

    Download the latest CSV data dumps from Rebrickable.

    Execute scripts sequentially in MySQL Workbench (01 -> 02 -> 03 -> 04).
