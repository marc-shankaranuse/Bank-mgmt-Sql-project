CREATE DATABASE BankApp; --creating a database/container

USE BankApp;  --using this database, so now we'll do all things inside/under this database


--==============================================================================================================
--===========================  Creating Tables & Inserting Records  ===================================================================================
--==============================================================================================================
-- create banking application project
-- we’ll build the following components step by step:
	--Database Design:---> Create tables for customers, accounts, transactions, loans, and monthly statements.
	--Stored Procedures:---> Implement error handling with TRY...CATCH during money transfers.
	--Dynamic Logic:---> Use a CASE statement to calculate loan interest rates dynamically.
	--Iteration:---> Use a WHILE loop to generate monthly statements for a given range of dates.

--==============================================================================================================
--==============================================================================================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(15),
    Address NVARCHAR(255)
);
--adding/inserting some values/records in this table
INSERT INTO Customers (FullName, Email, Phone, Address)
VALUES 
('John Doe', 'john.doe@example.com', '1234567890', '123 Elm Street'),
('Jane Smith', 'jane.smith@example.com', '9876543210', '456 Oak Avenue'),
('Robert Brown', 'robert.brown@example.com', '1112223333', '789 Pine Lane'),
('Emily Davis', 'emily.davis@example.com', '2223334444', '321 Maple Road'),
('Michael Wilson', 'michael.wilson@example.com', '3334445555', '654 Cedar Drive'),
('Sarah Johnson', 'sarah.johnson@example.com', '4445556666', '987 Birch Street'),
('William Lee', 'william.lee@example.com', '5556667777', '159 Ash Boulevard'),
('Jessica Walker', 'jessica.walker@example.com', '6667778888', '753 Elmwood Court'),
('Daniel Hall', 'daniel.hall@example.com', '7778889999', '951 Spruce Place'),
('Laura King', 'laura.king@example.com', '8889990000', '357 Willow Circle');

--==============================================================================================================
--==============================================================================================================

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID), --here FK but there PK
    Balance DECIMAL(18,2) DEFAULT 0.00,
    AccountType NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
--adding/inserting some values/records in this table
INSERT INTO Accounts (CustomerID, Balance, AccountType)
VALUES
(1, 5000.00, 'Savings'),
(2, 10000.00, 'Checking'),
(3, 7500.00, 'Savings'),
(4, 12000.00, 'Checking'),
(5, 9500.00, 'Savings'),
(6, 11000.00, 'Savings'),
(7, 8500.00, 'Checking'),
(8, 7000.00, 'Savings'),
(9, 6500.00, 'Checking'),
(10, 13000.00, 'Savings');

--==============================================================================================================
--==============================================================================================================

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID), --here FK but there PK
    TransactionType NVARCHAR(50),
    Amount DECIMAL(18,2),
    TransactionDate DATETIME DEFAULT GETDATE(),
    Remarks NVARCHAR(255)
);
--adding/inserting some values/records in this table
INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
VALUES
(1, 'Credit', 2000.00, 'Salary Deposit'),
(2, 'Debit', 500.00, 'Utility Bill'),
(3, 'Credit', 1500.00, 'Freelance Work'),
(4, 'Debit', 700.00, 'Grocery Shopping'),
(5, 'Credit', 1000.00, 'Gift from Friend'),
(6, 'Debit', 300.00, 'Fuel'),
(7, 'Credit', 2500.00, 'Bonus'),
(8, 'Debit', 400.00, 'Online Shopping'),
(9, 'Credit', 1800.00, 'Side Business'),
(10, 'Debit', 600.00, 'Restaurant Bill');

--==============================================================================================================
--==============================================================================================================

