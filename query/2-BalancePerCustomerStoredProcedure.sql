
-- Drop the DailyTransaction stored procedure if it exists
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'BalancePerCustomer')
    DROP PROCEDURE BalancePerCustomer;

-- Create the BalancePerCustomer stored procedure
CREATE PROCEDURE BalancePerCustomer
(
@name VARCHAR(50)
)
AS
BEGIN
    SELECT
        DC.CustomerName,
        DA.AccountType,
        DA.Balance,
        DA.Balance + SUM(IIF(FT.TransactionType = 'Deposit', FT.Amount, -FT.Amount)) AS CurrentBalance
    FROM
        DimCustomer DC
    JOIN
        DimAccount DA ON DC.CustomerID = DA.CustomerID
    JOIN
        FactTransaction FT ON DA.AccountID = FT.AccountID
    WHERE
        DC.CustomerName = @name
        AND DA.Status = 'Active'
    GROUP BY
        DC.CustomerName, DA.AccountType, DA.Balance
    ORDER BY
        DA.AccountType, DA.Balance, CurrentBalance;
END;

-- Execute the BalancePerCustomer stored procedure
EXEC BalancePerCustomer @name = 'Shelly Juwita';