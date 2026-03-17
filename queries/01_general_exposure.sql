-- ================================================================
-- General Exposure Analysis
-- Objective: Quantify the overall scale and financial impact of fraud
-- ================================================================

WITH initial_metrics AS (
    SELECT
        CASE WHEN is_fraud = 0 THEN 'Legitimate' ELSE 'Fraud' END AS transaction_type,
        COUNT(*) AS transactions,
        ROUND(SUM(amt), 1) AS amount
    FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
    GROUP BY is_fraud
)
SELECT 
    transaction_type,
    transactions,
    ROUND(100 * (transactions / SUM(transactions) OVER()), 1) AS pct_transactions,
    amount,
    ROUND(100 * (amount / SUM(amount) OVER()), 1) AS pct_amount
FROM initial_metrics
