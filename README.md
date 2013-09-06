# reports

Generate data for summarized reports.
Export all Socrata data to CSV file, which can be imported into local mySQL DB using [load.sql](load.sql).

## SQL

1. [sample_queries.sql](sample_queries.sql) example SQL queries to analyze data

## Ruby code

1. [import.rb](import.rb) imports data into database from CSV file, take 2 arguments `database_name` `csv_filename`
```ruby
  ruby import.rb city_of_raleigh_crime All_Police_Crime_Data.csv
```
2. [summarize_stage_1_crime.rb](summarize_stage_1_crime.rb) generates data for Stage 1 Police Crime reports
3. [find_duplicate_incidents.rb](find_duplicate_incidents.rb) find duplicate incident numbers in data (which are supposed to be unique)

## Output

1. [stage1_crimes_with_counts.csv](stage1_crimes_with_counts.csv) CSV file with all Local Crime Reporting (LCR) codes, descriptions and counts for all data
