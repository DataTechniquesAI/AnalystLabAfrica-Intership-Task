USE sale_analysis;
SELECT * FROM sales_data_sample;
-- Explanation & Insight:
--  This query extracts all available columns and rows from the sales dataset to inspect
--  its structure. From a business standpoint, this acts as the preliminary 
-- data exploration phase to understand transactional fields
-- (such as pricing, client records, and dates) before building deep dashboards.


-- SELECT, WHERE, and ORDER BY
SELECT ORDERNUMBER,
SALES,
QUANTITYORDERED,
STATUS,
YEAR_ID,
CITY FROM sales_data_sample
WHERE CITY='Oulu'
 AND STATUS ='Shipped'
AND QUANTITYORDERED > 30
ORDER BY ORDERNUMBER DESC;
-- Explanation & Insight: 
-- This query filters high-volume transactions (over 30 items)
--  successfully shipped to the city of 'Oulu', sorted chronologically.
-- This allows regional logistics managers to track operational milestones and analyze 
-- wholesale fulfillment performance in specific localized markets.  


-- SUM, GROUP BY ,ORDER BY 
SELECT QTR_ID, SUM(SALES) AS Total_Sales
FROM sales_data_sample
GROUP BY QTR_ID
ORDER BY QTR_ID;
-- Explanation & Insight:
-- This query aggregates transaction amounts across operational 
-- quarters (QTR_ID). This allows financial planning teams to spot historical 
-- seasonal spikes, helping them plan inventory strategies for peak retail quarters.  





-- SELECT, WHERE, and ORDER BY
SELECT YEAR_ID,
SUM(SALES) AS Total_Revenue,
AVG(SALES) AS Avg_Sales,
COUNT(DISTINCT ORDERNUMBER) AS Total_Number
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

-- Explanation & Insight:
-- By grouping data by year, this query monitors key performance indicators (KPIs) like revenue growth,
-- single-order size averages, and unique purchase volumes.
-- Executive boards use these macro-level metrics to evaluate long-term financial health
-- and year-over-year market expansions.  



-- GROUP BY with HAVING
SELECT COUNTRY ,
SUM(SALES) AS Total_Country_sales
FROM sales_data_sample
GROUP BY COUNTRY
HAVING SUM(SALES) > 20000
ORDER BY COUNTRY;

-- Explanation & Insight:
-- This query calculates collective regional sales but utilizes 
-- the HAVING clause to keep only those countries driving more than
-- $20,000 in gross revenue. This isolates high-yielding international territories,
-- letting marketing heads know exactly where to prioritize expansion investments.


-- Pricing Distribution Screening
SELECT COUNTRY,PRICEEACH FROM sales_data_sample
WHERE PRICEEACH = '100'
GROUP BY COUNTRY,PRICEEACH
ORDER BY PRICEEACH ;
-- Explanation & Insight:
-- This query segments transactions looking exclusively at standard items 
-- priced at the $100 price point. It gives stock managers visibility
-- into which countries are actively purchasing standard flat-rate products to
-- adapt international pricing tiers.



-- Self join
SELECT a.ORDERNUMBER, 
a.PRODUCTCODE AS Product_1,
 b.PRODUCTCODE AS Product_2, 
 a.CITY
FROM sales_data_sample a
INNER JOIN sales_data_sample b 
    ON a.ORDERNUMBER = b.ORDERNUMBER 
    AND a.PRODUCTCODE <> b.PRODUCTCODE
LIMIT 10;
-- Explanation & Insight:
--  By joining the dataset onto itself, this query identifies pairs of
-- unique products bought together under the same order number.
-- This market basket insight allows sales teams to implement product bundles
-- and build targeted cross-selling strategies

-- SubQuery
SELECT ORDERNUMBER, CUSTOMERNAME, SALES
FROM sales_data_sample
WHERE SALES > (SELECT AVG(SALES) FROM sales_data_sample)
ORDER BY SALES DESC;

-- Explanation & Insight:
-- This query isolates high-value transactions that sit strictly 
-- above the absolute global average transaction value. 
-- This filters out routine retail orders, giving financial controllers
-- immediate visibility into major corporate deals for risk auditing.  

-- Window Function
SELECT YEAR_ID, PRODUCTLINE, SALES,
       ROW_NUMBER() OVER (PARTITION BY YEAR_ID ORDER BY SALES DESC) AS Row_Num,
       RANK() OVER (PARTITION BY YEAR_ID ORDER BY SALES DESC) AS Sales_Rank
