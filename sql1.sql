CREATE DATABASE IF NOT EXISTS marketing_db;
USE marketing_db;

-- Remove old tables
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Campaigns;

SET FOREIGN_KEY_CHECKS = 1;


-- Create Campaigns table
CREATE TABLE Campaigns (
    campaign_id INT PRIMARY KEY,
    channel VARCHAR(50),
    spend INT,
    start_date DATE,
    end_date DATE
);


-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    acquisition_channel VARCHAR(50),
    acquisition_cost INT
);


-- Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    revenue INT,
    date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- Load Campaigns CSV
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/campaigns.csv'
INTO TABLE Campaigns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(campaign_id, channel, spend, start_date, end_date);


-- Load Customers CSV
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, acquisition_channel, acquisition_cost);


-- Load Transactions CSV
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(transaction_id, customer_id, revenue, date);


-- Check the data
SELECT COUNT(*) AS Campaign_Count FROM Campaigns;
SELECT COUNT(*) AS Customer_Count FROM Customers;
SELECT COUNT(*) AS Transaction_Count FROM Transactions;
SELECT * FROM Campaigns;

SELECT * FROM Customers LIMIT 20;

SELECT * FROM Transactions LIMIT 20;