-- Create Transfers Table
CREATE TABLE Transfers (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    TransferAmount DECIMAL(10, 2) NOT NULL,
    TransferDate DATETIME NOT NULL DEFAULT GETDATE(),
    SourceAccountID INT NOT NULL,
    DestinationAccountID INT NOT NULL,
    FOREIGN KEY (SourceAccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (DestinationAccountID) REFERENCES Accounts(AccountID)
);

-- Insert sample transfers
INSERT INTO Transfers (TransferAmount, SourceAccountID, DestinationAccountID)
VALUES
(500.00, 1, 2),
(300.00, 2, 3),
(1200.00, 3, 4),
(700.00, 4, 5),
(950.00, 5, 6),
(800.00, 6, 7),
(450.00, 7, 8),
(1300.00, 8, 9),
(620.00, 9, 10),
(400.00, 10, 11),
(1000.00, 11, 1);
--==============================================================================================================
--==============================================================================================================

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID), --here FK but there PK
    PrincipalAmount DECIMAL(18,2),
    TenureMonths INT,
    CreditScore INT,
    InterestRate DECIMAL(5,2),
    LoanStartDate DATE DEFAULT GETDATE(),
    TotalPayableAmount DECIMAL(18,2)
);
--adding/inserting some values/records in this table
INSERT INTO Loans (CustomerID, PrincipalAmount, TenureMonths, CreditScore, InterestRate, TotalPayableAmount)
VALUES
(1, 50000.00, 12, 780, 8.50, 55426.00),
(2, 100000.00, 24, 720, 10.00, 112682.50),
(3, 75000.00, 18, 650, 12.50, 84972.50),
(4, 60000.00, 36, 800, 7.50, 74402.50),
(5, 85000.00, 24, 710, 10.00, 95876.50),
(6, 30000.00, 12, 780, 8.50, 33255.00),
(7, 40000.00, 24, 650, 12.50, 45364.75),
(8, 20000.00, 18, 700, 10.00, 22677.25),
(9, 95000.00, 36, 750, 9.50, 117784.75),
(10, 120000.00, 60, 810, 7.00, 146291.20);

--==============================================================================================================
--==============================================================================================================

CREATE TABLE MonthlyStatements (
    StatementID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID), --here FK but there PK
    StatementMonth INT,
    StatementYear INT,
    TotalDeposits DECIMAL(18,2),
    TotalWithdrawals DECIMAL(18,2),
    ClosingBalance DECIMAL(18,2)
);

--adding/inserting some values/records in this table
INSERT INTO MonthlyStatements (AccountID, StatementMonth, StatementYear, TotalDeposits, TotalWithdrawals, ClosingBalance)
VALUES
(1, 1, 2024, 2000.00, 500.00, 6500.00),
(2, 1, 2024, 3000.00, 1000.00, 9000.00),
(3, 1, 2024, 1500.00, 700.00, 8300.00),
(4, 1, 2024, 2500.00, 600.00, 14100.00),
(5, 1, 2024, 1000.00, 300.00, 10200.00),
(6, 1, 2024, 2000.00, 400.00, 12600.00),
(7, 1, 2024, 1500.00, 600.00, 9400.00),
(8, 1, 2024, 2000.00, 500.00, 8500.00),
(9, 1, 2024, 1800.00, 700.00, 7600.00),
(10, 1, 2024, 2200.00, 800.00, 14400.00);

--==============================================================================================================
--=========================== Executing Each Tables  ===================================================================================
--==============================================================================================================
-- Checking all Customers
SELECT * FROM Customers;

-- Checking all Accounts
SELECT * FROM Accounts;

-- Checking all Transactions
SELECT * FROM Transactions;

-- Checking all Loans
SELECT * FROM Loans;

-- Checking all Monthly Statements
SELECT * FROM MonthlyStatements;

-- Checking all Monthly Statements
SELECT * FROM Transfers;

--==============================================================================================================
--===========================  3 MAIN IMP Procedures  ===================================================================================
--==============================================================================================================
-- Procedures
---- 1]
--Money Transfer with TRY...CATCH

