CREATE DATABASE chinook;
USE chinook;
SELECT * FROM customer;


SELECT CustomerId,
FirstName,
LastName,
State,
Country,
PostalCode
FROM customer
WHERE Country='USA'
ORDER BY FirstName DESC;


SELECT BillingCountry,
AVG(Total) AS Total_Revenue
FROM invoice
WHERE BillingCountry='USA'
GROUP BY BillingCountry
ORDER BY BillingCountry DESC
;

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

SELECT 
InvoiceId,
UnitPrice,
Quantity









