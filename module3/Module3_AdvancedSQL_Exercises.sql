-- ===============================================================================
-- CTS Digital Nurture 5.0 - Deep Skilling
-- Module 3: Advanced SQL Using SQL Server
-- ===============================================================================

-- ===============================================================================
-- PART 1: Online Retail Store Database (Advanced Concepts, Indexing, CTEs)
-- ===============================================================================

-- Create database if not exists (Note: Run on MS SQL Server)
-- CREATE DATABASE OnlineRetailStore;
-- GO
-- USE OnlineRetailStore;
-- GO

-- Drop existing tables to ensure a clean run
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.StagingProducts', 'U') IS NOT NULL DROP TABLE dbo.StagingProducts;

-- Create Tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Sample Data
INSERT INTO Customers (CustomerID, Name, Region) VALUES
(1, 'Alice', 'North'),
(2, 'Bob', 'South'),
(3, 'Charlie', 'East'),
(4, 'David', 'West'),
(5, 'Eva', 'North'),
(6, 'Frank', 'East');

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
-- Electronics
(1, 'Laptop Dell XPS', 'Electronics', 1200.00),
(2, 'Apple iPhone 15', 'Electronics', 1000.00),
(3, 'Samsung Galaxy S24', 'Electronics', 1000.00), -- Tie in Electronics price
(4, 'Sony Headphones', 'Electronics', 300.00),
-- Home & Kitchen
(5, 'Stainless Steel Water Bottle', 'Home & Kitchen', 25.00),
(6, 'Coffee Maker', 'Home & Kitchen', 150.00),
(7, 'Air Fryer XL', 'Home & Kitchen', 150.00), -- Tie in Home & Kitchen price
(8, 'Microwave Oven', 'Home & Kitchen', 120.00),
-- Apparel
(9, 'Leather Jacket', 'Apparel', 250.00),
(10, 'Running Shoes', 'Apparel', 120.00),
(11, 'Woolen Scarf', 'Apparel', 35.00);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2025-01-05'),
(2, 2, '2025-01-10'),
(3, 3, '2025-01-15'),
(4, 4, '2025-01-20'),
(5, 1, '2025-01-22'),
(6, 5, '2025-01-25'),
(7, 3, '2025-01-28'),
(8, 2, '2025-01-29');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 1),
(2, 1, 4, 2),
(3, 2, 2, 1),
(4, 3, 5, 4),
(5, 3, 6, 1),
(6, 4, 9, 1),
(7, 5, 10, 2),
(8, 6, 3, 1),
(9, 7, 7, 1),
(10, 8, 8, 1);

-- -------------------------------------------------------------------------------
-- Exercise 1: Ranking and Window Functions (MANDATORY)
-- Goal: Find top 3 most expensive products in each category using ROW_NUMBER, RANK, DENSE_RANK.
-- -------------------------------------------------------------------------------
PRINT '=== Exercise 1: Ranking and Window Functions ===';

WITH RankedProducts AS (
    SELECT 
        Category,
        ProductName,
        Price,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Price DESC) AS RowNum,
        RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS Rnk,
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS DenseRnk
    FROM Products
)
SELECT 
    Category,
    ProductName,
    Price,
    RowNum,
    Rnk,
    DenseRnk
FROM RankedProducts
WHERE DenseRnk <= 3;
-- Explanation of tie handling:
-- - ROW_NUMBER() assigns a unique sequential integer starting at 1, regardless of ties (e.g. Apple iPhone 15 gets 2 and Samsung Galaxy S24 gets 3).
-- - RANK() assigns same rank to duplicates, but skips subsequent numbers (e.g., both get rank 2, and the next item gets rank 4).
-- - DENSE_RANK() assigns same rank to duplicates, and does NOT skip numbers (e.g., both get rank 2, and the next gets rank 3).

