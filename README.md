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

As we see the monthly revenue in the below query result, it is safe to say that there has been a rapid increase in revenue in the year 2017, going from just over R$100k in the first month of the year to our first R$1M+ in sales on the holiday month of November the same year. Looking at 2018, the sales have been consistently over R$1M except for the month of February at R$992k, which is not too far away from the R$1M mark.

The year 2018 did not see a great month-over-month increase in revenue as the year 2017 did, but it clocked sales of over R$1M+ consistently.
<img width="977" alt="Monthly revenue" src="https://github.com/user-attachments/assets/794fca5e-16f8-4719-a2e5-c78cbb7bf070" />

### Product Categories Performance:

There are a few categories that stand out when we look at the category wise sales. The top 3 categories in terms of sales are bed_bath_table, health_beauty, computer_accessories each having overall sales of over R$1.5M+ per category. This indicates strong and stable interest of customers which is often ties to repeatable purchases.
<br>
<img width="1015" alt="Top 10 categories by Sales" src="https://github.com/user-attachments/assets/894960dc-5d11-46f3-9f18-c2af78dab788" />

Electronics is often among the top-performing categories in terms of revenue on many major e-commerce platforms, While in Olist categories such as Computers, Electronics, Small Appliances, home_appliances which combinedly come under Electronics does not even have overall sales of R$1M dollars. 

### Shipping Delays

There have been extreme delay in delivery of orders among the sellers. If we look at the sellers that have delivered over 1000 order, the minimum average delay is atleast 9.6 days and maxing out at 13.1 days at the maximum. 

<img width="1015" alt="AVG delays by seller" src="https://github.com/user-attachments/assets/2c676d4a-1127-49d2-8088-66bfa7cc4060" />

If we take a look at the delivery delay for our top 10 categories by the number of orders, we can see that there is a consistent 11-12 day delay in delivery beyond the estimated date of delivery.

<img width="1015" alt="AVG delay by category" src="https://github.com/user-attachments/assets/342437fa-bce7-402b-a226-ae4eeef77089" />

# Recommendations

1. With average shipping delays ranging from 9.6 days to 13.1 days among the top-performing sellers, delivery performance is a clear bottleneck in customer experience.
   - Partnership with regional logistic providers to reduce the last-mile delivery delays.
   - Establish micro-fulfillment centers in regions with higher order volumes to reduce dispatch time and reducing overall delivery duration.
   - Introduce seller ranking by fulfillment efficiency. Offer incentives for consistent on-time deliveries and penalizing delays.
  
2. Promote cross-selling by recommending the top selling products alongside similar categories, which can uplift underperforming segments and increase overall cart value.
3. A pricing and listing analysis need to be conducted for the Electronics category ensuring alignment with market expectations. Consider running seasonal flash sales focused on Electronics to increase the sales.
4. With a rapid increase in revenue, inventory planning needs a structural forecast model, ensuring accurate predictions of seasonal spikes. Additionally colloborate with suppliers to balance inventory levels and avoid overstocking or stockouts.
