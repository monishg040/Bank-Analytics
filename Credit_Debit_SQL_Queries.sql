Create database BankAnalytics;
use BankAnalytics;
-- Created Table
Drop table Credit_Debit;
CREATE TABLE Credit_Debit (
    CustomerID           VARCHAR(255),
    CustomerName         VARCHAR(255),
    AccountNumber        VARCHAR(50),
    TransactionDate      DATE,
    Month                INT,
    MonthName            VARCHAR(20),
    TransactionType      VARCHAR(50),
    Amount               DECIMAL(18,2),
    Balance              DECIMAL(18,2),
    Description          VARCHAR(500),
    Branch               VARCHAR(255),
    TransactionMethod    VARCHAR(100),
    Currency             VARCHAR(10),
    BankName             VARCHAR(255),
    Risk                 VARCHAR(50)
);
-- ImportFile
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/C_D.csv'
INTO TABLE Credit_Debit
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

select * From Credit_Debit;

-- Total Credit Amount
select TransactionType, sum(Amount)
from Credit_Debit
where TransactionType="Credit";

-- 2-Total Debit Amount
select TransactionType, sum(Amount)
from Credit_Debit
where TransactionType="Debit";
-- 3-Credit to Debit Ratio:
WITH ratio AS (
    SELECT
        SUM(CASE WHEN TransactionType = 'Credit' THEN amount ELSE 0 END) AS total_credit_amount,
        SUM(CASE WHEN TransactionType = 'Debit'  THEN amount ELSE 0 END) AS total_debit_amount
    FROM Credit_Debit
)
SELECT
    ROUND(total_credit_amount / total_debit_amount, 2) as credit_to_debit_ratio 
FROM ratio;

-- 4-Net Transaction Amount:
with netamt as (
select
sum(case when TransactionType = 'Credit' THEN amount ELSE 0 END) AS total_credit_amount,
        SUM(CASE WHEN TransactionType = 'Debit'  THEN amount ELSE 0 END) AS total_debit_amount
    FROM Credit_Debit
)
select total_credit_amount-total_debit_amount as Net_Transaction
from netamt;

-- 5-Account Activity Ratio:
SELECT COUNT(*) / NULLIF(AVG(Balance), 2) AS ratio
FROM Credit_Debit;

-- 6-Transactions per Day/Week/Month:
SELECT
    DATE(TransactionDate) AS transaction_day,
    WEEK(TransactionDate, 1) AS week_number,
    DATE_FORMAT(TransactionDate, '%m') AS month,
    COUNT(*) AS total_transactions
FROM Credit_Debit
GROUP BY
    DATE(TransactionDate),
    YEAR(TransactionDate),
    WEEK(TransactionDate, 1),
    DATE_FORMAT(TransactionDate, '%m')
ORDER BY transaction_day;

-- daily
SELECT
    DATE(TransactionDate) AS transaction_day,COUNT(*) AS total_transactions
    from Credit_Debit
    group by DATE(TransactionDate) ;
    
    -- Monthly
    select DATE_FORMAT(TransactionDate, '%m') AS month,
    COUNT(*) AS total_transactions
FROM Credit_Debit
group by DATE_FORMAT(TransactionDate,'%m')
order by month ;

-- 7-Total Transaction Amount by Branch:
select Branch,round(sum(Amount) / 1000000, 2) as Total_Transaction
from Credit_Debit
group by Branch
order by Total_Transaction desc;

-- 8-Transaction Volume by Bank:
select BankName,round(sum(Amount) / 1000000, 2) as Total_Transaction
from Credit_Debit
group by BankName
order by Total_Transaction desc;

-- 9-Transaction Method Distribution:
SELECT
    TransactionMethod,
    SUM(Amount) AS Total_Transaction,
    ROUND(
        SUM(Amount) * 100.0 /
        (SELECT SUM(Amount) FROM Credit_Debit ),
        2
    ) AS Percent_Of_Transaction
FROM Credit_Debit
GROUP BY TransactionMethod;

-- 10-Branch Transaction Growth:
WITH monthly_amount AS (
    SELECT
        Branch,
        DATE_FORMAT(TransactionDate, '%m') AS monthNum,
        SUM(Amount) AS total_amount
    FROM Credit_Debit
    GROUP BY Branch, DATE_FORMAT(TransactionDate, '%m')
)
SELECT
    Branch,
    monthNum,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY Branch
        ORDER BY monthNum
    ) AS prev_month_amount,
    ROUND(
        (
            total_amount -
            LAG(total_amount) OVER (
                PARTITION BY Branch
                ORDER BY monthNum
            )
        ) * 100.0 /
        LAG(total_amount) OVER (
            PARTITION BY Branch
            ORDER BY monthNum
        ),
        2
    ) AS mom_percent
FROM monthly_amount;

-- 11-High-Risk Transaction Flag:
SELECT Risk,count(Risk)
FROM Credit_Debit
group by Risk
order by count(Risk)
limit 1 ;

-- 12-Suspicious Transaction Frequency:
SELECT
    DATE_FORMAT(TransactionDate, '%m-%Y') AS month_year,

    SUM(
        CASE 
            WHEN amount > 4000 AND transactiontype IN ('Credit', 'Debit')
            THEN 1 ELSE 0 
        END
    ) AS high_risk_total

FROM Credit_Debit
GROUP BY DATE_FORMAT(TransactionDate, '%m-%Y')
ORDER BY month_year;