-- -------------------------------------------------------------------------------
-- Exercise 2: Aggregation with GROUPING SETS, CUBE, and ROLLUP
-- Goal: Generate sales reports showing total quantity sold by Region and Category.
-- -------------------------------------------------------------------------------
PRINT '=== Exercise 2: Aggregation with GROUPING SETS, CUBE, and ROLLUP ===';

SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY GROUPING SETS (
    (c.Region, p.Category),
    (c.Region),
    (p.Category),
    ()
);

-- ROLLUP analysis (gives hierarchical subtotals)
SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY ROLLUP (c.Region, p.Category);

-- CUBE analysis (gives all possible combinations of subtotals)
SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY CUBE (c.Region, p.Category);

-- -------------------------------------------------------------------------------
-- Exercise 3: CTEs and MERGE
-- Goal: Recursive CTE to generate date calendar; and MERGE statement for staging updates.
-- -------------------------------------------------------------------------------
PRINT '=== Exercise 3a: Recursive CTE for Calendar ===';

WITH CalendarCTE AS (
    SELECT CAST('2025-01-01' AS DATE) AS CalendarDate
    UNION ALL
    SELECT DATEADD(day, 1, CalendarDate)
    FROM CalendarCTE
    WHERE CalendarDate < '2025-01-31'
)
SELECT CalendarDate FROM CalendarCTE;

PRINT '=== Exercise 3b: MERGE from StagingProducts table ===';

CREATE TABLE StagingProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Load updated and new products into staging
INSERT INTO StagingProducts (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Dell XPS (Updated)', 'Electronics', 1150.00), -- Updated price and name
(4, 'Sony Headphones Premium', 'Electronics', 350.00),     -- Updated price and name
(12, 'Wireless Mouse', 'Accessories', 45.00);               -- New product

-- Execute MERGE
MERGE Products AS target
USING StagingProducts AS source
ON (target.ProductID = source.ProductID)
WHEN MATCHED THEN
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Category = source.Category,
        target.Price = source.Price
WHEN NOT MATCHED THEN
    INSERT (ProductID, ProductName, Category, Price)
    VALUES (source.ProductID, source.ProductName, source.Category, source.Price);

-- Query target table to verify updates
SELECT * FROM Products;

-- -------------------------------------------------------------------------------
-- Exercise 4: PIVOT and UNPIVOT
-- Goal: Pivot sales quantity per product by month, then unpivot back.
-- -------------------------------------------------------------------------------
PRINT '=== Exercise 4: PIVOT and UNPIVOT ===';

-- First, let's create a temporary view or CTE to aggregate quantity by Product and Month
WITH SalesByMonth AS (
    SELECT 
        p.ProductName,
        DATENAME(month, o.OrderDate) AS OrderMonth,
        od.Quantity
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
)
SELECT ProductName, [January] AS Jan_Sales
INTO #PivotedSales
FROM SalesByMonth
PIVOT (
    SUM(Quantity)
    FOR OrderMonth IN ([January])
) AS PivotTable;

SELECT * FROM #PivotedSales;

-- Unpivot the data back to rows
SELECT ProductName, MonthName, Quantity
FROM #PivotedSales
UNPIVOT (
    Quantity FOR MonthName IN (Jan_Sales)
) AS UnpivotTable;

DROP TABLE #PivotedSales;

-- -------------------------------------------------------------------------------
-- Exercise 5: Using CTE to Simplify a Query
-- Goal: Find all customers who have placed more than 3 orders in total.
-- -------------------------------------------------------------------------------
PRINT '=== Exercise 5: Using CTE to find customers with > 3 orders ===';

-- Insert dummy orders to make sure someone has > 3 orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(9, 1, '2025-01-30'),
(10, 1, '2025-01-31');

WITH CustomerOrderCounts AS (
    SELECT 
        o.CustomerID,
        COUNT(o.OrderID) AS OrderCount
    FROM Orders o
    GROUP BY o.CustomerID
)
SELECT 
    c.CustomerID,
    c.Name,
    coc.OrderCount
FROM CustomerOrderCounts coc
JOIN Customers c ON c.CustomerID = coc.CustomerID
WHERE coc.OrderCount > 3;


-- ===============================================================================
-- PART 2: Employee Management System Database (Stored Procedures and Functions)
-- ===============================================================================

-- Drop existing tables to ensure clean run
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;

-- Create Tables
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1), -- Use Identity for auto-increment in newer schemas
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10,2),
    JoinDate DATE
);

