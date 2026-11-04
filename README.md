# Retail Customer Analytics | SQL Server, Python & Power BI

## Project Overview
This project analyzes retail transaction data to understand customer purchasing behavior, identify valuable customer segments, and monitor customer churn. The project follows an end-to-end analytics workflow utilizing **SQL Server** for data integration and cleaning, **Python** for customer-level analysis and RFM segmentation, and **Power BI** for interactive dashboards and business intelligence reporting.

---

## Business Objectives
- Analyze customer purchasing behavior and revenue trends.
- Identify high-value, loyal, and at-risk customers.
- Understand customer churn across segments and time periods.
- Provide actionable insights and recommendations to improve customer retention and revenue.

---

## Tools & Technologies
| Tool / Library | Purpose |
| :--- | :--- |
| **SQL Server (SSMS)** | Data integration, cleaning, deduplication, and validation |
| **Python** | Customer analysis, RFM calculations, and segmentation |
| **Pandas & NumPy** | Data manipulation and feature engineering |
| **SQLAlchemy & pyodbc** | Database connectivity and pipeline automation |
| **Power BI Desktop** | Interactive dashboards, DAX feature engineering, and business reporting |

---

## Project Workflow

### 1. SQL Server – Data Integration & Data Cleaning
The SQL component focuses on integrating two years of retail transaction data into a consolidated, high-integrity dataset.
- **Database Setup:** Created the `EcommerceCustomerAnalytics` database.
- **Data Integration:** Combined 2009–2010 and 2010–2011 datasets using `UNION ALL`[cite: 1].
- **Data Type Standardization:** Standardized invoice dates and price data types using `TRY_CONVERT()` and `COALESCE()`[cite: 1].
- **Validation & Quality Checks:** Validated row counts and checked for missing customer IDs, descriptions, invalid quantities, and null date/price values[cite: 1].
- **Deduplication:** Identified exact duplicate transactions using `GROUP BY` and `HAVING`, implementing deduplication via a Common Table Expression (CTE) and `ROW_NUMBER()` to retain a single unique record per duplicate group[cite: 1].
- **Output:** Generated the final cleaned staging dataset named `CleanedRetailData`[cite: 1].
- **SQL Concepts Used:** `UNION ALL`, `TRY_CONVERT()`, `COALESCE()`, `CASE`, `COUNT()`, `GROUP BY`, `HAVING`, `CTEs`, `ROW_NUMBER()`, and `SELECT INTO`[cite: 1].

### 2. Python – RFM Analysis & Customer Segmentation
The Python component extracts data from SQL Server to calculate behavioral customer metrics and segment audiences[cite: 1].
- **Pipeline Connectivity:** Connected Python to SQL Server utilizing `SQLAlchemy` and `pyodbc`[cite: 1].
- **Feature Engineering:** Filtered valid customer IDs and positive quantities, parsed datetime fields, extracted invoice months, and calculated transaction revenue (`Quantity × Price`)[cite: 1].
- **RFM Metric Calculation:**
  - **Recency:** Days since the customer's most recent purchase (relative reference date: December 10, 2011)[cite: 1].
  - **Frequency:** Total unique invoices generated per customer[cite: 1].
  - **Monetary:** Total gross spend accumulated per customer[cite: 1].
- **Customer Segmentation & Churn Tracking:**
  - Applied quintile-based scoring via `pd.qcut()` to grade RFM from 1 to 5[cite: 1].
  - Classified customers into strategic segments: **Champions**, **Loyal**, **At Risk**, **New**, and **Needs Attention**[cite: 1].
  - Created an `IsChurned` boolean indicator flagging customers inactive for over 90 days relative to the reference date[cite: 1].
  - Exported the final enriched dataset back into SQL Server and CSV for reporting[cite: 1].
- **Libraries & Concepts:** Pandas, NumPy, SQLAlchemy, pyodbc, aggregation, feature engineering, RFM scoring, and database integration[cite: 1].

### 3. Power BI – Interactive Business Intelligence Dashboards
The Power BI component transforms the processed transactional data into immersive, interactive dashboards for business stakeholders[cite: 1].

#### **Power BI Implementation & Architecture:**
- **Data Modeling & Power Query:** Established strict relationships between customer segments, transactional metrics, and calendar dimensions to support clean cross-filtering and multi-table security context.
- **DAX Measures & Calculations:** Developed custom DAX measures for aggregate counts, revenue total, ratio-based KPIs, and dynamic segment filtering.
- **Visualizations & Charts:** Integrated rich visual layouts including KPI summary cards, clustered bar charts, column charts, and monthly/quarterly temporal trend lines.
- **Drillthrough Navigation:** Implemented dynamic **drillthrough functionality**, enabling users to smoothly transition from high-level enterprise metrics and aggregate segment blocks directly down to granular, individual customer records[cite: 1].

---

## Dashboard Overview & Key Insights

### **Business Overview Dashboard**
- **Key Metrics Tracked:** Total Customers (5,881), Total Revenue (~$17.37M), Overall Churn Rate, and Average Customer Value[cite: 1].
- **Key Visual Insights:** 
  - Visualizes customer distribution and retention across distinct behavioral segments[cite: 1].
  - **Needs Attention** is identified as the largest individual customer segment with 1,667 customers[cite: 1].
  - Combined, **Needs Attention** and **At Risk** total 3,007 customers, exposing a vital high-impact window for targeted retention campaigns[cite: 1].
  - Quarterly trend lines show quarterly churn declining from 48.02% in Q1 down to 34.14% in Q4[cite: 1].

### **RFM Analysis Dashboard**
- **Key Metrics Tracked:** Total RFM Customers (5,726), Filtered Revenue (~$16.17M), Average Recency, Frequency, and Monetary Scores[cite: 1].
- **Key Visual Insights:**
  - Evaluates segment-level performance and asset concentration globally by country[cite: 1].
  - Highlights a prominent revenue concentration where the **United Kingdom contributes roughly 89%** of total dashboard revenue[cite: 1].

---

## Strategic Business Recommendations
1. **Prioritize Retention:** Launch immediate automated win-back and retention campaigns for customers falling within the *Needs Attention* and *At Risk* brackets[cite: 1].
2. **Analyze Seasonality:** Investigate seasonal drivers behind quarterly churn drops to stabilize customer lifecycles year-round[cite: 1].
3. **Reward Loyalty:** Develop VIP and personalized tier engagement structures specifically catered to *Loyal* and *Champions* segments[cite: 1].
4. **Market Diversification:** Mitigate high revenue dependency on the United Kingdom by exploring targeted growth opportunities in emerging international territories[cite: 1].
5. **Metric Governance:** Continuously validate aggregate customer counts, revenue totals, and churn definitions against baseline tables before deploying insights for executive decision-making[cite: 1].

---

## Repository Structure
```text
Retail-Customer-Analytics/
├── RetailAnalytics.sql                  # End-to-end SQL data integration & cleaning script
├── IKEA RFM Segmentation.ipynb          # Python notebook for RFM modeling and segmentation
├── RetailCustomerDataAnalysis.pbix      # Interactive Power BI report file (with Data Model & Drillthrough)
├── insights/
│   └── Retail_Analytics_Insights.pdf    # Compiled project business insights report
└── dashboard/
    └── Power_BI_Dashboard.pdf           # Exported visual dashboard view
