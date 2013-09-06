require 'mysql2'
require 'csv'
require_relative 'env'

class Importer

  attr_reader :import_csv

  def initialize(import_csv)
    @import_csv = File.expand_path("../#{import_csv}", __FILE__)
  end

  def run
    client.query(clear_table_query)
    client.query(create_table_query)
    client.query(load_csv_query)
  end

  def client
    @client ||= Mysql2::Client.new(host: ENV['DATABASE_HOST'], database: ENV['DATABASE'], username: ENV['DATABASE_USER'], password: ENV['DATABASE_PASSWORD'])
  end

  def clear_table_query
    "DROP TABLE IF EXISTS `all_years`;"
  end

  def create_table_query
    <<-SQL
    CREATE TABLE `all_years` (
      `LCR` varchar(12) DEFAULT NULL,
      `LCR_DESC` varchar(80) DEFAULT NULL,
      `INC_DATETIME` datetime DEFAULT NULL,
      `BEAT` int(11) DEFAULT NULL,
      `INC_NO` varchar(25) DEFAULT NULL,
      `LOCATION` varchar(80) DEFAULT NULL,
      `ID` int(11) NOT NULL AUTO_INCREMENT,
      PRIMARY KEY (`ID`)
    );
    SQL
  end

  def load_csv_query
    <<-SQL
    LOAD DATA INFILE '#{import_csv}'
      INTO TABLE all_years
      FIELDS TERMINATED BY ',' optionally enclosed by '"' lines terminated by '\n'
      IGNORE 1 LINES
      (LCR, LCR_DESC, @date, @beat, INC_NO, LOCATION)
      SET BEAT = IF(@beat = '', 0, @beat),
          INC_DATETIME = date_format(str_to_date(@date, '%m/%d/%Y %l:%i:%s %p'), '%Y-%m-%d %H:%i:%s');
    SQL
  end

end

Importer.new(ARGV[0], ARGV[1]).run
