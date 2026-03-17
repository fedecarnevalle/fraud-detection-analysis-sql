-- ================================================================
-- Category Analysis
-- Objective: Identify which merchant categories concentrate fraud
-- Note: _net = online transactions | _pos = in-person transactions
-- ================================================================

SELECT 
    category,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),1) AS pct_fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END),1) AS fraud_amount,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END) / SUM(amt)),1) AS pct_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END),1) AS avg_fraud_amount
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY category
ORDER BY pct_fraud_transactions DESC, pct_fraud_amount DESC;
