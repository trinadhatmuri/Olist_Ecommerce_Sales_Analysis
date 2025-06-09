# Olist Ecommerce Sales Analysis
## Table of Contents
1. Background and overview.
2. Datastructure overview.
3. Executive summary.
4. Insights deep dive.
5. Recommendations.

## Background and Overview
The project aims to project an in-depth analysis of sales and operational performance using a public e-commerce dataset.

The dataset used is the Olist E-commerce public dataset that contains both transactional and logistical data from a multi-category online marketplace in Brazil. It contains orders, payment, shipping, product and review information giving us end-to-end visibility of how an e-commerce transaction lifecycle.

This project showcases end-to-end data engineering and analytics skills:
<ul>
  <li>Raw data ingestion using AWS S3</li>
  <li>ETL and transformation using snowflake</li>
  <li>Data Analysis with SQL</li>
  <li>Data visualization using powerBI</li>
</ul>

This project simulates a real-world business solution that can be used by stakeholders to monitor key business KPIs and identify improvements across operations, logistics and sales strategy.

The powerBI dashboard can be found here.

The dataset used can be downloaded <a href="https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce">here</a>

# Data Structure Overview
![datastructure](https://github.com/user-attachments/assets/c1701bea-9755-4a96-95b5-79a435bb6285)

# Executive Summary
The analysis reveals consistent revenue growth over time, driven by increase in demand with our high performing product categories such as bed_bath_table, health_beauty, computer_accessories. Despite the positive trend, shipping delays are noticeable across most of the regions, affecting the overall delivery performance. The customer review scores remain at a decent mark, indicating the customers are moderately satisfied. These insights highlight the immediate action to be taken to optimize logistics, while strategically planning future category expansions and market penetration efforts.

# Insights Deep Dive

### Revenue:

The overall revenue trend shows a consistent month-over-month growth, indicating increasing customer demand and order volumes. The revenue rose from R$7.2M in the year 2017 to an estimated revenue of R$10.4M in year 2018, representing a 44% year-over-year growth.

As we see the monthly revenue in the below query result, it is safe to say that there has been a rapid increase in revenue in the year 2017, going from just over R$100k in the first month of the year to our first R$1M+ in sales on the holiday month of November the same year. Looking at 2018, the sales have been consistently over R$1M except for the month of February at R$878k, which is not too far away from the R$1M mark. 
<img width="977" alt="Monthly revenue" src="https://github.com/user-attachments/assets/794fca5e-16f8-4719-a2e5-c78cbb7bf070" />