FROM sales_data_sample;
-- Explanation & Insight:
-- Utilizing window functions (ROW_NUMBER and RANK), 
-- this query profiles product lines by annual performance without compressing
-- transactional data. It gives category managers an uncompressed view 
-- of internal product standings year by year



-- Top-performing products and customers
SELECT CUSTOMERNAME, SUM(SALES) AS Total_Spent, COUNT(DISTINCT ORDERNUMBER) AS Total_Orders
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Spent DESC
LIMIT 5;
-- Explanation & Insight:
-- This query ranks the company's top 5 premium corporate accounts based on 
-- cumulative lifetime billing. Account management teams leverage this to deliver high-priority 
-- service packages or
 -- tier-based loyalty discounts to protect major revenue streams.



-- Revenue trends over time

SELECT YEAR_ID, MONTH_ID, SUM(SALES) AS Monthly_Revenue
FROM sales_data_sample
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;
-- Explanation & Insight: 
-- This query details cyclical performance by mapping out product transactions across 
-- a structured monthly timeline. This continuous performance line lets managers
-- evaluate macro-economic patterns and spot monthly operational dips.

-- : Customer purchasing behavior
SELECT CUSTOMERNAME, 
       AVG(QUANTITYORDERED) AS Avg_Quantity_Per_Item, 
       SUM(QUANTITYORDERED) AS Total_Quantity_Bought,
       COUNT(DISTINCT ORDERNUMBER) AS Unique_Orders_Placed
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Quantity_Bought DESC;
-- Explanation & Insight:
--  This query profiles buyers by grouping transaction frequencies, 
-- total volumes, and average item quantities together.
--  It segments steady bulk wholesale partners from erratic retail clients,
-- enabling optimized pricing frameworks.




-- Query Optimization



ALTER TABLE sales_data_sample MODIFY COLUMN CUSTOMERNAME VARCHAR(255);
ALTER TABLE sales_data_sample MODIFY COLUMN CITY VARCHAR(100);

-- Explanation & Insight:
-- Replacing unstructured text parameters with tightly constrained VARCHAR data limits
-- stabilizes table structure. This enforces schema validation rules, reclaims
-- unnecessary disk space, and boosts memory buffer efficiency during complex joins.  


CREATE INDEX idx_customer ON sales_data_sample(CUSTOMERNAME);
CREATE INDEX idx_sales_city ON sales_data_sample(CITY);

-- Explanation & Insight: 
-- Generating structured, active B-Tree indexing parameters on heavily queried attributes
--  prevents slow, sequential full-table scans. This ensures dashboard execution times 
-- remain fast and stable, keeping queries fast even as data volumes grow.  

-- Dear Mentor/Evaluator,

-- Please find attached the completed SQL script file (.sql) containing the exact executable queries run during my week's analysis task on the 'sales_data_sample' database. Below is a structured technical explanation of the queries implemented:

-- 1. Core SQL Filters & Logical Ordering:
--  Implemented transactional filtering matching the city 'Oulu' and 'Shipped' status, sorting records by order number in descending order.
--  Utilized structured condition limits (QUANTITYORDERED > 30) to pinpoint high-volume freight demands in localized regions.
--  Structured price point distribution parameters looking into specific standard items (PRICEEACH = '100').

-- 2. Aggregations & Grouped Metrics:
-- Applied SUM(), AVG(), and COUNT(DISTINCT) aggregates to systematically generate growth vectors across different fiscal years and sub-cycle quarters (QTR_ID).
-- Leveraged the HAVING clause over grouped countries to filter out geopolitical zones contributing gross revenue figures above the $20,000 threshold.

-- 3. Advanced Analytical Constructs:
-- Market Basket Affinity Analysis: Applied an INNER JOIN on the table onto itself to extract distinct product co-occurrences sharing identical order numbers.
-- High-Margin Outlier Capture: Used a nested subquery filtering transactions with values strictly greater than the absolute average order calculation.
-- Window Function Indexing: Implemented ROW_NUMBER() and RANK() partitioned by YEAR_ID to dynamically evaluate annual top performing product stands without compressing row integrity.

-- 4. Query Optimization & Schema Tuning:
-- Modified unstructured data definitions from variable TEXT limits into standard VARCHAR data constraints.
-- Generated structural active B-Tree indexes (idx_customer, idx_sales_city) to optimize internal engine scanning speeds and eradicate slow sequential full-table scans.

-- The attached .sql file is complete, optimized, and ready for validation. 

-- Regards,
-- Sumaiya
 -- Data Analyst Intern


