CREATE TABLE `all_years` (
  `LCR` varchar(12) DEFAULT NULL,
  `LCR_DESC` varchar(80) DEFAULT NULL,
  `INC_DATETIME` datetime DEFAULT NULL,
  `BEAT` int(11) DEFAULT NULL,
  `INC_NO` varchar(25) DEFAULT NULL,
  `LOCATION` varchar(80) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
)