-- Insert Sample Data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

-- Turn IDENTITY_INSERT ON to insert predefined IDs if needed, or insert normally:
SET IDENTITY_INSERT Employees ON;
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2020-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2019-03-22'),
(3, 'Michael', 'Johnson', 3, 7000.00, '2018-07-30'),
(4, 'Emily', 'Davis', 4, 5500.00, '2021-11-05');
SET IDENTITY_INSERT Employees OFF;

-- -------------------------------------------------------------------------------
-- Stored Procedures: Exercise 1: Create a Stored Procedure (MANDATORY)
-- -------------------------------------------------------------------------------
GO
PRINT '=== Stored Procedures Exercise 1: Create sp_GetEmployeesByDepartment & sp_InsertEmployee ===';

IF OBJECT_ID('dbo.sp_GetEmployeesByDepartment', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetEmployeesByDepartment;
GO
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        Salary,
        JoinDate
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

IF OBJECT_ID('dbo.sp_InsertEmployee', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_InsertEmployee;
GO
CREATE PROCEDURE sp_InsertEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoinDate DATE
AS
BEGIN
    INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, JoinDate)
    VALUES (@FirstName, @LastName, @DepartmentID, @Salary, @JoinDate);
END;
GO

-- -------------------------------------------------------------------------------
-- Stored Procedures: Exercise 4: Execute a Stored Procedure (ADDITIONAL IMPORTANT)
-- -------------------------------------------------------------------------------
PRINT '=== Stored Procedures Exercise 4: Execute Stored Procedure ===';

-- Execute insert procedure to add a new employee
EXEC sp_InsertEmployee 'David', 'Miller', 3, 6500.00, '2025-02-01';

-- Retrieve all employees in IT department (DepartmentID = 3)
EXEC sp_GetEmployeesByDepartment @DepartmentID = 3;
GO

-- -------------------------------------------------------------------------------
-- Stored Procedures: Exercise 5: Return Data from a Stored Procedure (MANDATORY)
-- -------------------------------------------------------------------------------
PRINT '=== Stored Procedures Exercise 5: Return Data from a Stored Procedure ===';

IF OBJECT_ID('dbo.sp_GetEmployeeCountByDepartment', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetEmployeeCountByDepartment;
GO
CREATE PROCEDURE sp_GetEmployeeCountByDepartment
    @DepartmentID INT,
    @EmployeeCount INT OUTPUT
AS
BEGIN
    SELECT @EmployeeCount = COUNT(*)
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Demonstration of executing and retrieving output parameter value:
DECLARE @Count INT;
EXEC sp_GetEmployeeCountByDepartment @DepartmentID = 3, @EmployeeCount = @Count OUTPUT;
PRINT 'Total employees in IT Department (DepartmentID 3): ' + CAST(@Count AS VARCHAR(10));
GO

-- -------------------------------------------------------------------------------
-- Functions: Exercise 1: Create a Scalar Function (Recommended)
-- -------------------------------------------------------------------------------
IF OBJECT_ID('dbo.fn_CalculateAnnualSalary', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_CalculateAnnualSalary;
GO
CREATE FUNCTION fn_CalculateAnnualSalary
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 12;
END;
GO

-- -------------------------------------------------------------------------------
-- Functions: Exercise 7: Return Data from a Scalar Function (ADDITIONAL IMPORTANT)
-- -------------------------------------------------------------------------------
PRINT '=== Functions Exercise 7: Return Data from a Scalar Function ===';

-- Execute fn_CalculateAnnualSalary for employee with EmployeeID = 1
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary AS MonthlySalary,
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM Employees
WHERE EmployeeID = 1;
GO
