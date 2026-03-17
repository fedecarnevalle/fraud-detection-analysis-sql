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
- `shopping_net` has double the fraud rate of `shopping_pos` (2.3% vs 1.0%) with the highest avg fraudulent amount ($1,003)
- `gas_transport` shows $12 avg fraudulent amount, consistent with **card testing** behavior

| Category | Fraud Rate | Avg Fraud Amount |
|----------|------------|-----------------|
| shopping_net | 2.3% | $1,003.5 |
| grocery_pos | 2.0% | $311.0 |
| misc_net | 1.9% | $795.8 |
| shopping_pos | 1.0% | $890.4 |
| gas_transport | 0.7% | $12.2 |

### 4. Victim Profile
- **Gender:** not a fraud predictor (0.83% F vs 0.81% M)
- **Age:** adults 80+ (1.55%) and young adults 20-29 (1.14%) are most vulnerable

### 5. Anomalous Behavior
**Unusual amounts:** fraudulent transactions exceed 13x-16x the legitimate average amount of the same card.


**Velocity checks:** Cards with 3+ transactions/hour show a fraud rate 14x higher than baseline:

| Transactions/hour | Fraud rate |
|-------------------|------------|
| 1 | 0.55% (baseline)|
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
## Conclusions

The most actionable signals for a real-time detection system are:

1. **Velocity:** 3+ transactions/hour triggers 14x higher fraud rate (0.55% → 7.52%). At 5+, nearly 1 in 2 is fraudulent — strongest real-time signal
2. **Relative amount:** Fraudulent transactions exceed 13x-16x the card's own legitimate average — per-card dynamic thresholds outperform fixed global limits
3. **Night hours (9PM-3AM):** Fraud rate 5x higher than daytime, driven by volume not amount
4. **Online categories (`_net`):** Double the fraud rate vs in-person (`_pos`) with higher avg fraudulent amounts
5. **Card testing:** `gas_transport` avg fraudulent amount of $12 signals card verification — low-amount transactions in this category should trigger alerts

Those signals can be implemented as rules in an alerting system or as features in a predictive model.
