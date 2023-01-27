LOAD DATA
INFILE 'C:\Users\vera\Desktop\oracle\ад\Laboratory work 18\vera.txt'
INTO TABLE LAB18 
REPLACE
FIELDS TERMINATED BY ","
(
integervalue "round(:integervalue, 2)",
charvalue "upper(:charvalue)",
datevalue date "YYYY-MM-DD"
)