GO
CREATE PROCEDURE TransferMoney
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Deduct from sender
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        -- Check for negative balance
        IF EXISTS (SELECT 1 FROM Accounts WHERE AccountID = @FromAccountID AND Balance < 0)
            THROW 50001, 'Insufficient Balance', 1;

        -- Add to receiver
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        -- Record transactions
        INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
        VALUES
            (@FromAccountID, 'Debit', @Amount, 'Transfer to Account ' + CAST(@ToAccountID AS NVARCHAR)),
            (@ToAccountID, 'Credit', @Amount, 'Received from Account ' + CAST(@FromAccountID AS NVARCHAR));

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

--==============================================================================================================
--- 2]
--Loan Interest Calculation
GO
CREATE PROCEDURE CalculateLoanInterest
    @CustomerID INT,
    @PrincipalAmount DECIMAL(18,2),
    @TenureMonths INT,
    @CreditScore INT
AS
BEGIN
    DECLARE @InterestRate DECIMAL(5,2);

    -- Determine interest rate based on credit score and tenure
    SET @InterestRate = CASE 
        WHEN @CreditScore > 750 THEN 8.5
        WHEN @CreditScore BETWEEN 650 AND 750 THEN 10.0
        ELSE 12.5
    END;

    DECLARE @TotalPayableAmount DECIMAL(18,2);
    SET @TotalPayableAmount = @PrincipalAmount * POWER(1 + (@InterestRate / 100 / 12), @TenureMonths);

    -- Insert loan record
    INSERT INTO Loans (CustomerID, PrincipalAmount, TenureMonths, CreditScore, InterestRate, TotalPayableAmount)
    VALUES (@CustomerID, @PrincipalAmount, @TenureMonths, @CreditScore, @InterestRate, @TotalPayableAmount);
END;

--==============================================================================================================
--- 3]

--Generate Monthly Statements
GO
CREATE PROCEDURE GenerateStatements
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    DECLARE @CurrentDate DATE = @StartDate;

    WHILE @CurrentDate <= @EndDate
    BEGIN
        INSERT INTO MonthlyStatements (AccountID, StatementMonth, StatementYear, TotalDeposits, TotalWithdrawals, ClosingBalance)
        SELECT 
            A.AccountID,
            MONTH(@CurrentDate),
            YEAR(@CurrentDate),
            SUM(CASE WHEN T.TransactionType = 'Credit' THEN T.Amount ELSE 0 END),
            SUM(CASE WHEN T.TransactionType = 'Debit' THEN T.Amount ELSE 0 END),
            A.Balance
        FROM Accounts A
        LEFT JOIN Transactions T ON A.AccountID = T.AccountID AND MONTH(T.TransactionDate) = MONTH(@CurrentDate) AND YEAR(T.TransactionDate) = YEAR(@CurrentDate)
        GROUP BY A.AccountID, A.Balance;

        SET @CurrentDate = DATEADD(MONTH, 1, @CurrentDate);
    END;
END;

--==============================================================================================================
--===========================  Adding some data/records  ===================================================================================
--==============================================================================================================

-- Insert sample customers
INSERT INTO Customers (FullName, Email, Phone, Address)
VALUES ('Akash Aiwale', 'ak@example.com', '09874567890', '4880 Telsang Street');

-- Insert sample accounts
INSERT INTO Accounts (CustomerID, Balance, AccountType)
VALUES (13, 20000, 'Savings');

-- Insert sample transactions
INSERT INTO Transactions (AccountID, TransactionType, Amount, Remarks)
VALUES (12, 'Credit', 5000.00, 'Laptop baught');

-- Insert sample Loans
INSERT INTO Loans (CustomerID, PrincipalAmount, TenureMonths, CreditScore, InterestRate, TotalPayableAmount)
VALUES (12, 85000.00, 18, 999, 11.60, 97700.00);

