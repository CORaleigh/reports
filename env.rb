# Local override
dotenv = File.expand_path("../.env_overrides.rb", __FILE__)
require dotenv if File.exist?(dotenv)

ENV['DATABASE'] ||= 'city_of_raleigh_crime'
ENV['DATABASE_HOST'] ||= 'localhost'
ENV['DATABASE_USER'] ||= 'root'
ENV['DATABASE_PASSWORD'] ||= 'root'
