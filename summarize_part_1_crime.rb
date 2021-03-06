require 'mysql2'
require 'csv'
require_relative 'env'

class CrimeCounter

  attr_reader :year

  def initialize(year)
    @year = year
  end

  def self.to_csv(years)
    categories = %w[MURDER RAPE ROBBERY ASSAULT BURGLARY LARCENY MV ARSON TOTAL]
    totals = years.map { |year| CrimeCounter.new(year).sums }

    CSV.generate do |csv|
      csv << ['Category'] + years
      categories.each do |category|
        csv << [category] + totals.map { |year| year[category] }
      end
    end
  end

  def query
    <<-SQL
    SELECT LCR, LCR_DESC, COUNT(*) AS count
    FROM all_years
    WHERE INC_DATETIME between "#{year}-01-01 00:00:00" AND "#{year}-12-31 23:59:59"
      AND LCR IN ("11","12","21","22","41","42","43","44","45","71","72","73","80","81","82","83","84","85","86","87","88","89","31A","31AP","31B","31BP","31C","31CP","31D","31DP","31E","31EP","31F","31FP","31G","31GP","32A","32AP","32B","32BP","32C","32CP","32D","32DP","32E","32EP","32F","32FP","32G","32GP","33A","33AP","33B","33BP","33C","33CP","33D","33DP","33E","33EP","33F","33FP","33G","33GP","34A","34AP","34B","34BP","34C","34CP","34D","34DP","34E","34EP","34F","34FP","34G","34GP","51CD","51CN","51CU","51RD","51RN","51RU","52CD","52CN","52CU","52RD","52RN","52RU","53CD","53CN","53CU","53RD","53RN","53RU","61A","61AF","61B","61BF","61C","61CF","61D","62A","62AF","62B","62BF","62C","62CF","62D","63A","63AF","63B","63BF","63C","63CF","63D","64A","64AF","64B","64BF","64C","64CF","64D","65A","65AF","65B","65BF","65C","65CF","65D","66A","66AF","66B","66BF","66C","66CF","66D","67A","67AF","67B","67BF","67C","67CF","67D","68A","68AF","68B","68BF","68C","68CF","68D","69A","69AF","69B","69BF","69C","69CF","69D","A41","A42","A43","A44","A45")
    GROUP BY LCR
    ORDER BY LCR
    SQL
  end

  def grouped
    results.group_by do |row|
      row['LCR_DESC'].split(/\s|\//).first
    end
  end

  def sums
    sums = grouped.inject({}) do |memo, (crime_type, crime_group)|
      memo[crime_type] = crime_group.map { |group| group['count'].to_i }.reduce(:+)
      memo
    end
    sums['TOTAL'] = sums.map { |crime, count| count }.reduce(:+)
    sums['year'] = year
    sums
  end

  def results
    @results ||= client.query(query)
  end

  def client
    @client ||= Mysql2::Client.new(host: ENV['DATABASE_HOST'], database: ENV['DATABASE'], username: ENV['DATABASE_USER'], password: ENV['DATABASE_PASSWORD'])
  end

end

puts CrimeCounter.to_csv([2005,2006,2007,2008,2009,2010,2011,2012,2013])