--adding/inserting some values/records in this table
INSERT INTO MonthlyStatements (AccountID, StatementMonth, StatementYear, TotalDeposits, TotalWithdrawals, ClosingBalance)
VALUES (12, 4, 2025, 4900.00, 845.00, 10500.00);

--adding/inserting some values/records in this table
INSERT INTO Transfers (TransferAmount, SourceAccountID, DestinationAccountID)
VALUES (799.00, 12, 5);

-- executing tables data 
SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;
SELECT * FROM Loans;
SELECT * FROM MonthlyStatements;
SELECT * FROM Transfers;

--==============================================================================================================
--===========================  Executing 3 main Procedures  ===================================================================================
--==============================================================================================================
EXEC TransferMoney @FromAccountID = 6, @ToAccountID = 1, @Amount = 1000;

EXEC CalculateLoanInterest @CustomerID = 8, @PrincipalAmount = 50000, @TenureMonths = 24, @CreditScore = 720;

EXEC GenerateStatements @StartDate = '2025-01-01', @EndDate = '2025-12-31';

--==============================================================================================================
--================================  Different STORED PROCEDURES  ===========================================================================
--==============================================================================================================
-- 1]
Go
-- Stored Procedure: Retrieve Customer Details by ID
CREATE PROCEDURE GetCustomerDetails
    @CustomerID INT
AS
BEGIN
    SELECT *
    FROM Customers
    WHERE CustomerID = @CustomerID;
END;

--==============================================================================================================
-- 2]
GO
-- Stored Procedure: Transfer Money Between Accounts
CREATE PROCEDURE TransferPaisa
    @SourceAccountID INT,
    @DestinationAccountID INT,
    @Amount DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Deduct from source account
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @SourceAccountID;

        -- Add to destination account
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @DestinationAccountID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

--==============================================================================================================

-- 3]
GO
-- Stored Procedure: Calculate Total Balance for a Customer
CREATE PROCEDURE GetTotalBalance
    @CustomerID INT
AS
BEGIN
    SELECT SUM(Balance) AS TotalBalance
    FROM Accounts
    WHERE CustomerID = @CustomerID;
END;

--==============================================================================================================
-- 4]
GO
-- Stored Procedure: Fetch Accounts with High Balances
CREATE PROCEDURE GetHighBalanceAccounts
    @MinimumBalance DECIMAL(10, 2)
AS
BEGIN
    SELECT a.AccountID, a.Balance, c.FullName
    FROM Accounts a
	JOIN Customers c ON a.CustomerID=c.CustomerID
    WHERE Balance >= @MinimumBalance;
END;

--=============================================
DROP PROCEDURE dbo.GetHighBalanceAccounts;

SELECT * FROM sys.procedures;

--==============================================================================================================
-- 5]
GO
-- Stored Procedure: Add a New Customer
CREATE PROCEDURE AddCustomer
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(15),
    @Address NVARCHAR(255)
AS
BEGIN
    INSERT INTO Customers (FullName, Email, Phone, Address)
    VALUES (@FullName, @Email, @Phone, @Address);
END;

--==============================================================================================================
-- 6]
GO
-- Stored Procedure: Retrieve Transfer History for a Customer
CREATE PROCEDURE GetTransferHistory
    @CustomerID INT
AS
BEGIN
    SELECT T.TransferID, T.TransferAmount, T.TransferDate, T.SourceAccountID, T.DestinationAccountID
    FROM Transfers T
    INNER JOIN Accounts A ON T.SourceAccountID = A.AccountID
    WHERE A.CustomerID = @CustomerID;
END;
-------------------------------------------------------------
---------------------------------------------------------
GO
CREATE PROCEDURE GetNameTransferHistory
    @CustomerID INT,
	@FullName NVARCHAR(100) 
