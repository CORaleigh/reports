LOAD DATA INFILE 'All_Police_Crime_Data.csv' 
  INTO TABLE all_years
  FIELDS TERMINATED BY ',' optionally enclosed by '"' lines terminated by '\n' 
  (LCR, LCR_DESC, @date, BEAT, INC_NO, LOCATION) 
  SET INC_DATETIME = date_format(str_to_date(@date, '%m/%d/%Y %l:%i:%s %p'), '%Y-%m-%d %l:%i:%s %p');
