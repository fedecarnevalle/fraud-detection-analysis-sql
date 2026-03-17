-- ================================================================
-- Time Patterns Analysis
-- Objective: Identify when fraud is most likely to occur
-- ================================================================

-- Day of Week Analysis
-- Finding: No significant pattern across days (~0.8% fraud rate)
SELECT 
    FORMAT_DATE('%A', trans_date_trans_time) AS day_of_week,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),1) AS pct_fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END),1) AS fraud_amount,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END)) / SUM(amt),1) AS pct_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END),2) AS avg_fraud_amount
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY day_of_week
ORDER BY pct_fraud_transactions DESC;


-- Hourly Analysis
-- Finding: Night slot (10PM-3AM) shows fraud rate 5x higher than daytime
SELECT 
    EXTRACT(HOUR FROM trans_date_trans_time) AS hour,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),1) AS pct_fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END),1) AS fraud_amount,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END)) / SUM(amt),1) AS pct_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END),2) AS avg_fraud_amount
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY hour
ORDER BY pct_fraud_transactions DESC;

-- Time Slot Analysis
-- Grouping hours into 4 slots for cleaner pattern visualization
SELECT
    CASE 
        WHEN EXTRACT(HOUR FROM trans_date_trans_time) BETWEEN 21 AND 23 
          OR EXTRACT(HOUR FROM trans_date_trans_time) BETWEEN 0 AND 2 THEN 'Night 9PM-3AM'
        WHEN EXTRACT(HOUR FROM trans_date_trans_time) BETWEEN 3 AND 8 THEN 'Morning 3AM-9AM'
        WHEN EXTRACT(HOUR FROM trans_date_trans_time) BETWEEN 9 AND 14 THEN 'Midday 9AM-3PM'
        ELSE 'Afternoon 3PM-9PM'
    END AS time_slot,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),1) AS pct_fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END),1) AS fraud_amount,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN amt ELSE 0 END)) / SUM(amt),1) AS pct_fraud_amount,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END),2) AS avg_fraud_amount
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY time_slot
ORDER BY pct_fraud_transactions DESC;