AS
BEGIN
    SELECT T.TransferID, c.FullName, T.TransferAmount, T.TransferDate, T.SourceAccountID, T.DestinationAccountID
    FROM Transfers T
    INNER JOIN Accounts A ON T.SourceAccountID = A.AccountID
	INNER JOIN Customers c ON A.CustomerID = c.CustomerID
    WHERE A.CustomerID = @CustomerID;
END;
--================================================================================
GO
CREATE PROCEDURE GetOnlyNameTransferHistory
	@FullName NVARCHAR(100) 
AS
BEGIN
    SELECT T.TransferID, c.FullName, T.TransferAmount, T.TransferDate, T.SourceAccountID, T.DestinationAccountID
    FROM Transfers T
    INNER JOIN Accounts A ON T.SourceAccountID = A.AccountID
	INNER JOIN Customers c ON A.CustomerID = c.CustomerID
    WHERE c.FullName = @FullName;
END;

--==============================================================================================================
-- 7]
GO
-- Stored Procedure: Update Account Balance
CREATE PROCEDURE UpdateAccountBalance
    @AccountID INT,
    @NewBalance DECIMAL(10, 2)
AS
BEGIN
    UPDATE Accounts
    SET Balance = @NewBalance
    WHERE AccountID = @AccountID;
END;

--==============================================================================================================
-- 8]
GO
-- Stored Procedure: Delete Customer and Related Accounts
CREATE PROCEDURE DeleteCustomer
    @CustomerID INT
AS
BEGIN
    DELETE FROM Accounts WHERE CustomerID = @CustomerID;
    DELETE FROM Customers WHERE CustomerID = @CustomerID;
END;

--==============================================================================================================
-- 9]
GO
-- Stored Procedure: Fetch Customers Without Accounts
CREATE PROCEDURE GetCustomersWithoutAccounts
AS
BEGIN
    SELECT FullName
    FROM Customers
    WHERE CustomerID NOT IN (SELECT CustomerID FROM Accounts);
END;


--==============================================================================================================
--===========================  Executing procedures all  ===================================================================================
--==============================================================================================================
-- Execute all procedures for testing
-- 1. Get customer details by ID
EXEC GetCustomerDetails @CustomerID = 13;
--==============================================================================================================

-- 2. Transfer money between accounts
EXEC TransferPaisa @SourceAccountID = 7, @DestinationAccountID = 12, @Amount = 1400.00;
select * from Accounts;
select * from Transfers;
--==============================================================================================================

-- 3. Get total balance for a customer
EXEC GetTotalBalance @CustomerID = 13;
--==============================================================================================================

-- 4. Fetch accounts with high balances
EXEC GetHighBalanceAccounts @MinimumBalance = 50000.00;
--==============================================================================================================

-- 5. Add a new customer
EXEC AddCustomer @FullName = 'Anuse', @Email = 'shan@example.com', @Phone = '8779315758', @Address = '98 Anuse Ways';
Select * from Customers;
--==============================================================================================================

-- 6. Retrieve transfer history for a customer using id only
EXEC GetTransferHistory @CustomerID = 11;

-- Retrieve transfer history for a customer using both name and id
EXEC GetNameTransferHistory @CustomerID = 11, @FullName ='Marc Anuse';

-- Retrieve transfer history for a customer using name only
EXEC GetOnlyNameTransferHistory @FullName ='Akash Aiwale';

--==============================================================================================================

-- 7. Update account balance
EXEC UpdateAccountBalance @AccountID = 13, @NewBalance = 53000.00;
Select * from Accounts;
Select * from Customers;

--==============================================================================================================

-- 8. Delete a customer and related accounts
EXEC DeleteCustomer @CustomerID = 14;

--==============================================================================================================

-- 9. Fetch customers without accounts
EXEC GetCustomersWithoutAccounts;


--------------------------------------------------------------------------------------------------------------
--This project demonstrates the use of error handling, dynamic logic, stored procedures
--and iteration in a practical banking application. 
--You can now include this in your portfolio website.
--------------------------------------------------------------------------------------------------------------









