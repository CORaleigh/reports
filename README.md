# reports

Generate data for summarized reports.
Export all Socrata data to CSV file, which can be imported into local mySQL DB using [load.sql](load.sql).

## SQL

1. [create_table.sql](create_table.sql) SQL to create table
2. [load_csv_into_mysql.sql](load_csv_into_mysql.sql) loads CSV file into mySQL DB
3. [sample_queries.sql](sample_queries.sql) example SQL queries to analyze data

## Ruby code

1. [summarize_stage_1_crime.rb](summarize_stage_1_crime.rb) generates data for Stage 1 Police Crime reports
2. [find_duplicate_incidents.rb](find_duplicate_incidents.rb) find duplicate incident numbers in data (which are supposed to be unique)

## Output

1. [stage1_crimes_with_counts.csv](stage1_crimes_with_counts.csv) CSV file with all Local Crime Reporting (LCR) codes, descriptions and counts for all data
