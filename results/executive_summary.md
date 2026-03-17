# Fraud Detection Analysis | Executive Summary

## Dataset
200k credit card transactions labeled with fraud flag (`is_fraud`).  
**Overall fraud rate:** ~0.82% of transactions, representing ~6% of total amount.

---

## 1. General Exposure
Fraud represents less than 1% of transactions but its economic impact is disproportionate given the high average amount per fraudulent transaction.

| Transaction Type | Transactions | % Transactions | Amount | % Amount |
|-----------------|--------------|----------------|--------|----------|
| Legitimate | ~198,360 | ~99.2% | ~$13.4M | ~94% |
| Fraud | ~1,640 | ~0.82% | ~$800k | ~6% |

---

## 2. Time Patterns
The night slot (9PM-3AM) concentrates a 2.5% fraud rate vs 0.2% during daytime. Nighttime fraudulent volume is 5x higher than any other slot. The average fraudulent transaction amount is similar across all slots (~$500), indicating the pattern is driven by **volume, not amount**.

Day of week showed no significant differences and is not a relevant variable for detection.

| Time Slot | Fraud Rate | Avg Fraud Amount |
|-----------|------------|-----------------|
| Night 9PM-3AM | 2.5% | $523.66 |
| Morning 3AM-9AM | 0.5% | $354.88 |
| Afternoon 3PM-9PM | 0.2% | $622.67 |
| Midday 9AM-3PM | 0.2% | $499.84 |

---

## 3. Category Patterns
Online categories (`_net`) are consistently riskier than in-person (`_pos`).

| Category | Fraud Rate | Avg Fraud Amount | Note |
|----------|------------|-----------------|------|
| shopping_net | 2.3% | $1,003.5 | Highest avg amount |
| grocery_pos | 2.0% | $311.0 | High volume, low amount |
| misc_net | 1.9% | $795.8 | Hard to detect by rules |
| shopping_pos | 1.0% | $890.4 | - |
| gas_transport | 0.7% | $12.2 | Card testing signal |

`gas_transport` avg fraudulent amount of $12 is consistent with **card testing**: verification of a stolen card before larger charges.

---

## 4. Victim Profile
| Dimension | Finding |
|-----------|---------|
| Gender | Not a predictor (0.83% F vs 0.81% M) |
| Age 80+ | 1.55% fraud rate — highest risk group |
| Age 20-29 | 1.14% fraud rate — second highest |
| Age 40-49 | 0.53% fraud rate — lowest risk group |

**Hypothesis:** older adults due to lower technology familiarity, younger adults due to higher exposure to high-risk digital channels.

---

## 5. Anomalous Behavior

**Unusual amounts:** fraudulent transactions exceed 13x-16x the legitimate average of the same card. The legitimate average is consistent across cards (~$40-65), suggesting a **dynamic per-card threshold** outperforms a global fixed threshold.

**Velocity checks:** transaction velocity is the strongest predictor identified.

| Transactions/Hour | Total Transactions | Fraud Rate |
|-------------------|-------------------|------------|
| 1 | 173,557 | 0.55% |
| 2 | 23,728 | 1.83% |
| 3 | 2,434 | 7.52% (+14x) |
| 4 | 248 | 22.58% |
| 5 | 27 | 48.15% |
| 6 | 6 | 100.00% |

---

## Overall Conclusion

The two most actionable signals for a real-time detection system are:

1. **Velocity:** 3+ transactions in the last hour triggers the fraud rate 14x
2. **Relative amount:** transactions significantly exceeding the card's historical average

Both signals combined cover the most critical patterns identified and can be implemented as rules in an alerting system or as features in a predictive model.
