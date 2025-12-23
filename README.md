# 🛒 Clique Bait – E-Commerce Funnel Analysis (SQL)

## 📌 Project Overview
Clique Bait is an e-commerce analytics case study focused on analyzing **user behavior across the purchase funnel** for an online seafood store.  
The objective is to identify **funnel drop-offs**, evaluate **product and category performance**, and assess **campaign effectiveness** using SQL.

This case study is part of the **8 Week SQL Challenge – Case Study #6**.  
Source: https://8weeksqlchallenge.com/case-study-6/

---

## 🎯 Business Objective
The primary business goals were to:
- Analyze **funnel fallout rates** from *Page View → Add to Cart → Purchase*
- Understand **user engagement patterns**
- Evaluate **product-level and category-level conversion**
- Measure **marketing campaign effectiveness**
- Generate **actionable recommendations** to improve conversions

---

## 🗂️ Dataset Overview

### Core Tables Used
- `users` – maps users to cookies  
- `events` – captures user interactions  
- `event_identifier` – maps event types to readable names  
- `page_hierarchy` – provides product and category metadata  
- `campaign_identifier` – contains campaign timelines and product mappings  

---

## 🔍 Events Data (Analysis-Ready View)

Instead of working directly with the raw `events` table, an **enriched analytical view** was created by joining supporting tables.

### 🔹 Columns Used for Analysis (10–12 fields)

| Column | Description |
|------|-------------|
| visit_id | Unique visit identifier |
| user_id | Mapped user identifier |
| cookie_id | Browser/session identifier |
| event_time | Timestamp of interaction |
| event_type | Event code (view, cart, purchase) |
| event_name | Readable event name |
| page_id | Page identifier |
| page_name | Product or page name |
| product_id | Unique product ID |
| product_category | Product category |
| sequence_number | Order of events within a visit |

📌 *This mirrors real-world analytics workflows where raw clickstream data is transformed into analysis-ready datasets without modifying source tables.*

---

## 🔧 Data Preparation & Enrichment
- Joined `events` with `event_identifier` to add readable event names  
- Joined with `page_hierarchy` to add product and category context  
- Joined with `users` to map cookies to users  
- Created derived views instead of altering raw tables  
- Added realistic missing funnel events to simulate real-world user journeys  

---

## 📊 Key Analyses Performed

### 🔹 Exploratory Data Analysis (EDA)
- Counted **unique users and visits**
- Analyzed **event-type distribution**
- Calculated **overall purchase conversion**
- Identified **early-stage vs late-stage drop-offs**

---

### 🔹 Visit-Level Funnel Analysis
Aggregated interactions into **one row per visit**, capturing:
- Visit start time
- Total page views
- Cart additions
- Purchase flag  

This enabled accurate **visit-to-purchase conversion analysis**.

---

### 🔹 Product & Category-Level Funnel Analysis
- Compared **view → cart → purchase** across products
- Identified **high cart abandonment products**
- Highlighted **category-level conversion differences**

---

### 🔹 Campaign Effectiveness Analysis
- Mapped visits to campaigns using **time-based attribution**
- Compared **traffic volume vs conversion efficiency**
- Identified campaigns with **high intent but low traffic**

---

## 📈 Key Insights
- Funnel drop-offs occur **early**, not only at checkout
- **Shellfish products** convert strongly once viewed
- **Luxury products** show interest but weak purchase intent
- Campaign success depends more on **product-category alignment** than discount size
- User journeys are often **non-linear**, requiring visit-level aggregation

---

## 💡 Recommendations
- Focus optimization on **top-of-funnel engagement**
- Scale campaigns aligned with **high-conversion categories**
- Improve trust and pricing communication for **Luxury products**
- Evaluate campaigns using **conversion efficiency**, not just traffic
- Validate insights with **larger datasets or A/B testing**

---

## 🛠️ Tools & Skills Used
- SQL (CTEs, joins, aggregations, CASE statements)
- Funnel and conversion analysis
- Campaign attribution logic
- Data storytelling and business interpretation

---

## 📌 Key Learning
This project demonstrates how raw clickstream data can be transformed into **decision-ready business insights** using SQL, closely reflecting real-world analytics and consulting workflows.

---

## 🚀 Next Steps
- Add session duration and time-to-conversion metrics  
- Perform cohort-based conversion analysis  
- Validate insights on larger datasets or via A/B testing  
