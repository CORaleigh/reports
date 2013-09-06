# reports

Generate data for summarized reports.
Export all Socrata data to CSV file, which can be imported into local mySQL DB using [load.sql](load.sql).

## SQL

1. [sample_queries.sql](sample_queries.sql) example SQL queries to analyze data

## Ruby code

1. [import.rb](import.rb) imports data into database from CSV file, takes 1 argument `csv_filename` and can run like this `ruby import.rb All_Police_Crime_Data.csv`
2. [summarize_part_1_crime.rb](summarize_part_1_crime.rb) generates data for Part 1 Police Crime reports
3. [find_duplicate_incidents.rb](find_duplicate_incidents.rb) find duplicate incident numbers in data (which are supposed to be unique)

## Output

1. [part_1_crimes_with_counts.csv](part_1_crimes_with_counts.csv) CSV file with all Local Crime Reporting (LCR) codes, descriptions and counts for all data
2. [LCR_codes.xlsx](LCR_codes.xlsx) original CSV file that lists all of the LCR codes for Part 1 crime along with descriptions

## Configuration

[env.rb](env.rb) contains default configuration options for database connections.  To override with your own values add named `.env_overrides.rb` at the root of the project and set the values you need such as the following.

```ruby
# .env_overrides.rb

ENV['DATABASE_USER'] = 'YOUR_USERNAME'
ENV['DATABASE_PASSWORD'] = 'YOUR_PASSWORD'
```
