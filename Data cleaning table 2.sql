
USE flights
CREATE TABLE dbo.unclean_economy (
    [date]       VARCHAR(MAX),
    airline      VARCHAR(MAX),
    ch_code      VARCHAR(MAX),
    num_code     VARCHAR(MAX),
    dep_time     VARCHAR(MAX),
    [from]       VARCHAR(MAX),
    time_taken   VARCHAR(MAX),
    stop         VARCHAR(MAX),
    arr_time     VARCHAR(MAX),
    [to]         VARCHAR(MAX),
    price        FLOAT
);
GO
BULK INSERT dbo.unclean_economy
FROM 'C:\Data  Analytics\data analytics 2025\Sql Project\New folder\economy_Un.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = '65001',
    TABLOCK
);
GO
 -- Data cleaning for each feature  for table 2
--Feature 1 (date)


SELECT  [date] ,count(*)
FROM dbo.unclean_economy
GROUP BY [date];

ALTER TABLE dbo.unclean_economy
ADD clean_date DATE;

UPDATE unclean_economy
SET clean_date = TRY_CONVERT(DATE,date,105) 
WHERE date Is not null

SELECT  clean_date ,count(*)
FROM dbo.unclean_economy
GROUP BY clean_date;

SELECT date ,clean_date FROM unclean_economy WHERE clean_date IS NULL

UPDATE unclean_economy
SET clean_date = TRY_CONVERT(DATE,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(date,'x','-'),'y','-'),'#',''),'v','-'),'i','-'),105)
WHERE clean_date Is  null

SELECT * FROM unclean_economy

--Feature 2  Airline

SELECT DISTINCT AIRLINE FROM unclean_economy

SELECT AIRLINE, COUNT(*) FROM unclean_economy GROUP BY AIRLINE

ALTER TABLE unclean_economy ADD Clean_Airline Varchar(50);

UPDATE unclean_economy
SET Clean_Airline = CASE 
                       WHEN TRIM(UPPER(airline)) LIKE 'VIS%' THEN 'Vistara'
                       WHEN TRIM(UPPER(airline)) LIKE  '%IN%' THEN 'Air India'
					   WHEN TRIM(UPPER(airline)) LIKE  '%SIA%' THEN 'AirAsia'
					   WHEN TRIM(UPPER(airline)) LIKE  '%GO' THEN 'Indigo'
					   WHEN TRIM(UPPER(airline)) LIKE  '%FIRST%' THEN 'Go First'
					   WHEN TRIM(UPPER(airline)) LIKE  '%IN%' THEN 'Air India'
					   WHEN TRIM(UPPER(airline)) LIKE  '%STAR%' THEN 'StarAir'
					   WHEN TRIM(UPPER(airline)) LIKE  '%IN%' THEN 'Air India'
					   WHEN TRIM(UPPER(airline)) LIKE  'SP%' THEN 'SpiceJet'
					   WHEN TRIM(UPPER(airline)) LIKE  '%TR%' THEN 'TruJet'
					   ELSE 'Unknown'
                   END
WHERE airline IS NOT NULL


SELECT date airline,Clean_Airline,ch_code FROM unclean_economy WHERE Clean_Airline like 'U%'

SELECT  Clean_Airline ,count(*)
FROM dbo.unclean_economy
GROUP BY Clean_Airline;

SELECT Clean_Airline  FROM unclean_economy WHERE Clean_Airline IS NULL

SELECT * FROM unclean_economy


--Feature 3 CH_CODE  

SELECT DISTINCT CH_CODE FROM unclean_economy

SELECT CH_CODE, COUNT(*) FROM unclean_economy GROUP BY CH_CODE

ALTER TABLE unclean_economy ADD Clean_CH_CODE Varchar(50);


UPDATE unclean_economy
SET Clean_CH_CODE = UPPER(TRIM(REPLACE(REPLACE(REPLACE(CH_CODE,'#',''),'#k',''),'%','')))
WHERE ch_code IS NOT NULL


SELECT Clean_CH_CODE, COUNT(*) FROM unclean_economy GROUP BY Clean_CH_CODE
 
 UPDATE unclean_economy
 SET Clean_CH_CODE = 'UK'
 WHERE Clean_CH_CODE = 'UKK'

SELECT CH_CODE,Clean_CH_CODE FROM unclean_business WHERE Clean_CH_CODE IS NULL


--- FEATURE - 4 NUM_CODE

SELECT * FROM unclean_economy

SELECT DISTINCT num_code FROM unclean_economy


ALTER TABLE unclean_economy  ADD Clean_Num_Code INT;

UPDATE unclean_economy 
SET Clean_Num_Code = TRY_CAST( TRIM(num_code) AS INT)
WHERE num_code IS NOT NULL

SELECT  Clean_Num_Code ,count(*)
FROM dbo.unclean_economy
GROUP BY Clean_Num_Code;


--- FEATURE - DEPT_TIME
SELECT * FROM unclean_economy

SELECT DISTINCT dep_time FROM unclean_economy

ALTER TABLE unclean_economy ADD Clean_dept_time TIME;

