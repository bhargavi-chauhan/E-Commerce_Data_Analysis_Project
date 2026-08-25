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
| Customers[Customer attributes — segment, repeat behavior, churn risk] | 10,500 |
| Products[Product catalog and pricing] | 1,600 |
| Orders[Core transactional data — order status, revenue, and leakage indicators] | 10,000 |
| Order Items[Line-item mapping between orders and products] | 17,000 |
| Shipments[Delivery operations — delays, attempts, failure reasons] | 10,000 |
| Returns & Refunds[Post-delivery returns, refund status, and refund timelines] | 5,493 |

---

# 🛠️ Tools & Technologies

- Python (pandas) — data cleaning, validation, referential integrity checks
- SQL (MySQL) — aggregation, joins, window functions, reusable views
- Data Visualization(Microsoft Power BI) — 4-page interactive dashboard with DAX measures

---

## 📊 Dashboard Preview

The final Power BI Report contains four interactive analytical pages:

1. **Executive Overview**
![Executive Overview](screenshot/1-Executive_Overview.png)
High-level view of the leakage problem. 10,000 orders, ₹555.82M total order value, ₹53.38M revenue loss, 9.60% leakage rate. 99.5% of revenue loss traces to Failed orders. Credit Card has the highest payment-method failure rate (10.48%) vs. COD, the lowest (8.87%).
2. **Shipment & Courier Performance**
![Shipment & Courier Performance](screenshot/.png)
Operational view of delivery performance. 61.37% overall delivery success rate, 6,000 late shipments. Courier Delay is by far the top failure reason (~1,000 shipments) vs. ~400 each for other causes. The failure-rate-vs-delay scatter shows courier performance is fairly tight-banded (10.2%–11.0% failure, 3.45–3.57 avg delay days) — no single courier is a dramatic outlier in either direction.
3. **Returns & Refunds**
![Returns & Refunds](screenshot/.png)
5,493 return cases, ₹133.85M in total refunds, of which 79.9% are already processed and 15.3% still pending. Customer Refused (2,308 cases, ₹61.1M) and Late Delivery (1,937 cases, ₹52.98M) together account for the large majority of both return volume and refund value — a clear signal that delivery reliability and last-mile communication, not product quality, are the primary return drivers.
4. **Product & Customer Leakage**
![Product & Customer Leakage](screenshot/.png)
2,000 leakage orders, ₹26.51K average loss per leakage order. Laptops and Mobiles dominate product-level leakage — the top 10 loss-driving products are almost entirely laptops (Apple MacBook, HP Victus/Omen) plus one phone. Leakage is fairly evenly spread across churn-risk tiers (33–35% each in High/Medium/Low) rather than concentrated in high-churn customers, but High Value customers account for by far the largest share of leakage in absolute rupee terms (~₹40M vs. ~₹12M for At Risk and near-zero for New/Returning).


