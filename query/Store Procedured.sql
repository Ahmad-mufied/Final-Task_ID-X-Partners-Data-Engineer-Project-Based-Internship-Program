
/*
Membuat dua Stored Procedure (SP) dengan parameter,untuk membantu mereka mendapatkan ringkasan data
dengan cepat. Stored Procedure yang diminta yaitu :

- DailyTransaction (untuk menghitung banyaknya transaksi beserta total nominalnya setiap harinya).
Kolom yang ditampilkan yaitu Date,TotalTransactions, TotalAmount. Kolom TotalAmount
didapat dengan menjumlahkan Amount setiap harinya. Lalu buatlah dua parameter yaitu
start_date dan end_date jadi ketika menjalankan SP ini dengan memasukkan parameter tersebut,
maka akan menampilkan data sesuai rentang tanggal yang kita masukkan.
*/

-- Drop the DailyTransaction stored procedure if it exists
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'DailyTransaction')
    DROP PROCEDURE DailyTransaction;

-- Create the DailyTransaction stored procedure
CREATE PROCEDURE DailyTransaction
(
@start_date DATE,
@end_date DATE
)
AS
BEGIN
    SELECT CAST(TransactionDate AS DATE) AS Date,
           COUNT(*) AS TotalTransactions,
           SUM(Amount) AS TotalAmount
    FROM FactTransaction
    WHERE CAST(TransactionDate AS DATE) BETWEEN @start_date AND @end_date
    GROUP BY CAST(TransactionDate AS DATE)
    ORDER BY CAST(TransactionDate AS DATE);
END;

-- Execute the DailyTransaction stored procedure
EXEC DailyTransaction @start_date='2024-01-18', @end_date='2024-01-20';


/*
- BalancePerCustomer (untuk mengetahui sisa balance per customer). Kolom yang ditampilkan
yaitu CustomerName, AccountType, Balance, CurrentBalance. Kolom CurrentBalance didapat dari
kolom Balance di tabel account dikurang total amount yang ditransaksikan di tabel transaction
untuk setiap account_id. Untuk setiap transaction_type = Deposit, maka balance akan
bertambah, selain itu maka Balance akan berkurang. Buatlah parameter bernama name sehingga ketika
menjalankan SP ini dengan memasukkan nama salah satu customer tersebut, maka akan menampilkan data
sesuai dengan yang kita input. Lalu pastikan untuk filter yang accountnya berstatus active.
*/

SELECT * FROM DimAccount;

SELECT FT.TransactionID,
DC.CustomerName,
FT.TransactionDate,
DA.AccountType,
DA.Balance,
FT.Amount,
FT.TransactionType
FROM FactTransaction FT
JOIN DimAccount DA ON FT.AccountID= DA.AccountID
JOIN DimCustomer DC ON DA.CustomerID = DC.CustomerID
WHERE DC.CustomerName = 'Shelly Juwita' AND DA.Status = 'Active';

SELECT * FROM FactTransaction;


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