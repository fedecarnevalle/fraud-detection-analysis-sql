-- ================================================================
-- Anomalous Behavior Analysis
-- Objective: Detect unusual patterns that signal fraudulent activity
-- ================================================================

-- Unusual Amount Analysis
-- Compares avg fraudulent vs legitimate amount per card
-- Finding: Fraudulent transactions exceed 13x-16x the card's legitimate average
SELECT 
    cc_num,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END),2) AS avg_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 0 THEN amt END),2) AS avg_legitimate_amount,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END) / AVG(CASE WHEN is_fraud = 0 THEN amt END),1) AS fraud_ratio
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY cc_num
HAVING avg_fraud_amount IS NOT NULL
ORDER BY fraud_ratio DESC;


-- Velocity Check Analysis (Sliding Window)
-- Counts transactions per card in the last 60 minutes using a range window
-- Finding: Cards with 3+ transactions/hour show 14x higher fraud rate
WITH velocity_metrics AS (
    SELECT 
        cc_num,
        trans_date_trans_time,
        amt,
        is_fraud,
        COUNT(*) OVER (
            PARTITION BY cc_num 
            ORDER BY UNIX_SECONDS(trans_date_trans_time) 
            RANGE BETWEEN 3600 PRECEDING AND CURRENT ROW
        ) AS transactions_last_hour
    FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
)
SELECT 
    transactions_last_hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(100*(SUM(is_fraud) / COUNT(*)),2) AS fraud_rate
FROM velocity_metrics
GROUP BY transactions_last_hour
ORDER BY transactions_last_hour ASC;
