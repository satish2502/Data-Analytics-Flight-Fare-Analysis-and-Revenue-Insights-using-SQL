--- Basic EDA: 20 Real-Time Business Problems & Insights
USE flights

SELECT * FROM Flight_Data

-- 1. How many total flights are recorded in the dataset?

SELECT COUNT(*) AS TotalFlights FROM Flight_Data;
--Insight: Total number of flights for the period covered. 
--Helps understand dataset size.

--2. How many unique airlines operate in the dataset?
SELECT COUNT(DISTINCT Airline) AS UniqueAirlines FROM Flight_Data;
--Insight: Number of competitors in the market.

--3. What are the top 5 airlines by flight count?
SELECT TOP 5 Airline, COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY Airline
ORDER BY TotalFlights DESC;

--Insight: Identifies dominant airlines by volume.

--4. What are the most frequent source and destination airports?
-- Source
SELECT Source, COUNT(*) AS Departures
FROM Flight_Data
GROUP BY Source
ORDER BY Departures DESC;

-- Destination
SELECT Destination, COUNT(*) AS Arrivals
FROM Flight_Data
GROUP BY Destination
ORDER BY Arrivals DESC;

---Insight: Shows major hubs for departures and arrivals.


-- 5. How many classes (Economy/Business/etc.) exist and their proportions?
SELECT Class, COUNT(*) AS TotalBookings
FROM Flight_Data
GROUP BY Class;
--Insight: Understand customer preference for flight classes.

--6. What is the average, minimum, and maximum ticket price?
SELECT 
    MIN(CAST(Price AS FLOAT)) AS MinPrice,
    MAX(CAST(Price AS FLOAT)) AS MaxPrice,
    ROUND(AVG(CAST(Price AS FLOAT)),2) AS AvgPrice
FROM Flight_Data;
--Insight: Identifies pricing range and average spend.

--7. Which routes (Source-Destination pairs) are most popular?
SELECT Source, Destination, COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY Source, Destination
ORDER BY TotalFlights DESC;
--Insight: Find routes with highest demand.

--8. How many flights have stops vs non-stop?
SELECT Stops, COUNT(*) AS FlightCount
FROM Flight_Data
GROUP BY Stops;

--9. What is the price difference between non-stop and multi-stop flights?
SELECT Stops, AVG(CAST(Price AS FLOAT)) AS AvgPrice
FROM Flight_Data
GROUP BY Stops;
--Insight: Check if multi-stop flights are actually cheaper.

--10. When are most flights scheduled? (by Month)
SELECT Mon, COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY Mon
ORDER BY Mon;
--Insight: Seasonality trends for demand.

-- 11. Flights distribution across weekdays (Mon-Sun)?

SELECT DATENAME(WEEKDAY, CAST(Date AS DATE)) AS WeekDay, COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY DATENAME(WEEKDAY, CAST(Date AS DATE))
ORDER BY TotalFlights DESC;

-- Insight: Understand peak travel days.

--12. Peak hours for flight departures
SELECT Dept_time, COUNT(*) AS Departures
FROM Flight_Data
GROUP BY Dept_time
ORDER BY Departures DESC;
--Insight: See when most passengers travel.

--13. Which airline earns the most revenue?
SELECT Airline, SUM(CAST(Price AS FLOAT)) AS TotalRevenue
FROM Flight_Data
GROUP BY Airline
ORDER BY TotalRevenue DESC;

--Insight: Identifies the top revenue-generating airline.

--14. What is the average flight duration by airline?
SELECT Airline, AVG(CAST(Duration AS FLOAT)) AS AvgDuration
FROM Flight_Data
GROUP BY Airline;
--Insight: Check operational efficiency across airlines.

--15. What is the price trend over time (monthly)?
SELECT Year, Mon, AVG(CAST(Price AS FLOAT)) AS AvgMonthlyPrice
FROM Flight_Data
GROUP BY Year, Mon
ORDER BY Year, Mon;

--Insight: Detect price increases or seasonal surges.

--16. What is the price distribution by class?
SELECT Class, AVG(CAST(Price AS FLOAT)) AS AvgPrice
FROM Flight_Data
GROUP BY Class;

