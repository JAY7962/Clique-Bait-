# 🛒 Clique Bait – E-Commerce Funnel Analysis (SQL)

## 📌 Project Overview
Clique Bait is an e-commerce analytics case study focused on analyzing **user behavior across the purchase funnel** for an online seafood store.  
The objective is to identify **funnel drop-offs**, evaluate **product and category performance**, and assess **campaign effectiveness** using SQL.

This case study is part of the **8 Week SQL Challenge – Case Study #6**.

Source: https://8weeksqlchallenge.com/case-study-6/

---

## 🎯 Business Objective
The primary business task is to:
- Analyze **funnel fallout rates** from Page View → Add to Cart → Purchase
- Understand **user engagement patterns**
- Evaluate **product-level and category-level conversion**
- Assess **marketing campaign effectiveness**
- Generate **actionable recommendations** to improve conversions

---

## 🗂️ Dataset Description

### Table 1: `users`

| user_id | cookie_id | start_date |
|--------:|-----------|------------|
| 397 | 3759ff | 2020-03-30 00:00:00 |
| 215 | 863329 | 2020-01-26 00:00:00 |
| 191 | eefca9 | 2020-03-15 00:00:00 |
| 89  | 764796 | 2020-01-07 00:00:00 |
| 127 | 17ccc5 | 2020-01-22 00:00:00 |
| 81  | b0b666 | 2020-03-01 00:00:00 |
| 260 | a4f236 | 2020-01-08 00:00:00 |
| 203 | d1182f | 2020-04-18 00:00:00 |
| 23  | 12dbc8 | 2020-01-18 00:00:00 |
| 375 | f61d69 | 2020-01-03 00:00:00 |

---

### Table 2: `events`

| visit_id | cookie_id | page_id | event_type | sequence_number | event_time |
|---------|-----------|---------|------------|-----------------|------------|
| 719fd3 | 3d83d3 | 5  | 1 | 4  | 2020-03-02 00:29:09 |
| 719fd3 | 3d83d3 | 12 | 2 | 5  | 2020-03-02 00:31:10 |
| 719fd3 | 3d83d3 | 13 | 3 | 6  | 2020-03-02 00:32:45 |
| fb1eb1 | c5ff25 | 5  | 2 | 8  | 2020-01-22 07:59:16 |
| fb1eb1 | c5ff25 | 5  | 1 | 9  | 2020-01-22 08:00:00 |
| fb1eb1 | c5ff25 | 12 | 3 | 10 | 2020-01-22 08:02:30 |
| 23fe81 | 1e8c2d | 10 | 1 | 9  | 2020-03-21 13:14:11 |
| ad91aa | 648115 | 6  | 1 | 3  | 2020-04-27 16:28:09 |
| 5576d7 | ac418c | 6  | 1 | 4  | 2020-01-18 04:55:10 |
| 48308b | c686c1 | 8  | 1 | 5  | 2020-01-29 06:10:38 |
| 48308b | c686c1 | 8  | 2 | 6  | 2020-01-29 06:12:00 |
| 48308b | c686c1 | 13 | 3 | 7  | 2020-01-29 06:13:45 |
| 46b17d | 78f9b3 | 7  | 1 | 12 | 2020-02-16 09:45:31 |
| 9fd196 | ccf057 | 4  | 1 | 5  | 2020-02-14 08:29:12 |
| edf853 | f85454 | 1  | 1 | 1  | 2020-02-22 12:59:07 |
| 3c6716 | 02e74f | 3  | 2 | 5  | 2020-01-31 17:56:20 |

---

### Table 3: `event_identifier`

| event_type | event_name |
|-----------:|------------|
| 1 | Page View |
| 2 | Add to Cart |
| 3 | Purchase |
| 4 | Ad Impression |
| 5 | Ad Click |

---

### Table 4: `campaign_identifier`

| campaign_id | products | campaign_name | start_date | end_date |
|------------:|----------|-------------------------------|------------|------------|
| 1 | 1–3 | BOGOF – Fishing For Compliments | 2020-01-01 | 2020-01-14 |
| 2 | 4–5 | 25% Off – Living The Lux Life | 2020-01-15 | 2020-01-28 |
| 3 | 6–8 | Half Off – Treat Your Shellfish | 2020-02-01 | 2020-03-31 |

---

### Table 5: `page_hierarchy`

| page_id | page_name | product_category | product_id |
|--------:|-----------|------------------|------------|
| 1 | Home Page | NULL | NULL |
| 2 | All Products | NULL | NULL |
| 3 | Salmon | Fish | 1 |
| 4 | Kingfish | Fish | 2 |
| 5 | Tuna | Fish | 3 |
| 6 | Russian Caviar | Luxury | 4 |
| 7 | Black Truffle | Luxury | 5 |
| 8 | Abalone | Shellfish | 6 |
| 9 | Lobster | Shellfish | 7 |
| 10 | Crab | Shellfish | 8 |
| 11 | Oyster | Shellfish | 9 |
| 12 | Checkout | NULL | NULL |
| 13 | Confirmation | NULL | NULL |

---

## 🔧 Data Preparation & Enrichment
- Joined `events` with `event_identifier` to add readable event names
- Joined with `page_hierarchy` to add product and category metadata
- Created derived views instead of altering raw tables
- Added realistic missing funnel events to simulate real-world user journeys

---

## 📊 Key Analyses Performed

### 🔹 Exploratory Data Analysis (EDA)
- Counted unique users and visits
- Analyzed event-type distribution
- Calculated purchase conversion rates
- Identified early and late-stage funnel drop-offs

---

### 🔹 Visit-Level Funnel Analysis
Aggregated events into a **single row per visit**, capturing:
- Visit start time
- Page views
- Cart additions
- Purchase flag

---

### 🔹 Product & Category-Level Funnel Analysis
- Identified products with strong cart-to-purchase conversion
- Identified categories with poor view-to-cart conversion
- Quantified cart abandonment

---

### 🔹 Campaign Effectiveness Analysis
- Mapped visits to active campaigns using time-based attribution
- Compared traffic generation vs conversion efficiency

---

## 📈 Key Insights
- Funnel drop-offs occur at multiple stages, not only checkout
- Some products convert strongly once added to cart
- Luxury products show interest without intent
- User journeys are often non-linear

---

## 💡 Recommendations
- Optimize checkout flow for high-intent products
- Improve value messaging for low-conversion categories
- Focus campaigns on conversion efficiency, not just traffic
- Validate insights on larger datasets or via A/B testing

---

## 🛠️ Tools & Skills Used
- SQL (CTEs, joins, aggregations, CASE statements)
- Funnel analysis
- Business metrics definition
- Data storytelling

---

## 📌 Key Learning
This project demonstrates how raw clickstream data can be transformed into **actionable business insights** using SQL, closely mirroring real-world analytics and consulting workflows.

---

## 🚀 Next Steps
- Add session duration metrics
- Perform cohort analysis
- Validate insights using larger datasets
