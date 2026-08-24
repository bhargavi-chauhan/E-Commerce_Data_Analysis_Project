# Revenue Leakage Detection & E-commerce Operations Analytics

An end-to-end data analytics project that identifies revenue leakage, analyzes failed orders and fulfillment performance, and evaluates return/refund behavior using Python, MySQL, and Power BI.

The project focuses on answering a practical business question:

> **Where is the business losing revenue, and which operational factors are contributing to that loss?**

---

## 📊 Dashboard Preview

The final Power BI dashboard contains four analytical pages:

1. **Executive Overview**
2. **Shipment & Courier Performance**
3. **Returns & Refunds**
4. **Product & Customer Leakage**

---

## 🎯 Business Problem

E-commerce businesses can lose revenue through failed orders, returns, refunds, delivery issues, and operational inefficiencies.

Simply looking at total sales does not reveal where these losses occur.

This project analyzes transactional, customer, product, shipment, and return/refund data to:

- Quantify total revenue leakage
- Identify the major sources of revenue loss
- Analyze failed orders and their financial impact
- Compare courier and shipment performance
- Understand return and refund patterns
- Identify high-loss product categories and products
- Analyze customer segments and churn risk associated with leakage
- Provide actionable insights for reducing revenue leakage

---

## 🗂️ Dataset

The project uses a multi-table e-commerce dataset containing:

| Table | Records |
|---|---:|
| Customers | 10,500 |
| Products | 1,600 |
| Orders | 10,000 |
| Order Items | 17,000 |
| Shipments | 10,000 |
| Returns & Refunds | 5,493 |

The data was cleaned and transformed before being loaded into MySQL for analysis.

---

# 🛠️ Tools & Technologies

### Python
- Pandas
- NumPy
- Jupyter Notebook

### SQL
- MySQL
- CTEs
- Aggregations
- CASE statements
- Window functions
- Joins
- Views
- Data validation

### Data Visualization
- Microsoft Power BI
- DAX
- Interactive slicers
- KPI cards
- Bar charts
- Donut charts
- Treemaps
- Matrix visualizations

### Version Control
- Git
- GitHub

---

# 🔄 Project Workflow

```text
Raw Dataset
     ↓
Python Data Cleaning
     ↓
Data Validation
     ↓
Clean CSV Files
     ↓
MySQL Database
     ↓
SQL Analysis & Validation
     ↓
Analytical SQL Views
     ↓
Power BI Data Model
     ↓
DAX Measures
     ↓
Interactive Dashboard
     ↓
Business Insights & Recommendations
