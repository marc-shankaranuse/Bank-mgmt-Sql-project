

--=================================================================================

-- Step 1: Create Database
CREATE DATABASE BankDataMgmtSys;
GO
USE BankDataMgmtSys;
GO
--=================================================================================

-- Step 2: Create Tables
-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber NVARCHAR(15) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

SELECT * FROM Users;

-- Accounts Table
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    AccountNumber NVARCHAR(20) UNIQUE NOT NULL,
    AccountType NVARCHAR(20) CHECK (AccountType IN ('Savings', 'Current')),
    Balance DECIMAL(18, 2) CHECK (Balance >= 0),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
SELECT * FROM Accounts;

-- Transactions Table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TransactionType NVARCHAR(20) CHECK (TransactionType IN ('Deposit', 'Withdrawal')),
    Amount DECIMAL(18, 2) CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);
SELECT * FROM Transactions;

-- Loans Table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    LoanType NVARCHAR(20) CHECK (LoanType IN ('Home', 'Personal', 'Auto')),
    LoanAmount DECIMAL(18, 2) CHECK (LoanAmount > 0),
    InterestRate DECIMAL(5, 2) CHECK (InterestRate > 0),
    LoanStartDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

SELECT * FROM Loans;

---================================================================================================

-- Archived Transactions Table

