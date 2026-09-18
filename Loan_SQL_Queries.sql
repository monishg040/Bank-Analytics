CREATE DATABASE Loan_Analytics;
USE Loan_Analytics;

select * from banking_data;

-- Total_Funded_Loan_Amount
SELECT ROUND(SUM(`Funded Amount`)/1000000,2) AS Total_Funded_Loan_Amount
FROM banking_data;

-- Total_Loans
SELECT COUNT(`Account ID`) AS Total_Loans
FROM banking_data;

-- Total_Collection
SELECT ROUND(SUM(`Total Collection`)/1000000,2) AS Total_Collection
FROM banking_data;

-- Total_Interest
SELECT ROUND(SUM(`Total Rrec int`)/1000000,2) AS Total_Interest
FROM banking_data;

-- Default_Loan_Count
SELECT COUNT(`Account ID`) AS Default_Loan_Count
FROM banking_data
WHERE `Is Default Loan`='Y';

-- Default_Loan_Rate
SELECT
ROUND(
(
COUNT(`Account ID`)
/
(SELECT COUNT(`Account ID`) FROM banking_data)
) * 100,
2
) AS Default_Loan_Rate
FROM banking_data
WHERE `Is Default Loan`='Y';

-- Delinquent_Client_Count
SELECT COUNT(`Account ID`) AS Delinquent_Client_Count
FROM banking_data
WHERE `Is Delinquent Loan`='Y';

-- Delinquent_Loan_Rate
SELECT
ROUND(
(
COUNT(`Account ID`)
/
(SELECT COUNT(`Account ID`) FROM banking_data)
) * 100,
2
) AS Delinquent_Loan_Rate
FROM banking_data
WHERE `Is Delinquent Loan`='Y';

-- Un_Verified_Loans
SELECT COUNT(`Account ID`) AS Un_Verified_Loans
FROM banking_data
WHERE `Verification Status`='Not Verified';

-- Branch-Wise Performance
SELECT
    `Branch Name`,
    ROUND(SUM(`Total Collection`)/1000000,2) AS Collection_M,
    ROUND(SUM(`Total Fees`)/1000000,2) AS Fees_M,
    ROUND(SUM(`Total Rrec int`)/1000000,2) AS Interest_M
FROM banking_data
GROUP BY `Branch Name`
ORDER BY Collection_M DESC;

-- State-Wise Loan
SELECT
    `State Name`,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY `State Name`
ORDER BY Funded_Loan_M DESC;

-- Religion-Wise Loan
SELECT
    Religion,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY Religion
ORDER BY Funded_Loan_M DESC;

-- Product Group-Wise Loan
SELECT
    `Purpose Category`,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY `Purpose Category`
ORDER BY Funded_Loan_M DESC;

-- Disbursement Trend
SELECT
    YEAR(STR_TO_DATE(`Disbursement Date`,'%d-%m-%Y')) AS Year_,
    MONTH(STR_TO_DATE(`Disbursement Date`,'%d-%m-%Y')) AS Month_,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY Year_, Month_
ORDER BY Year_, Month_;

-- Grade-Wise Loan
SELECT
    Grade,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY Grade
ORDER BY Funded_Loan_M DESC;

-- Loan Status-Wise Loan
SELECT
    `Loan Status`,
    COUNT(`Account ID`) AS Loan_Count
FROM banking_data
GROUP BY `Loan Status`
ORDER BY Loan_Count DESC;

-- Age Group-Wise Loan
SELECT
    `Age Group`,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY `Age Group`
ORDER BY Funded_Loan_M DESC;

-- Loan Maturity
SELECT
    Term,
    ROUND(SUM(`Funded Amount`)/1000000,2) AS Funded_Loan_M
FROM banking_data
GROUP BY Term
ORDER BY Funded_Loan_M DESC;