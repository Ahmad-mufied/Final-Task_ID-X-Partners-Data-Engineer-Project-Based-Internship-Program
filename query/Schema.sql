-- Create the database if it does not exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DWH')
    CREATE DATABASE DWH;

-- Use DWH database
USE DWH;

-- Drop table if exists
DROP TABLE IF EXISTS FactTransaction;
DROP TABLE IF EXISTS DimCustomer;
DROP TABLE IF EXISTS DimAccount;
DROP TABLE IF EXISTS DimBranch;


-- Create the DimCustomer table within the DimCustomer schema
CREATE TABLE DimCustomer(
    CustomerID INT NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(50),
    Address VARCHAR(MAX),
    CityName VARCHAR(50),
    StateName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    Email VARCHAR(50)
);

-- Create the DimAccount table within the DimAccount schema
CREATE TABLE DimAccount(
    AccountID INT NOT NULL PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES DimCustomer(CustomerID),
    AccountType VARCHAR(10),
    Balance INT,
    DateOpened DATETIME2,
    Status VARCHAR(10)
);

-- Create the DimBranch table within the DimBranch schema
CREATE TABLE DimBranch(
    BranchID INT NOT NULL PRIMARY KEY,
    BranchName VARCHAR(50),
    BranchLocation VARCHAR(50)
);

-- Create the FactTransaction table within the FactTransaction schema
CREATE TABLE FactTransaction(
    TransactionID INT NOT NULL PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES DimAccount(AccountID),
    TransactionDate DATETIME2,
    Amount INT,
    TransactionType VARCHAR(50),
    BranchID INT FOREIGN KEY REFERENCES DimBranch(BranchID)
);