-- Additional Features Section
-- Feature 1: Data Archival
-- Create Archived Transactions Table
CREATE TABLE ArchivedTransactions (
    ArchivedTransactionID INT PRIMARY KEY IDENTITY(1,1),
    OriginalTransactionID INT NOT NULL,
    AccountID INT NOT NULL,
    TransactionType NVARCHAR(20),
    Amount DECIMAL(18, 2),
    TransactionDate DATETIME,
    ArchivedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OriginalTransactionID) REFERENCES Transactions(TransactionID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
SELECT * FROM ArchivedTransactions;

--============================================================================================================

-- Step 3: Insert Records
-- Insert into Users
INSERT INTO Users (FirstName, LastName, Email, PhoneNumber) VALUES
('shankar', 'Anuse', 'shankar.anu@example.com', '1234567890'),
('Marc', 'Anu', 'marc@example.com', '0987654321'),
('Akash', 'Aiwale', 'akash@example.com', '1122334455'),
('Shiva', 'Modi', 'shiv.modi@example.com', '2233445566'),
('Vivek', 'Chimankar', 'vivek@example.com', '3344556677'),
('Ajinkya', 'Dhomane', 'aj.d@example.com', '4455667788'),
('Eve', 'Anuse', 'eve.a@example.com', '5566778899'),
('Shantanu', 'Nitnaware', 'shantanu@example.com', '6677889900'),
('Twinkle', 'Patil', 'twinkle.p@example.com', '7788990011'),
('Muskan', 'Pichode', 'muskan@example.com', '8899001122');

-- Insert into Accounts
INSERT INTO Accounts (UserID, AccountNumber, AccountType, Balance) VALUES
(1, 'AC1001', 'Savings', 1000.00),
(2, 'AC1002', 'Savings', 1500.00),
(3, 'AC1003', 'Current', 2000.00),
(4, 'AC1004', 'Savings', 500.00),
(5, 'AC1005', 'Current', 3000.00),
(6, 'AC1006', 'Savings', 700.00),
(7, 'AC1007', 'Savings', 1200.00),
(8, 'AC1008', 'Current', 4500.00),
(9, 'AC1009', 'Savings', 800.00),
(10, 'AC1010', 'Savings', 900.00);

-- Insert into Transactions
INSERT INTO Transactions (AccountID, TransactionType, Amount) VALUES
(1, 'Deposit', 500.00),
(1, 'Withdrawal', 200.00),
(2, 'Deposit', 1000.00),
(2, 'Withdrawal', 300.00),
(3, 'Deposit', 1500.00),
(4, 'Withdrawal', 100.00),
(5, 'Deposit', 2000.00),
(6, 'Withdrawal', 50.00),
(7, 'Deposit', 700.00),
(8, 'Withdrawal', 600.00);


-- Insert into Loans
INSERT INTO Loans (UserID, LoanType, LoanAmount, InterestRate) VALUES
(1, 'Home', 250000.00, 7.5),
(2, 'Personal', 50000.00, 10.0),
(3, 'Auto', 300000.00, 8.0),
(4, 'Home', 150000.00, 7.0),
(5, 'Personal', 70000.00, 9.5),
(6, 'Auto', 250000.00, 8.5),
(7, 'Home', 400000.00, 7.8),
(8, 'Personal', 60000.00, 10.2),
(9, 'Auto', 320000.00, 8.3),
(10, 'Home', 220000.00, 7.1);

--===================================================================================

-- Step 4: Create Constraints
-- Add Indexes
CREATE INDEX IDX_User_Email ON Users (Email);
SELECT * FROM Users
WHERE Email = 'marc@example.com';

--======================================================================================================

--Use the SET STATISTICS IO command or execution plans.
--Check for "Index Seek" : Specific (e.g., = or BETWEEN)
-- or		"Index Scan" : Non-specific (e.g., LIKE '%X')  in the execution plan.
SET STATISTICS IO ON;
SELECT * FROM Users 
WHERE Email = 'marc@example.com';
--======================================================================================================
-- Step 4: Create Constraints
-- Add Indexes
CREATE INDEX IDX_User_firstName ON Users (FirstName);

---An Index Seek occurs when the query engine uses the index to locate specific rows directly.
-- "Index Seek" : Specific (e.g., = or BETWEEN)
SELECT * FROM Users
WHERE FirstName = 'Shankar';
--The query specifies an exact match for the firstname column.
--The database can efficiently locate rows with FirstName = 'Shankar' using the index (IDX_User_firstName).
--======================================================================================================

---An Index Scan occurs when the query engine scans the entire index to find matching rows. 
-- "Index Scan" : Non-specific (e.g., LIKE '%X')
SELECT * FROM Users 
WHERE FirstName LIKE '%e';
--The condition (LIKE '%e') requires the database to look at every row because the wildcard % at the beginning prevents direct lookup.
--The engine scans the entire index (IDX_User_firstName) to check which rows match the condition.
--======================================================================================================

--======================================================================================================
--add index
CREATE INDEX IDX_Account_AccountNumber ON Accounts (AccountNumber);
SELECT * FROM Accounts WHERE AccountNumber = 'AC1006';

-- "Index Seek" : Specific (e.g., = or BETWEEN)
SELECT * FROM Transactions t join Accounts a On t.AccountID=a.AccountID
WHERE AccountNumber = 'AC1006';

--======================================================================================================
CREATE INDEX IDX_Transaction_AccountID ON Transactions (AccountID);

-- "Index Seek" : Specific (e.g., = or BETWEEN)
SELECT * FROM Transactions WHERE AccountID =3;

--======================================================================================================

-- Step 5: Create Views
-- View for User Account Details
GO
CREATE VIEW vw_UserAccounts AS
SELECT u.UserID, u.FirstName, u.LastName, a.AccountNumber, a.AccountType, a.Balance
FROM Users u
JOIN Accounts a ON u.UserID = a.UserID;
GO

SELECT * FROM vw_UserAccounts; -- accessing/fetching details using indexes of table	 Users and accounts table
--=====================================================================================================================

-- Procedure to Archive Old Transactions
GO
CREATE PROCEDURE sp_ArchiveOldTransactions
    @DaysOld INT
AS
BEGIN
	  INSERT INTO ArchivedTransactions (OriginalTransactionID, AccountID, TransactionType, Amount, TransactionDate)
      SELECT TransactionID, AccountID, TransactionType, Amount, TransactionDate
	  FROM Transactions
    WHERE DATEDIFF(DAY, TransactionDate, GETDATE()) > @DaysOld;

    DELETE FROM Transactions
    WHERE TransactionID IN (
        SELECT OriginalTransactionID FROM ArchivedTransactions
    );
END;

-- Execute Archival for Transactions Older Than 180 Days
EXEC sp_ArchiveOldTransactions @DaysOld = 180;
SELECT * FROM ArchivedTransactions;
--=====================================================================================================================

-- Feature 2: Interest Accrual
-- Add InterestRate Column to Accounts Table
ALTER TABLE Accounts ADD InterestRate DECIMAL(5, 2) DEFAULT 0.5;
SELECT * FROM Accounts;

--=====================================================================================================================

-- Trigger to Automate Interest Accrual
GO
CREATE TRIGGER trgr_InterestAccrual
ON Accounts 
AFTER INSERT, UPDATE
AS
	BEGIN
	UPDATE Accounts SET Balance = Balance + (Balance * 0.03) -- Assume 3% annual interest accrual
    WHERE AccountType = 'Savings';
		
		--UPDATE Accounts 
		--SET Balance = Balance + (Balance * InterestRate / 100),
  --      LastUpdated = GETDATE()
		--WHERE AccountID IN (SELECT AccountID FROM Loans);
END;



EXEC trgr_InterestAccrual @DaysOld = 180;

SELECT * FROM ArchivedTransactions;

--=====================================================================================================================

-- Feature 3: Fraud Detection

-- Add Table for Fraud Alerts
CREATE TABLE FraudAlerts (
    AlertID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TransactionID INT NOT NULL,
    AlertMessage NVARCHAR(255),
    AlertDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);
select * from FraudAlerts;
--=====================================================================================================================


CREATE TABLE transactionData (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10, 2)
);