UPDATE unclean_economy
SET Clean_dept_time =  TRY_CAST(dep_time AS TIME)
WHERE dep_time IS NOT NULL

UPDATE unclean_economy
SET Clean_dept_time =  TRY_CAST(TRIM(REPLACE(DEP_TIME,'*',':')) AS TIME)
WHERE DEP_TIME LIKE '00%' AND Clean_dept_time IS NULL

UPDATE unclean_economy
SET Clean_dept_time =  TRY_CAST(TRIM(REPLACE(DEP_TIME,'#',':')) AS TIME)
WHERE DEP_TIME LIKE '00%' AND Clean_dept_time IS NULL

UPDATE unclean_economy
SET Clean_dept_time =  TRY_CAST(TRIM(REPLACE(DEP_TIME,'#','')) AS TIME)
WHERE DEP_TIME LIKE '%00%' AND Clean_dept_time IS NULL

UPDATE unclean_economy
SET Clean_dept_time =  TRY_CAST(TRIM(REPLACE(DEP_TIME,'*','')) AS TIME)
WHERE DEP_TIME LIKE '00%' AND Clean_dept_time IS NULL

SELECT Clean_dept_time ,COUNT(*)FROM unclean_economy GROUP BY Clean_dept_time

SELECT Clean_dept_time ,DEP_TIME FROM unclean_economy WHERE Clean_dept_time IS NULL 




--- FEATURE - [FROM]

SELECT * FROM unclean_economy

SELECT DISTINCT [FROM] FROM unclean_economy

SELECT Clean_From, COUNT(*) FROM unclean_economy GROUP BY Clean_From

ALTER TABLE unclean_economy ADD Clean_From Varchar(50);

UPDATE unclean_economy
SET Clean_From = CASE 
                       WHEN TRIM(UPPER([FROM])) LIKE  'C%' THEN 'Chennai'
                       WHEN TRIM(UPPER([FROM])) LIKE  'K%' THEN 'Kolkata'
					   WHEN TRIM(UPPER([FROM])) LIKE  'D%' THEN 'Delhi'
					   WHEN TRIM(UPPER([FROM])) LIKE  'H%' THEN 'Hyderabad'
					   WHEN TRIM(UPPER([FROM])) LIKE  'M%BAI' THEN 'Mumbai'
					   WHEN TRIM(UPPER([FROM])) LIKE  'B%' THEN 'Bangalore'
					   ELSE 'Other'
                   END
WHERE [FROM] IS NOT NULL


SELECT Clean_From ,[FROM] ,[TO] FROM unclean_economy WHERE Clean_From  LIKE 'O%'


 SELECT Clean_From ,[FROM] ,[TO] FROM unclean_economy WHERE Clean_From  IS NULL



-- TIME TAKEN

SELECT * FROM unclean_economy

SELECT DISTINCT time_taken FROM unclean_economy

SELECT time_taken, COUNT(*) FROM unclean_economy GROUP BY time_taken

ALTER TABLE unclean_economy ADD Clean_Time_taken Varchar(50);

UPDATE unclean_economy
SET Clean_Time_taken =  TRIM(REPLACE(REPLACE(REPLACE(REPLACE(TIME_TAKEN,'#',''),'x','h'),'H','h'),'M','m'))
WHERE time_taken IS NOT NULL

SELECT Clean_Time_taken, COUNT(*) FROM unclean_economy GROUP BY Clean_Time_taken
SELECT Clean_Time_taken FROM unclean_economy WHERE Clean_Time_taken IS NULL

SELECT * FROM unclean_economy


-- FEATURE - STOP

SELECT * FROM unclean_economy

SELECT DISTINCT STOP FROM unclean_economy

SELECT Clean_Stop, COUNT(*) FROM unclean_economy GROUP BY Clean_Stop

ALTER TABLE unclean_economy ADD Clean_Stop Varchar(50);

