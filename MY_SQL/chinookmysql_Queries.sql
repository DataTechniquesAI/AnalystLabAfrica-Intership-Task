CREATE DATABASE chinook;
USE chinook;
SELECT * FROM customer;
-- Explanation & Insight:
 -- This query retrieves all columns and records from the customer table
 -- to preview the available fields (such as Name, Address, Contact Info).
 -- From a business perspective, this serves as the foundational data 
 -- exploration step to understand the structural schema before building customer profiles.
 
 
SELECT CustomerId,
FirstName,
LastName,
State,
Country,
PostalCode
FROM customer
WHERE Country='USA'
ORDER BY FirstName DESC;
-- Explanation & Insight:
--  This query isolates customer profiles belonging
--  exclusively to the 'USA' market and sorts them alphabetically by their first name.
--  This enables regional marketing teams to build targeted geo-specific email 
-- campaigns and seamlessly organize database records for active regions.


-- Average revenue USA
SELECT BillingCountry,
AVG(Total) AS Total_Revenue
FROM invoice
WHERE BillingCountry='USA'
GROUP BY BillingCountry
ORDER BY BillingCountry DESC
;
-- Explanation & Insight:
--  This query calculates the Average Order Value (AOV)
--  for transactions within the United States.
-- Understanding the AOV helps management evaluate pricing models,
-- assess customer purchasing power per transaction,
-- and design effective bundled offerings to boost regional sales.

-- City-wise Revenue Distribution
SELECT 
SUM(Total) AS Total_revenue,
COUNT(InvoiceId) AS Total_Bills,
BillingCountry,
BillingCity
FROM invoice
GROUP BY 
BillingCountry,
BillingCity
ORDER BY BillingCountry DESC;
-- Explanation & Insight: 
-- By grouping financial records by country and city,
-- this query calculates total revenue alongside order frequencies.
-- It highlights top-performing geographic clusters,
-- allowing leadership to allocate expansion budgets and marketing 
-- resources to high-yielding cities.

-- Customer Invoice Matching (INNER JOIN)
SELECT 
c.CustomerId, c.FirstName,
i.InvoiceId,i.Total
FROM customer c
INNER JOIN invoice i ON c.CustomerId = c.CustomerId;
-- Explanation & Insight:
-- An INNER JOIN is utilized to map customers directly to their corresponding sales bills.
-- This allows the billing and operations teams to monitor active purchasing accounts and maintain a
--  transparent audit trail of transaction histories.

-- Customer Support Representative Mapping (LEFT JOIN)
SELECT c.CustomerId, c.City AS Customer_City,
e.EmployeeId,e.City AS Employee_City
From customer c
LEFT JOIN employee e ON c.SupportRepId=e.EmployeeId;
-- Explanation & Insight:
--  This query executes a LEFT JOIN to map customers
-- to their designated support agents.
-- It ensures that even if a customer has no assigned representative,
-- their data is still captured. This insight helps assess employee workload distribution and
-- optimize customer service management.



-- Invoice Completeness Audit (RIGHT JOIN)
SELECT c.CustomerId, C.City,
i.InvoiceId,i.Total
FROM customer c
RIGHT JOIN 
invoice i ON c.customerId=c.customerId; 
-- Explanation & Insight:
--  A RIGHT JOIN is applied as a systemic audit to ensure
-- that every recorded transaction is correctly tied back to a valid customer profile.
-- This prevents structural orphan records, ensures clean bookkeeping,
-- and identifies any internal software logging anomalies.

-- Track Size Ranking within Genres (Window Functions)
SELECT TrackId,
Name,
GenreId,
Bytes,
ROW_NUMBER() OVER(PARTITION BY GenreId ORDER BY Bytes DESC) AS Serial_No,
RANK() OVER(PARTITION  BY GenreId ORDER BY Bytes DESC) AS Class_Rank
FROM track;
-- Explanation & Insight:
--  Using analytical window functions (ROW_NUMBER and RANK), 
-- this query sequences audio tracks based on file size (Bytes)
-- within each individual music genre.
--  This allows engineering teams to identify heavy digital media files,
-- optimizing server allocation and cloud storage strategies.





-- Bussiness Problem Solving;
-- Answer key analytical questions such as:
-- • Top-performing 10 customers

SELECT c.CustomerId,
SUM(i.Total) AS Total_Revenue 
FROM customer c
INNER JOIN invoice i ON c.CustomerId=i.CustomerId
GROUP BY c.CustomerId
ORDER BY Total_Revenue DESC 
LIMIT 10;
-- Insight & Explanation:
--  This query extracts the company's top 10 high-value VIP consumers
--  based on cumulative spending. The business can leverage this data
--  to implement high-tier retention programs, exclusive loyalty rewards, or 
-- premium support features to protect core revenue channels.


-- TOP performing Products



SELECT t.Name,
SUM(il.Quantity) AS Total_Sold
From track t
INNER JOIN invoiceline il ON t.TrackId=il.TrackId
GROUP BY t.Name
ORDER BY Total_Sold DESC
LIMIT 10;
-- Explanation & Insight: 
-- This query identifies the top 10 most popular audio tracks by
-- unit sales volume. The content acquisition team can use these 
-- demand trends to prioritize similar artists or 
-- license highly sought-after genres to maximize download trends.

-- Revenue Trends Over Time

SELECT YEAR(InvoiceDate) AS Year_Revenue,
SUM(Total) AS Total_Revenue
 FROM invoice
 GROUP BY YEAR(InvoiceDate)
 ORDER BY Year_Revenue;
 -- Explanation & Insight:
 -- This captures Year-over-Year (YoY) fiscal performance
 -- trends by summing total annual revenue.
 -- Executive boards rely heavily on this trend line to measure global business expansion, 
 -- track operational sustainability, and establish long-term financial budgets.
 
 
 -- Customer Purchasing Behavior
 
 SELECT c.CustomerId,
 c.FirstName,
 COUNT(i.InvoiceId) AS Total_Orders,
 AVG(i.Total) AS AVG_Order_Value
 FROM customer c 
 INNER JOIN invoice i  ON  c.CustomerId=i.CustomerId
 GROUP BY c.CustomerId,c.FirstName
ORDER BY AVG_Order_Value DESC;
-- Explanation & Insight:
--  This query creates a holistic behavioral profile
--  for each customer by calculating their absolute purchase frequency alongside
--  their average transaction value. It effectively segments "frequent buyers" 
-- from "one-time big spenders," allowing marketing teams
--  to optimize their customer lifecycle strategies.



-- Note: The following index commands are commented out because these indexes 
-- are already automatically created by the database engine on Primary/Foreign Keys.
-- Running them again would cause a 'Duplicate Key Name' error.





CREATE INDEX idx_CustomerId ON customer(CustomerId);
CREATE INDEX idx_TrackId ON track(TrackId);
CREATE INDEX idx_InvoiceID ON invoice(InvoiceId);
CREATE INDEX idx_Invoiceline_TrackId ON invoiceline(TrackId);

-- Database Performance Optimization Strategy:

-- Avoiding Table Scans:
--  When joining multiple tables (such as linking Customers with Invoices
--  or Tracks with Invoice Lines), 
-- the database engine has to scan through rows to match IDs.
--  By ensuring that keys like CustomerId and TrackId are indexed,
--  we reduce the search complexity from a slow linear scan to a highly efficient binary lookup.
-- Pre-existing Keys: 
-- In the Chinook database, these critical columns are already indexed automatically by the system as part of the database structure (Primary and Foreign Key constraints). 
-- Explicitly creating them again is unnecessary,
--  but understanding their presence is vital for writing high-performance queries on larger production datasets.