insert into transactiondata (transaction_id,user_id,amount)
Values(1,2,50000),(2,1,50000),(3,2,50000);

select * from transactionData;


CREATE TABLE transaction_logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_id INT,
    user_id INT,
    amount DECIMAL(10, 2),
    action_time DATETIME
);



select * from transactionData;
select * from transaction_logs;

Go
CREATE TRIGGER after_transaction_insert
ON transactionData
AFTER INSERT
AS
BEGIN
    INSERT INTO transaction_logs (transaction_id, user_id, amount, action_time)
    SELECT transaction_id, user_id, amount, GETDATE()
    FROM inserted;
END;

-- insert Data into transactions Table: Test the trigger by inserting data into the transactions table.
INSERT INTO transactionData (transaction_id, user_id, amount)
VALUES (102, 1, 8700.00);
INSERT INTO transactionData (transaction_id, user_id, amount)
VALUES (103, 2, 700.00);
INSERT INTO transactionData (transaction_id, user_id, amount)
VALUES (104, 3, 6550.00);
INSERT INTO transactionData (transaction_id, user_id, amount)
VALUES (105, 4, 8900.00);


SELECT * FROM transaction_logs;

SELECT * FROM sys.triggers;
--=======================================================================================

--- a Banking System, you want to log every transaction made in the transactions table into a transaction_logs table for auditing purposes.
GO
CREATE TRIGGER after_transactionsAccount_inserted
ON transactions
AFTER INSERT
AS
BEGIN
	INSERT INTO Transactions(TransactionID, AccountID, TransactionType, Amount, TransactionDate)
	SELECT 
		t.TransactionID, 
		a.AccountID, 
		'DefaultType', 
		t.Amount, 
		GETDATE()
	FROM  Accounts a 
	join transactions t on a.AccountID =t.AccountID;
    --INSERT INTO Transactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate)
    --SELECT 
    --    i.TransactionID, 
    --    i.AccountID, 
    --    'DefaultType',  -- Replace with appropriate value or column if needed
    --    i.Amount, 
    --    GETDATE()       -- Use GETDATE() to get the current date and time in SQL Server
    --FROM INSERTED i;
END;

select * from Transactions;
select * from Accounts;


