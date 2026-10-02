# Olist E-Commerce SQL Analysis

## Overview
An end-to-end SQL analysis of 99,441 orders from Olist, a Brazilian 
e-commerce marketplace, covering the period September 2016 to 
August 2018. The project uses Oracle SQL to explore revenue trends, 
geographic distribution, seller performance, delivery reliability, 
customer reviews, and customer retention behavior.

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
**Tool:** Oracle SQL (SQL Developer)
**Tables:** 9 relational tables, 1.4M+ rows loaded

## Database Schema
See `er_diagram.png` for the full entity-relationship diagram.

The database includes: customers, orders, order_items, order_payments, 
order_reviews, products, sellers, geolocation, and category_translation, 
connected via order_id, customer_id, product_id, and seller_id.

## Data Quality Notes
- Filtered all analysis to `order_status = 'delivered'` (96,478 orders, 
  97% of total) to reflect completed transactions.
- No duplicate order IDs found.
- 2,965 orders have no delivery date (not yet delivered/cancelled).
- `order_delivered_customer_date` was imported as text; converted using 
  `TO_DATE()` where needed for date calculations.
- ~2,300 review rows were skipped during import due to malformed text 
  in free-text comment fields (quotes/line breaks); this affects only 
  the comment text, not review scores.

## Business Questions Answered
13 SQL queries, progressing from basic aggregation to advanced window 
functions:

**Basic:** monthly revenue trends, top categories by revenue, revenue 
by state/city, payment method distribution

**Intermediate:** repeat customer rate, seller performance, delivery 
time vs. estimate by state, categories with worst review scores

**Advanced:** month-over-month growth (LAG), top products per category 
(DENSE_RANK), RFM customer segmentation (NTILE), cumulative revenue & 
moving averages, cohort retention analysis

Full queries are in the `queries/` folder, results in `screenshots/`.

## Key Findings & Recommendations
See `executive_summary.txt` for the full write-up. Headlines:

1. **Only 3% of customers make a second purchase**, and cohort 
   analysis shows 99%+ drop-off immediately after month 0 — the 
   single biggest growth opportunity.
2. **São Paulo state drives ~40% of total revenue**; the business is 
   heavily concentrated in Brazil's Southeast.
3. **Delivery estimates are consistently padded** — every state 
   delivers earlier than promised, suggesting room to tighten 
   expectations.
4. **bed_bath_table** is a top-3 revenue category but also among the 
   lowest-rated, flagging a potential quality/satisfaction gap.
5. **Credit card (78% of payments)** is the only method used with 
   installments, suggesting it's a key purchasing enabler.

## Project Structure
olist-sql-project/
├── queries/              -- All 13 SQL queries + data quality checks
├── screenshots/           -- Query result screenshots
├── er_diagram.png         -- Database schema diagram
├── insights.txt           -- Detailed notes per question
├── executive_summary.txt  -- Top findings & recommendations
└── README.md              -- This file

## Author
SHAMNAS MUSTHAFA — shamnasmusthafa12@gmail.com