drag and drop files or browse to select files from our local machine.
Bank Management System - SQL Database Project
The Bank Management System is a mini-project designed to simulate real-world banking operations and manage banking data effectively. This project leverages SQL as the primary database technology and incorporates advanced database concepts such as triggers, DDL, DML, DCL, stored procedures, and functions to ensure efficient and secure handling of banking transactions.

Project Features:
Customer Management:
Store customer details such as account number, name, address, contact details, and account type.
Maintain a record of active and inactive accounts.

Account Transactions:
Record and manage deposits, withdrawals, and fund transfers between accounts.
Maintain transaction history with timestamps for audit and analysis.

Loan Management:
Manage loan details, including loan type, amount, interest rate, and repayment status.

Authentication & Security:
Secure database access using DCL commands for role-based user privileges.
Ensure only authorized personnel can perform sensitive operations.

SQL Features Used:
Data Definition Language (DDL):
Used for creating and managing database structures like tables, indexes, and views.
Example:
CREATE TABLE Customers (...);
ALTER TABLE Transactions ADD COLUMN transaction_type VARCHAR(20);

Data Manipulation Language (DML):
Insert, update, delete, and retrieve banking records.
Example:
INSERT INTO Accounts (account_id, customer_id, balance) VALUES (...);
UPDATE Accounts SET balance = balance - 500 WHERE account_id = 101;

Data Control Language (DCL):
Manage database security using commands like GRANT and REVOKE.
Example:
GRANT SELECT, INSERT ON Accounts TO bank_employee;

Triggers:
Used to automate specific operations based on database events.
Example:
Automatically update account balance after a transaction:
CREATE TRIGGER UpdateBalance
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
  UPDATE Accounts
  SET balance = balance + NEW.amount
  WHERE account_id = NEW.account_id;
END;

Stored Procedures:
Encapsulate reusable SQL logic for common operations.
Example:
A stored procedure to handle fund transfers:
CREATE PROCEDURE TransferFunds(
  IN sender_id INT, 
  IN receiver_id INT, 
  IN transfer_amount DECIMAL(10, 2)
)
BEGIN
  UPDATE Accounts SET balance = balance - transfer_amount WHERE account_id = sender_id;
  UPDATE Accounts SET balance = balance + transfer_amount WHERE account_id = receiver_id;
  INSERT INTO Transactions (account_id, transaction_type, amount) VALUES 
    (sender_id, 'debit', transfer_amount),
    (receiver_id, 'credit', transfer_amount);
END;

Functions:
Implemented for computations or retrieving specific data.
Example:
Calculate interest on an account:
CREATE FUNCTION CalculateInterest(account_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
  DECLARE interest_rate DECIMAL(5, 2);
  DECLARE balance DECIMAL(10, 2);
  SELECT balance INTO balance FROM Accounts WHERE account_id = account_id;
  SELECT interest_rate INTO interest_rate FROM AccountTypes WHERE type_id = (SELECT type_id FROM Accounts WHERE account_id = account_id);
  RETURN balance * (interest_rate / 100);
END;

Benefits of the Project:
Efficiency: Automated triggers and stored procedures reduce manual intervention.
Security: Role-based access control ensures that sensitive data remains protected.
Reusability: Stored procedures and functions simplify complex operations and improve code maintainability.
Real-World Simulation: The use of SQL concepts models real-life banking scenarios effectively.
This project is a perfect example of combining SQL features to create a robust, secure, and efficient database system for managing banking operations.
main