--Insight: Understand price segmentation between Economy/Business.

--17. Which source-destination pairs earn the highest revenue?
SELECT Source, Destination, SUM(CAST(Price AS FLOAT)) AS RouteRevenue
FROM Flight_Data
GROUP BY Source, Destination
ORDER BY RouteRevenue DESC;
--Insight: Find top revenue-generating routes.

--18. Flights per day to find the busiest travel dates
SELECT CAST(Date AS DATE) AS TravelDate, COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY CAST(Date AS DATE)
ORDER BY TotalFlights DESC;
--Insight: Identify peak days for operational planning.

-- 19. What is the average ticket price for each airline?
SELECT Airline, AVG(CAST(Price AS FLOAT)) AS AvgPrice
FROM Flight_Data
GROUP BY Airline
ORDER BY AvgPrice DESC;

--Insight: Know premium vs budget carriers.

--20. Flights distribution by Arrival Time Period
SELECT Arrival_time, COUNT(*) AS TotalArrivals
FROM Flight_Data
GROUP BY Arrival_time
ORDER BY TotalArrivals DESC;

--Insight: See preferred arrival times.

--- Intermediate EDA: 12 Real-Time Business Problems & Insights

-- 1. Rank airlines by revenue and flight count (RANK function)	
SELECT 
    Airline,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue,
    COUNT(*) AS TotalFlights,
    RANK() OVER (ORDER BY SUM(CAST(Price AS FLOAT)) DESC) AS RevenueRank
FROM Flight_Data
GROUP BY Airline
ORDER BY RevenueRank;
--Insight: Understand which airlines dominate the market by both volume and revenue.

-- 2. Identify top 3 most profitable routes per airline (ROW_NUMBER)
WITH RankedRoutes AS (
    SELECT
        Airline,
        Source,
        Destination,
        SUM(CAST(Price AS FLOAT)) AS RouteRevenue,
        ROW_NUMBER() OVER (PARTITION BY Airline ORDER BY SUM(CAST(Price AS FLOAT)) DESC) AS RouteRank
    FROM Flight_Data
    GROUP BY Airline, Source, Destination
)
SELECT Airline, Source, Destination, RouteRevenue
FROM RankedRoutes
WHERE RouteRank <= 3
ORDER BY Airline, RouteRevenue DESC;
--Insight: Shows each airline’s most lucrative routes.

--3. Find average price change month-over-month (LAG function)
WITH MonthlyAvg AS (
    SELECT 
        Year,
        Mon,
        AVG(CAST(Price AS FLOAT)) AS AvgPrice
    FROM Flight_Data
    GROUP BY Year, Mon
)
SELECT 
    Year,
    Mon,
    AvgPrice,
    LAG(AvgPrice) OVER (ORDER BY Year, Mon) AS PrevMonthPrice,
    (AvgPrice - LAG(AvgPrice) OVER (ORDER BY Year, Mon)) AS PriceChange
FROM MonthlyAvg;
--Insight: Detect price trends, increases, or reductions.

--4. Identify customers (Flights) booking outside peak hours (CASE + filtering)
SELECT 
    Dept_time,
    COUNT(*) AS TotalFlights,
    SUM(CASE WHEN Dept_time NOT IN ('Morning', 'Evening') THEN 1 ELSE 0 END) AS OffPeakFlights
FROM Flight_Data
GROUP BY Dept_time;

--Insight: How many flights are during off-peak vs peak hours? Useful for optimizing resources.

