-- ================================================================
-- Victim Profile Analysis
-- Objective: Identify demographic patterns among fraud victims
-- ================================================================

-- Gender Analysis
-- Finding: No significant difference between genders (~0.82% fraud rate)
SELECT 
    gender,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    COUNT(*) AS total_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),2) AS pct_fraud_transactions
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY gender;


-- Age Group Analysis
-- Finding: Extreme age groups (80+ and 20-29) show highest fraud rates
-- Age calculated dynamically from date of birth to avoid hardcoding
SELECT 
    CASE 
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 0 AND 19 THEN '0-19'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 20 AND 29 THEN '20-29'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 30 AND 39 THEN '30-39'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 40 AND 49 THEN '40-49'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 50 AND 59 THEN '50-59'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 60 AND 69 THEN '60-69'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 70 AND 79 THEN '70-79'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(dob), YEAR) BETWEEN 80 AND 89 THEN '80-89'
        ELSE 'Over 90'
    END AS age_group,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    COUNT(*) AS total_transactions,
    ROUND(100*(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) / COUNT(*)),2) AS pct_fraud_transactions
FROM `fraud-analysis.fraud_credit_card_transactions.fraud_transactions`
GROUP BY age_group
ORDER BY pct_fraud_transactions DESC;
