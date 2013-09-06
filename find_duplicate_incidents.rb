require 'mysql2'

class CrimeIncidentDuplicateLocator

  def find_duplicates
    puts "Found #{results.size/2} duplicates"
    results.each do |row|
      output = row.map do |key, value|
        "#{key}=#{value}"
      end
      puts output.join(",\t")
    end
  end

  private

  def query_inc_number
    <<-SQL
    select count(*) as num_dups,INC_NO
    from all_years
    group by INC_NO
    having num_dups > 1
    order by INC_NO
    SQL
  end

  def query_duplicates(duplicate_inc_numbers)
    <<-SQL
    select * 
    from all_years
    WHERE INC_NO IN ('#{duplicate_inc_numbers.join("','")}') 
    order by INC_NO
    SQL
  end

  def inc_numbers
    client.query(query_inc_number).map { |row| row['INC_NO'] }
  end

  def results
    @results ||= client.query(query_duplicates(inc_numbers))
  end

  def client
    @client ||= Mysql2::Client.new(host: 'localhost', database: 'city_of_raleigh_crime', username: 'root', password: 'root')
  end

end

CrimeIncidentDuplicateLocator.new.find_duplicates
