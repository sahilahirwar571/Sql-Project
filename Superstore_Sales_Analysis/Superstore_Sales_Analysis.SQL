-- Project : Superstore Sales Analysis

-- Step 1: Create and select database
CREATE DATABASE superstore_db;
USE superstore_db;

-- Step 2: Create the table structure

CREATE TABLE superstore_sales (
    `Row ID` INT,
    `Order ID` VARCHAR(20),
    `Order Date` VARCHAR(20),
    `Ship Date` VARCHAR(20),
    `Ship Mode` VARCHAR(30),
    `Customer ID` VARCHAR(20),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(30),
    `Country` VARCHAR(50),
    `City` VARCHAR(50),
    `State` VARCHAR(50),
    `Postal Code` VARCHAR(10),
    `Region` VARCHAR(20),
    `Product ID` VARCHAR(30),
    `Category` VARCHAR(30),
    `Sub-Category` VARCHAR(30),
    `Product Name` VARCHAR(200),
    `Sales` DOUBLE,
    `Quantity` INT,
    `Discount` DOUBLE,
    `Profit` DOUBLE
);

-- Step 3: Load the data
-- Note: Update the file path below to match your local CSV location.
-- If you get an error that LOCAL INFILE is disabled, run:
-- SET GLOBAL local_infile = 1;
-- and enable "OPT_LOCAL_INFILE=1" in your connection's Advanced settings.

LOAD DATA LOCAL INFILE 'C:/Users/DELL/OneDrive/Desktop/Sql-Project/Superstore_Sales_Analysis/superstore_sales.csv'
INTO TABLE superstore_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Step 4: Analysis Queries

-- Q1. Display all records.
SELECT *
FROM superstore_sales;

-- Q2. Find the total number of orders.
SELECT COUNT(*) AS total_orders
FROM superstore_sales;

-- Q3. Retrieve all Technology category orders.
SELECT *
FROM superstore_sales
WHERE Category = 'Technology';

-- Q4. Find total sales by category.
SELECT Category,
SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Category;

-- Q5. Find categories with sales greater than 100000.
SELECT Category,
       SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Category
HAVING total_sales > 100000;

-- Q6. Count orders in each category.
SELECT Category,
       COUNT(*) AS total_orders
FROM superstore_sales
GROUP BY Category;

-- Q7. Calculate average profit by category.
SELECT Category,
       AVG(Profit) AS avg_profit
FROM superstore_sales
GROUP BY Category;

-- Q8. Find categories with average profit greater than 50.
SELECT Category,
       AVG(Profit) AS avg_profit
FROM superstore_sales
GROUP BY Category
HAVING AVG(Profit) > 50;

-- Q9. Retrieve Technology products with profit greater than 1000.
SELECT *
FROM superstore_sales
WHERE Category = 'Technology'
AND Profit > 1000;

-- Q10. Find top 5 products by total sales.
SELECT `Product Name`,
       SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 5;

-- Q11. Find top 3 most profitable products.
SELECT `Product Name`,
       SUM(Profit) AS total_profit
FROM superstore_sales
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 3;

-- Q12. Find total sales by region.
SELECT Region,
       SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Region;

-- Q13. Find top 3 regions by sales.
SELECT Region,
       SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC
LIMIT 3;

-- Q14. Find total profit by category.
SELECT Category,
       SUM(Profit) AS total_profit
FROM superstore_sales
GROUP BY Category;

-- Q15. Find the total profit for the Furniture category.
SELECT Category,
       SUM(Profit) AS total_profit
FROM superstore_sales
WHERE Category = 'Furniture'
GROUP BY Category;

-- Q16. Retrieve all South region orders.
SELECT *
FROM superstore_sales
WHERE Region = 'South';

-- Q17. Find products with sales above average.
SELECT `Product Name`,
       Sales
FROM superstore_sales
WHERE Sales >
(
SELECT AVG(Sales)
FROM superstore_sales
);

-- Q18. Find sales by category and product.
SELECT Category,
       `Product Name`,
       SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Category, `Product Name`
ORDER BY Category, total_sales DESC;

-- Q19. Classify products based on profit.
SELECT `Product Name`,
       Profit,
       CASE
            WHEN Profit > 100 THEN 'High Profit'
            WHEN Profit > 0 THEN 'Low Profit'
            ELSE 'Loss'
       END AS Profit_Type
FROM superstore_sales;

-- Q20. Find the month with the highest total sales using a CTE
   WITH monthly_sales AS (
    SELECT MONTH(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) AS order_month,
           SUM(Sales) AS total_sales
    FROM superstore_sales
    GROUP BY MONTH(STR_TO_DATE(`Order Date`, '%m/%d/%Y'))
)
SELECT * FROM monthly_sales
ORDER BY total_sales DESC
LIMIT 1;
   

-- Q21. Rank products within each category by total sales (window function)
   SELECT Category, `Product Name`, total_sales,
          RANK() OVER (PARTITION BY Category ORDER BY total_sales DESC) AS sales_rank
   FROM (
       SELECT Category, `Product Name`, SUM(Sales) AS total_sales
       FROM superstore_sales
       GROUP BY Category, `Product Name`
   ) t;

-- Q22. Running total of sales ordered by date (window function)
   SELECT `Order Date`, Sales,
          SUM(Sales) OVER (ORDER BY `Order Date`) AS running_total
   FROM superstore_sales;
