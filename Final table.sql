
USE flights

-- final table preparation 
CREATE VIEW Flight_Data AS  (

                      SELECT Clean_date,Clean_Airline,Clean_CH_CODE,Clean_Num_Code,
                      Clean_dept_time,Clean_Time_Taken,Clean_Stop , Clean_arr_time,Clean_To,
                      Clean_Price ,'Business' As ClassType FROM unclean_business 
                      UNION ALL 
                      SELECT Clean_date,Clean_Airline,Clean_CH_CODE,Clean_Num_Code,
                      Clean_dept_time,Clean_Time_Taken,Clean_Stop , Clean_arr_time,Clean_To,
                      Clean_Price ,'Economy' As ClassType FROM unclean_economy 
                     )

SELECT * FROM Flight_Data

CREATE VIEW Flight_Data  AS
WITH Flight_Data_Cte AS (
                      SELECT Clean_date,Clean_Airline,Clean_CH_CODE,Clean_Num_Code,Clean_From,
                      Clean_dept_time,Clean_Time_Taken,Clean_Stop , Clean_arr_time,Clean_To,
                      Clean_Price ,'Business' As ClassType FROM unclean_business 
                      UNION ALL 
                      SELECT Clean_date,Clean_Airline,Clean_CH_CODE,Clean_Num_Code,Clean_From,
                      Clean_dept_time,Clean_Time_Taken,Clean_Stop , Clean_arr_time,Clean_To,
                      Clean_Price ,'Economy' As ClassType FROM unclean_economy )

SELECT  Clean_date AS Date ,MONTH(Clean_date) AS Mon ,YEAR(Clean_date) AS Year,Clean_Airline AS Airline, CONCAT_WS('-',Clean_CH_CODE,Clean_Num_Code) AS Flight,clean_From  AS Source,

CASE 
             WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  4 AND 6 THEN 'Early Morning'
			 WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  7 AND 11 THEN 'Morning'
			 WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  12 AND 16 THEN 'Afternoon'
			 WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  17 AND 20 THEN 'Evening'
			 WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  21 AND 23 THEN 'Night'
			 WHEN DATEPART(HOUR,Clean_dept_time) BETWEEN  0 AND 3 THEN 'Late Night'
			 ELSE 'Unknown' 
END
AS  Dept_Time ,
CASE 
             WHEN Clean_Stop LIKE '1%' THEN 'One'
			 WHEN Clean_Stop LIKE 'non%' THEN 'Zero'
			 WHEN Clean_Stop LIKE '2%' THEN 'Two or More'
             ELSE 'Unknown'
END
AS Stops			 
,CASE 
             WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  4 AND 6 THEN 'Early Morning'
			 WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  7 AND 11 THEN 'Morning'
			 WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  12 AND 16 THEN 'Afternoon'
			 WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  17 AND 20 THEN 'Evening'
			 WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  21 AND 23 THEN 'Night'
			 WHEN DATEPART(HOUR,Clean_arr_time) BETWEEN  0 AND 3 THEN 'Late Night'
			 ELSE 'Unknown' 
END
AS  Arrival_Time ,clean_To  AS Destination ,ClassType AS Class
,  
  TRIM(REPLACE(REPLACE(Clean_Time_Taken ,'h ','.'),'m','')) AS Duration ,
  Clean_Price AS Price
FROM Flight_Data_Cte


SELECT COUNT(*) FROM Flight_Data