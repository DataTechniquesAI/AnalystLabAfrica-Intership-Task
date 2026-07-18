USE sale_analysis;
SELECT * FROM sales_data_sample;

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
-- SUM, GROUP BY ,ORDER BY 
SELECT QTR_ID, SUM(SALES) AS Total_Sales
FROM sales_data_sample
GROUP BY QTR_ID
ORDER BY QTR_ID;

-- SELECT, WHERE, and ORDER BY
SELECT YEAR_ID,
SUM(SALES) AS Total_Revenue,
AVG(SALES) AS Avg_Sales,
COUNT(DISTINCT ORDERNUMBER) AS Total_Number
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY YEAR_ID;

-- GROUP BY with HAVING
SELECT COUNTRY ,
SUM(SALES) AS Total_Country_sales
FROM sales_data_sample
GROUP BY COUNTRY
HAVING SUM(SALES) > 20000
ORDER BY COUNTRY;



SELECT COUNTRY,PRICEEACH FROM sales_data_sample
WHERE PRICEEACH = '100'
GROUP BY COUNTRY,PRICEEACH
ORDER BY PRICEEACH ;

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

-- SubQuery
SELECT ORDERNUMBER, CUSTOMERNAME, SALES
FROM sales_data_sample
WHERE SALES > (SELECT AVG(SALES) FROM sales_data_sample)
ORDER BY SALES DESC;

-- Window Function
SELECT YEAR_ID, PRODUCTLINE, SALES,
       ROW_NUMBER() OVER (PARTITION BY YEAR_ID ORDER BY SALES DESC) AS Row_Num,
       RANK() OVER (PARTITION BY YEAR_ID ORDER BY SALES DESC) AS Sales_Rank
FROM sales_data_sample;

-- Top-performing products and customers
SELECT CUSTOMERNAME, SUM(SALES) AS Total_Spent, COUNT(DISTINCT ORDERNUMBER) AS Total_Orders
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Spent DESC
LIMIT 5;

-- Revenue trends over time

SELECT YEAR_ID, MONTH_ID, SUM(SALES) AS Monthly_Revenue
FROM sales_data_sample
GROUP BY YEAR_ID, MONTH_ID
ORDER BY YEAR_ID, MONTH_ID;

-- : Customer purchasing behavior
SELECT CUSTOMERNAME, 
       AVG(QUANTITYORDERED) AS Avg_Quantity_Per_Item, 
       SUM(QUANTITYORDERED) AS Total_Quantity_Bought,
       COUNT(DISTINCT ORDERNUMBER) AS Unique_Orders_Placed
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_Quantity_Bought DESC;

-- Query Optimization



ALTER TABLE sales_data_sample MODIFY COLUMN CUSTOMERNAME VARCHAR(255);
ALTER TABLE sales_data_sample MODIFY COLUMN CITY VARCHAR(100);


CREATE INDEX idx_customer ON sales_data_sample(CUSTOMERNAME);
CREATE INDEX idx_sales_city ON sales_data_sample(CITY);



Dear Mentor/Evaluator,

Please find attached the completed SQL script file (.sql) containing the exact executable queries run during my week's analysis task on the 'sales_data_sample' database. Below is a structured technical explanation of the queries implemented:

1. Core SQL Filters & Logical Ordering:
- Implemented transactional filtering matching the city 'Oulu' and 'Shipped' status, sorting records by order number in descending order.
- Utilized structured condition limits (QUANTITYORDERED > 30) to pinpoint high-volume freight demands in localized regions.
- Structured price point distribution parameters looking into specific standard items (PRICEEACH = '100').

2. Aggregations & Grouped Metrics:
- Applied SUM(), AVG(), and COUNT(DISTINCT) aggregates to systematically generate growth vectors across different fiscal years and sub-cycle quarters (QTR_ID).
- Leveraged the HAVING clause over grouped countries to filter out geopolitical zones contributing gross revenue figures above the $20,000 threshold.

3. Advanced Analytical Constructs:
- Market Basket Affinity Analysis: Applied an INNER JOIN on the table onto itself to extract distinct product co-occurrences sharing identical order numbers.
- High-Margin Outlier Capture: Used a nested subquery filtering transactions with values strictly greater than the absolute average order calculation.
- Window Function Indexing: Implemented ROW_NUMBER() and RANK() partitioned by YEAR_ID to dynamically evaluate annual top performing product stands without compressing row integrity.

4. Query Optimization & Schema Tuning:
- Modified unstructured data definitions from variable TEXT limits into standard VARCHAR data constraints.
- Generated structural active B-Tree indexes (idx_customer, idx_sales_city) to optimize internal engine scanning speeds and eradicate slow sequential full-table scans.

The attached .sql file is complete, optimized, and ready for validation. 

Regards,
Sumaiya
Data Analyst Intern


