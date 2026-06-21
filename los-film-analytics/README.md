# Loš Film (Bad Movie) Analytics

## 📝 Project Overview & Origin

The data used in this project originates from the official curriculum of the **Data Analysis and Visualization** programme at **Algebra Bernays University**. 

The dataset and associated exercises simulate the enterprise operations of a commercial movie rental platform and video club network (**LosFilm**). This project serves as a practical showcase of relational database development, multi-table analytics, and data integrity constraints.

## 💼 Business Context & Objectives

LosFilm operates a localized movie rental network distributing films across various physical media formats (DVD, Blu-ray). To optimize inventory utilization and streamline customer retention, this project applies relational database principles (T-SQL) to extract operational insights from rental records and late-fee ledgers. The analytical and structural workloads are split into four logical phases:

1. **Core Exploration & Aggregations:** Tracking core metrics such as average movie runtimes, seasonal rental volumes, media format distribution, and high-activity regional hubs using `GROUP BY` and `HAVING` filters.

2. **Relational Analysis:** Executing deep multi-table queries (`JOIN`, `LEFT JOIN`, `FULL OUTER JOIN`) to audit customer interactions with specific movie genres, trace distribution geography, and cross-reference active reservations.

3. **Data Manipulation & Integrity:** Implementing critical database state changes (`INSERT`, `UPDATE`), managing complex textual profile transformations, and handling strict relational boundaries (`Foreign Key Constraints`) during cascade delete operations.

4. **Database Architecture & DDL:** Defining database blueprints, table structures, exact data types, and primary/foreign key relationships matching the enterprise entity-relationship logic.

## 📊 Database ER Diagram
The following diagram illustrates the relational layout of the LosFilm database system, mapping members, locations, and transactions to the core movie inventory.

![LosFilm ER Diagram](adventureworks_erd.jpg)

## 📂 Project Navigation
To maintain a clean repository architecture, the source code and documentation have been separated:
* 📁 **[Scripts](scripts/)** - Folder containing the complete partitioned SQL analytical code:
  * `01_losfilm_selections_and_aggregations.sql` - Core metrics, seasonal counts, and group filtering.
  * `02_losfilm_joins.sql` - Advanced multi-table relational alignment and distribution geography.
  * `03_losfilm_dml.sql` - Data entry modifications, transaction updates, and manual cascade deletes.
  * `04_losfilm_ddl.sql` - Structural database schema creation blueprints and entity constraints.
* 📖 **[Data Dictionary](los_film_data_dictionary.md)** - Full structural reference detailing table definitions, localized Croatian-to-English column mappings, and constraints.