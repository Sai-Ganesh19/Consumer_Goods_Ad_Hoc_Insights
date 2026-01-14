# Consumer Goods Ad_Hoc Insights

# 📊 AtliQ Hardwares – SQL Business Analytics Project

## 📌 Project Overview
AtliQ Hardwares is a fictitious global computer hardware manufacturing company with a strong B2B presence across multiple regions.  
The company sells products such as PCs, peripherals, and accessories through Retailer, Direct, and Distributor channels.

Despite having large volumes of sales and operational data, the management lacked quick and actionable insights to support data-driven decision-making.

This project focuses on solving **10 real-world ad-hoc business requests** using SQL to analyze sales performance, product growth, customer behavior, and channel contribution.

---

## 🎯 Business Objective
Enable AtliQ Hardwares’ leadership to make timely, data-driven decisions by performing SQL-based ad-hoc analysis on sales, product, customer, and channel data.
The analysis focuses on understanding market reach, product portfolio growth, cost efficiency, sales trends, customer discounts, and channel performance across fiscal years.

---

## 🏢 Business Model Overview
- **B2B Model**: Sales through large retail stores and e-commerce platforms
- **B2C Model**: Company-owned stores (AtliQ Exclusive, AtliQ E-Store)
- **Sales Channels**:
  - Retailer (Brick & Mortar, E-commerce)
  - Direct
  - Distributor

---

## 🗂️ Dataset Description
The project uses structured relational data stored in the following tables:

| Table Name | Description |
|-----------|-------------|
| `dim_customer` | Customer details, region, market, channel |
| `dim_product` | Product information, segment, division |
| `fact_sales_monthly` | Monthly sales transactions |
| `fact_gross_price` | Product gross prices by fiscal year |
| `fact_manufacturing_cost` | Manufacturing cost per product |
| `fact_pre_invoice_deductions` | Discount information per customer |

---

## 🔍 Key Business Questions Answered
1. Markets where key customers operate in APAC  
2. Year-over-year growth in unique products (2020 vs 2021)  
3. Product count by segment  
4. Segment with highest product growth  
5. Highest and lowest manufacturing cost products  
6. Top customers receiving maximum discounts  
7. Monthly gross sales trend for key customers  
8. Best-performing quarter by sales volume  
9. Channel-wise revenue contribution  
10. Top-selling products by division  

---

## 🛠️ Tools & Skills Used
- **SQL (MySQL)**
- Joins, CTEs, Window Functions
- Aggregations & Time-based Analysis
- Business-oriented query design

---

## 📈 Key Insights & Outcomes
- Identified **high-growth product segments** and portfolio expansion trends
- Highlighted **most profitable sales channels**
- Enabled **pricing and discount strategy evaluation**
- Revealed **seasonality and sales patterns**
- Supported **inventory and sales prioritization**