--===================================================================================================
GO;
-- Trigger to Detect Unusual Transactions
CREATE TRIGGER trg_FraudDetection
ON Transactions
AFTER INSERT
AS
BEGIN
INSERT INTO FraudAlerts (AccountID, TransactionID, AlertMessage)
    SELECT t.AccountID, t.TransactionID, 'Unusual Transaction Amount Detected'
    FROM Transactions t
    JOIN inserted i ON t.TransactionID = i.TransactionID
    WHERE i.Amount > 10000; -- Threshold for unusual transaction
END;

--OR
GO
CREATE TRIGGER trg_FraudDetection
ON Transactions
AFTER INSERT
AS
BEGIN
	DECLARE @Amount DECIMAL(18, 2);
    SELECT @Amount = Amount FROM INSERTED;
    IF @Amount > 10000 -- Set a threshold for unusual transaction amounts
    BEGIN
        PRINT 'Alert: Unusual Transaction Detected';
    END;
END;


--=====================================================================================================================

-- Step 8: Create Procedures
-- Procedure to Get User Account Balance
GO
CREATE PROCEDURE sp_GetUserBalance
    @UserID INT
AS
BEGIN
    SELECT Balance FROM Accounts WHERE UserID = @UserID;
END;

 EXEC sp_GetUserBalance @UserId = 6 ;
 select * from Users;

--=====================================================================================================================
GO
-- Procedure to Get Archived Transactions
CREATE PROCEDURE sp_GetArchivedTransactions
AS
BEGIN
    SELECT * FROM ArchivedTransactions;
END;
--=====================================================================================================================

-- Step 9: Add DCL and TCL Commands
-- Grant and Revoke Permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO dbo;
REVOKE DELETE ON Users FROM dbo;

select * from users;
-- Commit and Rollback Example
BEGIN TRANSACTION;
UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
select * from Accounts;

-- Simulate Error
ROLLBACK TRANSACTION;

-- Step 10: Add TCL Commands
SAVE TRANSACTION SavePoint1;
UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 1;
ROLLBACK TRANSACTION SavePoint1;

-- Step 11: Add Sequence
CREATE SEQUENCE sq_AccountNumber
START WITH 10000
INCREMENT BY 1;

SELECT NEXT VALUE FOR sq_AccountNumber;
SELECT NEXT VALUE FOR seq_AccountNumber;

-- Step 12: Add Synonyms
CREATE SYNONYM syn_Users FOR BankingSystem.dbo.Users;

-- Add More Queries and Hard Questions Below as Needed
-- Example Queries for Fraud Detection
-- Insert a High-Value Transaction to Test Trigger
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (2, 'Withdraw', 55000);

Select * from Transactions

-- Query Fraud Alerts
SELECT * FROM FraudAlerts;

--================================================================================================
-- 1. Expanded Triggers
-- Trigger for Loan Approval

GO
CREATE TRIGGER trg_LoanApproval
ON Loans
AFTER INSERT
AS
BEGIN
    DECLARE @LoanAmount DECIMAL(18, 2);
    DECLARE @InterestRate DECIMAL(5, 2);
    DECLARE @UserID INT;

    SELECT @LoanAmount = LoanAmount, @InterestRate = InterestRate, @UserID = UserID FROM INSERTED;

    PRINT 'Loan Approved for UserID ' + CAST(@UserID AS NVARCHAR) + 
          ' with Loan Amount: ' + CAST(@LoanAmount AS NVARCHAR) + 
          ' and Interest Rate: ' + CAST(@InterestRate AS NVARCHAR);
END;

--================================================================================================
--2. Enhanced Procedures
--Procedure for Monthly Interest Calculation
GO
CREATE PROCEDURE sp_CalculateInterest
    @LoanID INT,
    @Months INT
AS
BEGIN
    DECLARE @LoanAmount DECIMAL(18, 2);
    DECLARE @InterestRate DECIMAL(5, 2);
    DECLARE @MonthlyInterest DECIMAL(18, 2);

    SELECT @LoanAmount = LoanAmount, @InterestRate = InterestRate
    FROM Loans
    WHERE LoanID = @LoanID;

    SET @MonthlyInterest = (@LoanAmount * @InterestRate / 100) / 12;
    
    PRINT 'Monthly Interest: ' + CAST(@MonthlyInterest AS NVARCHAR);
