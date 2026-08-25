# Revenue Leakage Detection & E-commerce Operations Analytics

An End-to-end data analytics project identifying, quantifying, and visualizing revenue leakage across a 10,000-order e-commerce dataset. Built with Python (pandas) for data cleaning, SQL for analysis, and Power BI for an interactive dashboard.

---

## 🎯 Business Problem

E-commerce businesses lose revenue silently across the order lifecycle — failed deliveries, cancellations, returns, refunds  delivery issues, and operational inefficiencies. Simply looking at total sales does not reveal where these losses occur. This project traces that leakage end-to-end across a relational, multi-table order dataset to answer:
	- How much revenue is actually being lost, and where does it concentrate?
	- Which order statuses, payment methods, couriers, and regions drive the most leakage?
	- Are returns and refunds being processed efficiently, and at what operational cost?
     - Which products and customer segments carry the highest leakage risk?

---

## 🗂️ Dataset

The project uses a multi-table e-commerce dataset containing:

| Table | Records |
|---|---:|
| Customers[
Customer attributes — segment, repeat behavior, churn risk
] | 10,500 |
| Products[
Product catalog and pricing
] | 1,600 |
| Orders[
Core transactional data — order status, revenue, and leakage indicators
] | 10,000 |
| Order Items[
Line-item mapping between orders and products
] | 17,000 |
| Shipments[
Delivery operations — delays, attempts, failure reasons
] | 10,000 |
| Returns & Refunds[Post-delivery returns, refund status, and refund timelines] | 5,493 |

---

# 🛠️ Tools & Technologies

- Python (pandas) — data cleaning, validation, referential integrity checks
- SQL (MySQL) — aggregation, joins, window functions, reusable views
- Data Visualization(Microsoft Power BI) — 4-page interactive dashboard with DAX measures

