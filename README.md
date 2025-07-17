# Data-Analytics-Flight-Fare-Analysis-and-Revenue-Insights-using-SQL

## ✈️ 1. Objective
The primary objective of this project is to perform comprehensive SQL-based analysis on flight fare datasets across Business and Economy classes to:

Clean and unify inconsistent raw data.

Merge datasets to generate a consolidated view.

Derive actionable insights related to routes, pricing, airline performance, and customer behavior.

Enable data-driven decisions for operational efficiency, route planning, pricing strategy, and customer segmentation.

## 🧾 2. Dataset Used
Raw Datasets:
unclean_business (Business class flight data)

unclean_economy (Economy class flight data) - https://github.com/satish2502/Data-Analytics-Flight-Fare-Analysis-and-Revenue-Insights-using-SQL/blob/main/economy_Un.csv

Unified Structure (Post Cleaning):
Flight_Data – A consolidated SQL view created after cleaning and transforming both datasets.

### Key Features:
Date, Airline, Flight, Source, Destination

Departure Time, Arrival Time, Duration, Stops

Class, Price, and engineered fields like:

Time_of_day, No_of_stops, Duration_mins, etc.

## ❓ 3. Business Questions Solved
Through structured SQL queries, the following business questions were addressed:

### Volume-based:

Total number of flights by airline, route, class.

Flights per day/month/year.

Top cities in terms of source/destination traffic.

### Revenue Analysis:

Total and average fare by class, airline, and route.

Top 5% highest-priced flights.

Airline revenue comparison.

### Performance Metrics:

Most profitable routes per airline.

Market share by number of flights and revenue.

Monthly revenue trends and seasonality.

### Customer Preference Insights:

Peak vs off-peak travel times.

One-stop vs non-stop preference.

Most common source-destination pairs.

### Advanced KPIs:

Cohort revenue growth by month.

Rank airlines by class-wise revenue.

Identify low-duration high-price flights (premium express).

## ⚙️ 4. Process
### 🔹 Step 1: Data Cleaning
Cleaned and standardized:

Date formats (varchar to DATE)

Duration (e.g., “3h 45m” to total minutes)

Stops (e.g., “non-stop” → 0, “1 stop” → 1)

Time formats using CAST and CONVERT.

### 🔹 Step 2: Data Integration
Merged cleaned Business and Economy datasets using UNION ALL.

Created a view Flight_Data with additional derived fields:

Time_of_day (Early Morning, Morning, Afternoon, Evening, Night)

No_of_stops as numeric

Duration in minutes (Duration_mins)

Class Label (Business/Economy)

### 🔹 Step 3: Data Analysis Using SQL
Used:

Basic Aggregates (SUM, AVG, COUNT)

Window Functions (RANK(), ROW_NUMBER(), LAG())

Conditional Queries (CASE, WHERE, BETWEEN)

Joins and CTEs for complex logic.

🔹 Step 4: Dashboard Preparation (Optional Step)
Prepared the dataset for use in Power BI or Tableau with clean, labeled columns.

## 💡 5. Key Insights
### Airline Trends:

Few airlines dominate both volume and revenue.

Some regional airlines focus on short routes but offer competitive pricing.

### Revenue Drivers:

Business class, though fewer in number, contributes nearly 40–50% of total revenue.

Flights with fewer stops have higher fares due to convenience.

### Route Insights:

Certain city pairs (e.g., Delhi–Mumbai, Bengaluru–Hyderabad) account for bulk bookings and revenue.

Non-metro routes show potential for growth with rising fares.

### Customer Preferences:

Most passengers prefer early morning and evening slots.

Direct (non-stop) flights are significantly more popular.

### Seasonal Patterns:

Fare spikes observed in Q1 (January–March) and Q4 (October–December).

Off-peak travel months show lower volume but higher per-ticket price.

### Premium Segments:

Top 5% of flights priced well above average, mostly Business class.

Some high-priced Economy flights are on premium routes or peak hours.

## ✅ 6. Recommendations
### Route Planning:

Increase frequency on profitable, high-demand routes.

Expand presence in Tier-2 cities showing high average fare.

### Pricing Strategy:

Dynamic pricing during off-peak hours and low-demand months.

Offer bundled premium services for top 5% expensive flights.

### Customer Segmentation:

Market differently for Business vs Economy segments.

Reward frequent flyers on low-competition but high-margin routes.

### Operational Efficiency:

Focus on increasing direct flights over connecting ones.

Use fare and duration analytics to reduce inefficient long-duration flights.

### Forecasting:

Use historical trends to pre-plan fleet capacity and marketing in high-revenue months.

## 🧾 7. Conclusion
This SQL-based flight fare analysis effectively cleansed and merged raw airline data into a usable format and extracted meaningful insights related to revenue, customer behavior, pricing patterns, and airline performance.

By answering critical business questions, this project enables better decision-making for:

Route optimization

Pricing strategy

Segment-specific promotions

Operational planning