END;

--================================================================================================
--Procedure for Detailed User Report
GO
CREATE PROCEDURE sp_GetUserReport
    @UserID INT
AS
BEGIN
    SELECT u.UserID, u.FirstName, u.LastName, a.AccountNumber, a.Balance, l.LoanAmount, l.LoanType
    FROM Users u
    LEFT JOIN Accounts a ON u.UserID = a.UserID
    LEFT JOIN Loans l ON u.UserID = l.UserID
    WHERE u.UserID = @UserID;
END;

--================================================================================================

--3. Complex Views
--View for Comprehensive Account and Loan Summary
GO;
CREATE VIEW vw_AccountLoanSummary AS
SELECT 
    u.FirstName, 
    u.LastName, 
    a.AccountNumber, 
    a.Balance, 
    l.LoanType, 
    l.LoanAmount
FROM Users u
JOIN Accounts a ON u.UserID = a.UserID
LEFT JOIN Loans l ON u.UserID = l.UserID;
GO
--================================================================================================

--4. Advanced Indexes
--Clustered Index on Accounts
CREATE CLUSTERED INDEX CL_Account_Balance
ON Accounts (Balance);


--Unique Index on Transactions
CREATE UNIQUE INDEX UX_Transaction_AccountType
ON Transactions (AccountID, TransactionType);



--================================================================================================
							--5. Hard Questions and Answers
--================================================================================================
--Que: How do you implement a trigger to log transactions in a log table? 
--Ans: Use AFTER INSERT triggers to capture new records from the INSERTED table and insert them into the log table.



--================================================================================================
--1. Write a query to calculate total deposits per account.

SELECT AccountID, SUM(Amount) AS TotalDeposits
FROM Transactions
WHERE TransactionType = 'Deposit'
GROUP BY AccountID;

select * FROM Transactions;
--================================================================================================
--2. How can you create a synonym for a table in another database?
CREATE SYNONYM syn_Transactions FOR AnotherDB.dbo.Transactions;

--================================================================================================
-- 3. Explain how to use a sequence to generate unique account numbers.
CREATE SEQUENCE seq_AccountNumber START WITH 20000 INCREMENT BY 1;
SELECT NEXT VALUE FOR seq_AccountNumber;

--================================================================================================
--4. Write a query to fetch all accounts where the balance is below average.
SELECT * FROM Accounts 
WHERE Balance < (SELECT AVG(Balance) FROM Accounts);
--================================================================================================
--5. Write a query to fetch all accounts where the balance is below average. 
SELECT * FROM Accounts 
WHERE Balance < (SELECT AVG(Balance) FROM Accounts);
--================================================================================================
--6. How to grant and revoke permissions on a specific table? Answer:
GRANT SELECT ON Accounts TO dbo;
REVOKE SELECT ON Accounts FROM dbo;

SELECT USER_name();
SELECT SYSTEM_USER AS CurrentLogin,
       USER_NAME() AS CurrentDatabaseUser,
       SUSER_SNAME() AS ServerLogin,
       SESSION_USER AS SessionUser;
--================================================================================================
--7. How to rollback to a specific savepoint in a transaction? 
BEGIN TRANSACTION;
SAVE TRANSACTION SavePoint1;
-- Perform updates
ROLLBACK TRANSACTION SavePoint1;

--================================================================================================
-- 8. How to find users with no transactions? 
SELECT u.* FROM Users u
WHERE NOT EXISTS (
					SELECT 1 FROM Accounts a
					JOIN Transactions t ON a.AccountID = t.AccountID
					WHERE u.UserID = a.UserID
);

--================================================================================================
--9. How to create a cascading delete between Users and Accounts? 
---Ans: Use ON DELETE CASCADE in the foreign key definition.

--================================================================================================
--10 How to get the highest loan amount per user?
SELECT UserID, MAX(LoanAmount) AS MaxLoan
FROM Loans
GROUP BY UserID;
--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


--================================================================================================


















