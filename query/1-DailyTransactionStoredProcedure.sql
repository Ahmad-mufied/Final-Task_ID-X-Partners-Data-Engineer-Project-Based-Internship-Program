
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