UPDATE unclean_economy
SET Clean_Stop = CASE 
                       WHEN TRIM(UPPER(stop)) LIKE '%LUCK%' THEN '1-stop Via Lucknow'
                       WHEN TRIM(UPPER(stop)) LIKE  '%PAT%' THEN '1-stop Via Patna'
					   WHEN TRIM(UPPER(stop)) LIKE  '%IXE%' THEN '1-stop Via IXE'
					   WHEN TRIM(UPPER(stop)) LIKE  '%IXU%' THEN '1-stop Via IXU'
					   WHEN TRIM(UPPER(stop)) LIKE  '%GUWA%' THEN '1-stop Via Guwahati'
					   WHEN TRIM(UPPER(stop)) LIKE  '%VTZ%' THEN '1-stop Via VTZ'
					   WHEN TRIM(UPPER(stop)) LIKE  '%CH%' THEN '1-stop Via Chennai'
					   WHEN TRIM(UPPER(stop)) LIKE  '%NDC%' THEN '1-stop Via NDC'
					   WHEN TRIM(UPPER(stop)) LIKE  '%BHU%' THEN '1-stop Via Bhubaneswar'
					   WHEN TRIM(UPPER(stop)) LIKE  '%KOL%' THEN '1-stop Via Kolkata'
					   WHEN TRIM(UPPER(stop)) LIKE  '%DEL%I' THEN '1-stop Via Delhi'
					   WHEN TRIM(UPPER(stop)) LIKE  '%IDR%' THEN '1-stop Via IDR'
					   WHEN TRIM(UPPER(stop)) LIKE  '%STV%' THEN '1-stop Via STV'
					   WHEN TRIM(UPPER(stop)) LIKE  '%BBI%' THEN '1-stop Via BBI'
					   WHEN TRIM(UPPER(stop)) LIKE  '%GAU%' THEN '1-stop Via GAU'
					   WHEN TRIM(UPPER(stop)) LIKE  '%RAI%' THEN '1-stop Via Raipur'
					   WHEN TRIM(UPPER(stop)) LIKE  '%HY%D' THEN '1-stop Via Hyderabad'
					   WHEN TRIM(UPPER(stop)) LIKE  '%HYD%' THEN '1-stop Via HYD'
					   WHEN TRIM(UPPER(stop)) LIKE  '%SUR%' THEN '1-stop Via Surat'
					   WHEN TRIM(UPPER(stop)) LIKE  '%GAY%' THEN '1-stop Via GAY'
					   WHEN TRIM(UPPER(stop)) LIKE  '%RPR%' THEN '1-stop Via RPR'
					   WHEN TRIM(UPPER(stop)) LIKE  '%IXU%' THEN '1-stop Via IXU'
					   WHEN TRIM(UPPER(stop)) LIKE  '2%' THEN '2+-stop'
					   WHEN TRIM(UPPER(stop)) LIKE  '1%' THEN '1-stop'
					   WHEN TRIM(UPPER(stop)) LIKE '%NON%' THEN 'non-stop'
                   END
WHERE STOP IS NOT NULL

SELECT Clean_Stop ,STOP FROM unclean_economy WHERE Clean_Stop IS NULL

UPDATE unclean_economy
SET Clean_Stop =  CASE 
                       WHEN TRIM(UPPER(REPLACE(stop,'"',''))) LIKE '%1%' THEN '1-stop'
                      END
WHERE Clean_Stop IS  NULL


UPDATE unclean_economy
SET Clean_Stop =   TRIM(REPLACE(REPLACE(Clean_Stop,'-',' '),'+','')    )      
WHERE Clean_Stop IS NOT NULL




-- FEATURE - ARR_TIME

SELECT * FROM unclean_economy

SELECT DISTINCT arr_time FROM unclean_economy

ALTER TABLE unclean_economy ADD Clean_arr_time TIME;

UPDATE unclean_economy
SET Clean_arr_time =  TRY_CAST(TRIM(REPLACE(REPLACE(arr_time,'x',':'),'#','')) AS TIME)
WHERE arr_time IS NOT NULL

UPDATE unclean_economy
SET Clean_arr_time =  TRY_CAST(TRIM(REPLACE(arr_time,'#',':')) AS TIME)
WHERE Clean_arr_time IS  NULL


SELECT Clean_arr_time ,COUNT(*)FROM unclean_business GROUP BY Clean_arr_time

SELECT Clean_arr_time ,arr_time FROM unclean_business WHERE Clean_arr_time IS NULL 



--- FEATURE - [TO]

SELECT * FROM unclean_economy

SELECT DISTINCT [TO] FROM unclean_economy

SELECT [TO], COUNT(*) FROM unclean_economy GROUP BY [TO]

ALTER TABLE unclean_economy ADD Clean_To Varchar(50);

UPDATE unclean_economy
SET Clean_To = CASE 
                       WHEN TRIM(UPPER([TO])) LIKE  'C%' THEN 'Chennai'
                       WHEN TRIM(UPPER([TO])) LIKE  'K%' THEN 'Kolkata'
					   WHEN TRIM(UPPER([TO])) LIKE  'D%' THEN 'Delhi'
					   WHEN TRIM(UPPER([TO])) LIKE  'H%' THEN 'Hyderabad'
					   WHEN TRIM(UPPER([TO])) LIKE  'M%' THEN 'Mumbai'
					   WHEN TRIM(UPPER([TO])) LIKE  'B%' THEN 'Bangalore'
					   ELSE 'Other'
                   END
WHERE [TO] IS NOT NULL

SELECT Clean_To  ,[TO] FROM unclean_economy WHERE Clean_To  LIKE 'O%'

SELECT Clean_To  ,[TO] FROM unclean_economy WHERE Clean_To IS NULL



--- FEATURE - PRICE

SELECT * FROM unclean_economy

SELECT DISTINCT PRICE FROM unclean_economy

SELECT PRICE, COUNT(*) FROM unclean_economy GROUP BY PRICE

ALTER TABLE unclean_economy ADD Clean_Price Float;

UPDATE unclean_economy
SET Clean_Price =  Price
WHERE ISNUMERIC(PRICE) = 1

SELECT DISTINCT PRICE FROM unclean_economy WHERE ISNUMERIC(PRICE) = 1
SELECT Clean_Price, COUNT(*) FROM unclean_business GROUP BY Clean_Price







