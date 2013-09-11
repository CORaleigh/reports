require 'mysql2'
require 'csv'
require_relative 'env'

class CrimeCounter

  attr_reader :year

  def initialize(year)
    @year = year
  end

  def self.to_csv(years)
    categories = %w[NOISE FORGERY FRAUD EMBEZZLE STOLEN VANDALISM DAMAGE WEAPONS SHOTS PROSTITUTION DRUGS GAMBLING CHILD DRIVING ALCOHOL DISORDERLY JUVENILE HIT CARELESS DRIVING HUMANE MISC ALL TOTAL]
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
      AND (LCR_DESC LIKE "NOISE%" OR LCR_DESC LIKE "FORGERY%" OR LCR_DESC LIKE "FRAUD%" OR LCR_DESC LIKE "EMBEZZLE%" OR LCR_DESC LIKE "STOLEN%" OR LCR_DESC LIKE "VANDALISM%" OR LCR_DESC LIKE "DAMAGE%" OR LCR_DESC LIKE "WEAPONS%" OR
           LCR_DESC LIKE "SHOTS%" OR LCR_DESC LIKE "PROSTITUTION%" OR LCR_DESC LIKE "DRUGS%" OR LCR_DESC LIKE "GAMBLING%" OR LCR_DESC LIKE "CHILD%" OR LCR_DESC LIKE "DRIVING%" OR LCR_DESC LIKE "ALCOHOL%" OR LCR_DESC LIKE "DISORDERLY%" OR
           LCR_DESC LIKE "JUVENILE%" OR LCR_DESC LIKE "HIT AND RUN%" OR LCR_DESC LIKE "CARELESS%" OR LCR_DESC LIKE "DRIVING%" OR LCR_DESC LIKE "HUMANE%" OR LCR_DESC LIKE "MISC%" OR LCR_DESC LIKE "ALL OTHER%")
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
