# Fraud Detection Analysis | Credit Card Transactions

## Overview
SQL-based exploratory analysis on 200k credit card transactions (Jan 2019 - Apr 2019) to identify fraud patterns, anomalous behavior, and high-risk customer profiles. Built as part of a data analytics portfolio to demonstrate fraud detection capabilities using BigQuery.

## Business Problem
Given a labeled dataset of credit card transactions, the goal is to identify patterns that distinguish fraudulent from legitimate transactions, enabling actionable insights for a real-time fraud detection system.
This analysis explores:
- When fraud occurs (time of day, day of week)
- Where fraud occurs (merchant categories)
- Who is most affected (victim profile by age and gender)
- How fraudsters behave (unusual amounts, transaction velocity)

## Tools
- **SQL** (BigQuery)
- **Dataset:** [Credit Card Fraud Detection - Kaggle](https://www.kaggle.com/datasets/kartik2112/fraud-detection)

## Key Findings

### 1. General Exposure
Fraud represents less than 1% of transactions but has a disproportionate economic impact given the high average amount per fraudulent transaction.

### 2. Time Patterns
The night slot (9PM-3AM) concentrates a 2.5% fraud rate vs 0.2% during daytime — 5x higher volume. Day of week showed no significant differences.

### 3. Category Patterns
Online categories (`_net`) are consistently riskier than in-person (`_pos`):
- `shopping_net` has double the fraud rate of `shopping_pos` (2.3% vs 1.0%)
- `gas_transport` shows $12 avg fraudulent amount, consistent with **card testing** behavior

### 4. Victim Profile
- **Gender:** not a fraud predictor (0.83% F vs 0.81% M)
- **Age:** adults 80+ (1.55%) and young adults 20-29 (1.14%) are most vulnerable

### 5. Anomalous Behavior
**Unusual amounts:** fraudulent transactions exceed 13x-16x the legitimate average amount of the same card.

**Velocity checks:** transaction velocity is the strongest predictor identified:

| Transactions/hour | Fraud rate |
|-------------------|------------|
| 1 | 0.55% |
| 3 | 7.52% (14x baseline) |
| 5 | 48.15% |
| 6 | 100% |

## Repository Structure
```
fraud-detection-analysis/
│
├── README.md
├── queries/
│   ├── 01_general_exposure.sql
│   ├── 02_time_patterns.sql
│   ├── 03_category_analysis.sql
│   ├── 04_victim_profile.sql
│   └── 05_anomalous_behavior.sql
└── results/
    └── executive_summary.md
```

## Conclusion
The two most actionable signals for a real-time detection system are:
1. **Velocity:** 3+ transactions in the last hour triggers the fraud rate 14x
2. **Relative amount:** transactions significantly exceeding the card's historical average

Both signals can be implemented as rules in an alerting system or as features in a predictive model.