--5.Compare weekday vs weekend revenue share (CASE WHEN)
SELECT 
    CASE 
        WHEN DATENAME(WEEKDAY, Date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue
FROM Flight_Data
GROUP BY 
    CASE 
        WHEN DATENAME(WEEKDAY, Date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END;

--6. Moving average price over 3 months (WINDOW function)
WITH MonthlyPrices AS (
    SELECT 
        Year,
        Mon,
        AVG(CAST(Price AS FLOAT)) AS AvgPrice
    FROM Flight_Data
    GROUP BY Year, Mon
)
SELECT *,
    AVG(AvgPrice) OVER (ORDER BY Year, Mon ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgPrice
FROM MonthlyPrices
ORDER BY Year, Mon;

--Insight: Smoothens out monthly fluctuations to see trends clearly.

--Find most volatile airlines (highest price variation)
SELECT 
    Airline,
    MAX(CAST(Price AS FLOAT)) - MIN(CAST(Price AS FLOAT)) AS PriceRange
FROM Flight_Data
GROUP BY Airline
ORDER BY PriceRange DESC;

--Insight: Identify airlines with inconsistent pricing.

--Determine percentage contribution of each airline to total revenue (PERCENTAGE)
SELECT 
    Airline,
    SUM(CAST(Price AS FLOAT)) AS AirlineRevenue,
    SUM(CAST(Price AS FLOAT)) * 100.0 / (SELECT SUM(CAST(Price AS FLOAT)) FROM Flight_Data) AS RevenuePercentage
FROM Flight_Data
GROUP BY Airline
ORDER BY RevenuePercentage DESC;

--Insight: Shows each airline’s revenue share in the market.

--Analyze price difference between classes for same route (JOIN)

SELECT 
    A.Source,
    A.Destination,
    A.AvgEconomyPrice,
    B.AvgBusinessPrice,
    B.AvgBusinessPrice - A.AvgEconomyPrice AS PriceDifference
FROM (
    SELECT Source, Destination, AVG(CAST(Price AS FLOAT)) AS AvgEconomyPrice
    FROM Flight_Data
    WHERE Class = 'Economy'
    GROUP BY Source, Destination
) AS A
INNER JOIN (
    SELECT Source, Destination, AVG(CAST(Price AS FLOAT)) AS AvgBusinessPrice
    FROM Flight_Data
    WHERE Class = 'Business'
    GROUP BY Source, Destination
) AS B
ON A.Source = B.Source AND A.Destination = B.Destination;
--Insight: Evaluate premium charged for Business class on each route.

--Flights per airline per month (Pivot style)
SELECT Airline,
    SUM(CASE WHEN FORMAT(DATE,'MMMM') = 'January' THEN 1 ELSE 0 END) AS JanFlights,
    SUM(CASE WHEN FORMAT(DATE,'MMMM') = 'February' THEN 1 ELSE 0 END) AS FebFlights,
    SUM(CASE WHEN FORMAT(DATE,'MMMM') = 'March' THEN 1 ELSE 0 END) AS MarFlights
-- Add for other months
FROM Flight_Data
GROUP BY Airline;

--Insight: See airline seasonality trends.

--Identify repeat flights (same Airline, Source, Destination, Dept_time)
SELECT Airline, Source, Destination, Dept_time, COUNT(*) AS FlightCount
FROM Flight_Data
GROUP BY Airline, Source, Destination, Dept_time
HAVING COUNT(*) > 1
ORDER BY FlightCount DESC;

---Insight: Detects high-frequency flights for route planning.

-- Advanced EDA: End-to-End Real-Time Business Problems
-- 1. Forecast future monthly revenue trends (Rolling average as base for forecast)
WITH MonthlyRevenue AS (
    SELECT 
        Year,
        Month,
        SUM(CAST(Price AS FLOAT)) AS TotalRevenue
    FROM Flight_Data
    GROUP BY Year, Month
),
RollingAvg AS (
    SELECT *,
        AVG(TotalRevenue) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Rolling3MonthAvg
    FROM MonthlyRevenue
)
SELECT *
FROM RollingAvg
ORDER BY Year, Month;
---Insight: Predict upcoming revenue trends based on historical data (basic forecasting baseline).

---2. Identify top 5% high-value flights by price (Percentile Rank)

WITH PriceRank AS (
    SELECT *,
        PERCENT_RANK() OVER (ORDER BY CAST(Price AS FLOAT) DESC) AS PricePercentile
    FROM Flight_Data
)
SELECT *
FROM PriceRank
WHERE PricePercentile <= 0.05
ORDER BY Price;
Insight: Focus on premium ticket sales driving significant revenue.

-- 3. Cohort analysis: Compare revenue growth for each airline since its first appearance
WITH AirlineFirstMonth AS (
    SELECT 
        Airline,
        MIN(CONCAT(Year, '-', Month)) AS FirstMonth
    FROM Flight_Data
    GROUP BY Airline
),
RevenueByMonth AS (
    SELECT 
        Airline,
        CONCAT(Year, '-', Month) AS Period,
        SUM(CAST(Price AS FLOAT)) AS TotalRevenue
    FROM Flight_Data
    GROUP BY Airline, Year, Month
)
SELECT 
    R.Airline,
    A.FirstMonth,
    R.Period,
    R.TotalRevenue
FROM RevenueByMonth R
INNER JOIN AirlineFirstMonth A
ON R.Airline = A.Airline
ORDER BY R.Airline, R.Period;
--Insight: Measures how airlines grow revenue relative to their first month in the dataset.
-- 4. Analyze customer travel patterns by flight timing (Morning/Afternoon/Evening/Night)
SELECT 
    Dept_time_Period,
    COUNT(*) AS TotalFlights,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue,
    AVG(CAST(Duration AS FLOAT)) AS AvgDuration
FROM Flight_Data
GROUP BY Dept_time_Period
ORDER BY TotalFlights DESC;
--Insight: Shows demand concentration across the day and average trip lengths.

-- 5. Route profitability: Find top 10 most profitable source-destination pairs

SELECT TOP 10
    Source,
    Destination,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue,
    COUNT(*) AS TotalFlights
FROM Flight_Data
GROUP BY Source, Destination
ORDER BY TotalRevenue DESC;
Insight: Prioritize routes contributing the most to revenue.

-- 6. Detect seasonality: Flights and revenue per quarter

SELECT 
    CASE 
        WHEN Month IN ('January', 'February', 'March') THEN 'Q1'
        WHEN Month IN ('April', 'May', 'June') THEN 'Q2'
        WHEN Month IN ('July', 'August', 'September') THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    COUNT(*) AS TotalFlights,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue
FROM Flight_Data
GROUP BY 
    CASE 
        WHEN Month IN ('January', 'February', 'March') THEN 'Q1'
        WHEN Month IN ('April', 'May', 'June') THEN 'Q2'
        WHEN Month IN ('July', 'August', 'September') THEN 'Q3'
        ELSE 'Q4'
    END
ORDER BY Quarter;
--Insight: Identify peak quarters to plan capacity and promotions.

-- 7. Price sensitivity: Compare average price vs. number of stops

SELECT 
    Stops,
    COUNT(*) AS TotalFlights,
    AVG(CAST(Price AS FLOAT)) AS AvgPrice
FROM Flight_Data
GROUP BY Stops
ORDER BY Stops;
--Insight: Understand how stopovers influence customer pricing decisions.

-- 8. Class-based revenue contribution for each airline
SELECT 
    Airline,
    Class,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue,
    SUM(CAST(Price AS FLOAT)) * 100.0 / SUM(SUM(CAST(Price AS FLOAT))) OVER (PARTITION BY Airline) AS ClassRevenueShare
FROM Flight_Data
GROUP BY Airline, Class
ORDER BY Airline, ClassRevenueShare DESC;
--Insight: See how much revenue comes from Economy vs Business for each airline.

-- 9. Detect flights with above-average delays (if Delay info exists)

-- Assuming there's a column DelayMinutes
SELECT *
FROM Flight_Data
WHERE CAST(Duration AS FLOAT) > (
    SELECT AVG(CAST(Duration AS FLOAT)) FROM CleanFinalDataset
)
ORDER BY CAST(Duration AS FLOAT) DESC;
--Insight: Highlight long-duration flights for investigation.

-- 10. Airline market share analysis by total flights and revenue

SELECT 
    Airline,
    COUNT(*) AS TotalFlights,
    SUM(CAST(Price AS FLOAT)) AS TotalRevenue,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CleanFinalDataset) AS FlightSharePercent,
    SUM(CAST(Price AS FLOAT)) * 100.0 / (SELECT SUM(CAST(Price AS FLOAT)) FROM CleanFinalDataset) AS RevenueSharePercent
FROM Flight_Data
GROUP BY Airline
ORDER BY RevenueSharePercent DESC;
--Insight: Pinpoints airlines dominating the market by volume and revenue.
