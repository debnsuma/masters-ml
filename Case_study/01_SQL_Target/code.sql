==========
Question 1
==========

---------
Part 1.1
---------
/*
Data type of columns in a table
*/

-- Uploading the data 
COPY target.public.customers FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/customers.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.geolocation FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/geolocation.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.order_items FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/order_items.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.order_reviews FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/order_reviews.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV ACCEPTINVCHARS DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.orders FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/orders.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.payments FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/payments.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.products FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/products.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

COPY target.public.sellers FROM 's3://dsml-redshift-dataset-us-east-1/dataset/target/sellers.csv' IAM_ROLE 'arn:aws:iam::507922848584:role/service-role/AmazonRedshift-CommandsAccessRole-20230315T165829' FORMAT AS CSV DELIMITER ',' QUOTE '"' IGNOREHEADER 1 REGION AS 'us-east-1'

--- Data types of columns 

-- Product column 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'products';

-- Orders column 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'orders';


---------
Part 1.2
---------
/*
Time period for which the data is given
*/

SELECT * 
FROM orders;

SELECT 
    MIN(order_purchase_timestamp) AS start_date,
    MAX(order_purchase_timestamp) AS last_date
FROM orders;

---------
Part 1.3
---------
/*
Cities and States of customers ordered during the given period
*/

SELECT * 
FROM orders;

SELECT * 
FROM customers;

SELECT  DISTINCT c.customer_city as city,  c.customer_state as state
FROM orders o
INNER JOIN customers c 
    ON o.customer_id = c.customer_id
ORDER BY state, city

==========
Question 2
==========

---------
Part 2.1
---------
/*
Is there a growing trend on e-commerce in Brazil? How can we describe a complete scenario? Can we see some seasonality with peaks at specific months?
*/

SELECT * 
FROM orders;

-- No. of orders in monthly baisis 

WITH A AS (
    SELECT 
        order_id, 
        order_purchase_timestamp, 
        EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM order_purchase_timestamp) AS month
    FROM orders
)

SELECT 
    year, 
    month, 
    COUNT(1) as no_of_orders,
    SUM(no_of_orders) OVER(PARTITION BY year ORDER BY month ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS rolling_monthly_sales_each_year
FROM A 
GROUP BY year, month
ORDER BY year, month

-- No. of orders year over year 

WITH A AS (
    SELECT 
        order_id, 
        order_purchase_timestamp, 
        EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM order_purchase_timestamp) AS month
    FROM orders
),

B AS (
    SELECT 
        A.*, 
        P.payment_value 
        FROM A 
        INNER JOIN 
            payments P 
            ON A.order_id = P.order_id
    ),

C AS (
    SELECT 
        year, 
        month, 
        SUM(payment_value) as total_sales
    FROM B 
    GROUP BY year, month
    ORDER BY year, month
)

SELECT 
    DISTINCT year, 
    SUM(total_sales) OVER(PARTITION BY year) AS total_sales, 
    AVG(total_sales) OVER(PARTITION BY year) AS avg_sales
FROM C 
ORDER BY year
----

---------
Part 2.2
---------

/*
What time do Brazilian customers tend to buy (Dawn, Morning, Afternoon or Night)?
*/

SELECT * 
FROM orders;

WITH A AS (
    SELECT 
        order_id,
        CASE 
            WHEN DATE_PART('hour', order_purchase_timestamp) >= 0 AND DATE_PART('hour', order_purchase_timestamp) < 6 THEN 'Dawn'
            WHEN DATE_PART('hour', order_purchase_timestamp) >= 6 AND DATE_PART('hour', order_purchase_timestamp) < 12 THEN 'Morning'
            WHEN DATE_PART('hour', order_purchase_timestamp) >= 12 AND DATE_PART('hour', order_purchase_timestamp) < 18 THEN 'Afternoon'
            ELSE 'Night' 
        END AS time_of_day 
    FROM orders 
) 

SELECT 
    time_of_day, 
    COUNT(1) AS no_of_orders,
    RANK() OVER(ORDER BY no_of_orders DESC) AS rank
FROM A 
GROUP BY time_of_day
ORDER BY no_of_orders DESC

==========
Question 3
==========
/*
Evolution of E-commerce orders in the Brazil region:
*/
---------
Part 3.1
---------
/*
Get month on month orders by states
*/

SELECT COUNT(*) 
FROM orders;

SELECT *
FROM orders;

SELECT * 
FROM customers;

SELECT * 
FROM payments;

SELECT COUNT(*) 
FROM payments;

-- Total sales month over month for each state 
WITH A AS (
    SELECT 
        o.order_id, 
        o.order_purchase_timestamp, 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        c.customer_city, 
        c.customer_state, 
        p.payment_value
    FROM orders o 
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN payments p ON o.order_id = p.order_id
)
SELECT 
   customer_state,
   year, 
   month,
   SUM(payment_value) AS total_Sales
FROM A
GROUP BY customer_state, year, month 
ORDER BY customer_state, year, month


-- Total sales month over month for each state with month over month total sales 

WITH A AS (
    SELECT 
        o.order_id, 
        o.order_purchase_timestamp, 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        c.customer_city, 
        c.customer_state, 
        p.payment_value
    FROM orders o 
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN payments p ON o.order_id = p.order_id
),
B AS (
        SELECT 
            customer_state,
            year, 
            month,
            SUM(payment_value) AS total_Sales
            FROM A
            GROUP BY customer_state, year, month 
            ORDER BY customer_state, year, month
)

SELECT 
    customer_state, 
    year, 
    month, 
    total_sales,
    SUM(total_sales) OVER(PARTITION BY customer_state ORDER BY year, month ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS rolling_monthly_sales

FROM B 
ORDER BY customer_state

---------
Part 3.2
---------
/*
Distribution of customers across the states in Brazil
*/

SELECT *
FROM orders;

SELECT * 
FROM customers;

-- No. of customers in different states in desending order
WITH A AS (
    SELECT 
        o.customer_id,
        c.customer_city, 
        c.customer_state
    FROM orders o 
    LEFT JOIN customers c ON o.customer_id = c.customer_id
)

SELECT 
    customer_state, 
    customer_city,
    COUNT(1) AS no_of_customers
FROM A
GROUP BY customer_state, customer_city
ORDER BY no_of_customers DESC

==========
Question 4
==========
/*
Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others.
*/
---------
Part 4.1
---------
/*
Get % increase in cost of orders from 2017 to 2018 (include months between Jan to Aug only) - You can use “payment_value” column in payments table
*/

SELECT *
FROM orders;

SELECT * 
FROM payments;

-- Month over month total sales from Jan 2017 to Sep 2018
WITH A AS (
    SELECT 
        o.order_id, 
        o.order_purchase_timestamp, 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        p.payment_value
    FROM orders o 
    LEFT JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01' AND 
          o.order_purchase_timestamp < '2018-09-01'
),
B AS (
        SELECT 
            year, 
            month,
            SUM(payment_value) AS total_Sales
            FROM A
            GROUP BY year, month 
            ORDER BY year, month
)

SELECT * 
FROM B;

-- % Increase of sales over year from Jan 2017 to Sep 2018
WITH A AS (
    SELECT 
        o.order_id, 
        o.order_purchase_timestamp, 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        p.payment_value
    FROM orders o 
    LEFT JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01' AND 
          o.order_purchase_timestamp < '2018-09-01'
),
B AS (
        SELECT 
            year, 
            SUM(payment_value) AS total_Sales
            FROM A
            GROUP BY year 
)

SELECT 
    *,
    ((total_Sales - LAG(total_Sales) OVER (ORDER BY year)) / LAG(total_Sales) OVER (ORDER BY year)) * 100 AS percentage_increase
FROM B
ORDER BY year

---------
Part 4.2
---------
/*
Mean & Sum of price and freight value by customer state
*/

SELECT *
FROM orders;

SELECT * 
FROM customers

SELECT * 
FROM order_items;

SELECT * 
FROM payments;

-- Mean & Sum of price and freight value by customer state
WITH A AS (
    SELECT o.order_id, o.customer_id, oi.freight_value, oi.price, c.customer_state
    FROM orders o 
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id
)

SELECT 
    customer_state, 
    SUM(freight_value) as total_freight_value, 
    AVG(freight_value) as avg_freight_value,
    SUM(price) as total_price, 
    AVG(price) as avg_price    
    FROM A
    GROUP BY customer_state
    ORDER BY customer_state


==========
Question 5
==========
/*
Analysis on sales, freight and delivery time
*/
---------
Part 5.1
---------
/*
Calculate days between purchasing, delivering and estimated delivery
*/

/* 
Calculate days between 
    - purchasing date and actual delivering date 
    - purchasing date and estimated delivery date
*/
SELECT 
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
    DATEDIFF(day, order_purchase_timestamp, order_estimated_delivery_date) AS days_to_estimated_delivery_from_day_of_purchase,
    CASE 
        WHEN days_to_actual_delivery_from_day_of_purchase <= days_to_estimated_delivery_from_day_of_purchase THEN 'YES'
    ELSE 'NO'
    END AS delivered_before_estimated_date

FROM orders 

---------
Part 5.2
---------
/*
Find time_to_delivery & diff_estimated_delivery. Formula for the same given below:

    - time_to_delivery = order_purchase_timestamp-order_delivered_customer_date
    - diff_estimated_delivery = order_estimated_delivery_date-order_delivered_customer_date
*/

SELECT 
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
    DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
    CASE 
        WHEN diff_between_estimated_delivery_and_actual_delivery >= 0  THEN 'YES'
    ELSE 'NO'
    END AS delivered_before_estimated_date

FROM orders 
ORDER BY order_id ;


---------
Part 5.3
---------
/*
Group data by state, take mean of freight_value, time_to_delivery, diff_estimated_delivery
*/

WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)

SELECT 
    customer_state,
    AVG(freight_value) AS avg_freight_value,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY customer_state

----------------
Part 5.4 to 5.7
----------------
/*
Sort the data to get the following:
    - Top 5 states with highest/lowest average freight value - sort in desc/asc limit 5
    - Top 5 states with highest/lowest average time to delivery
    - Top 5 states where delivery is really fast/ not so fast compared to estimated date
*/


-- Top 5 states with highest average freight value - sort in desc/asc limit 5
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)

SELECT 
    customer_state,
    AVG(freight_value) AS avg_freight_value,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY avg_freight_value DESC
LIMIT 5

-- Top 5 states with lowest average freight value - sort in desc/asc limit 5
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)

SELECT 
    customer_state,
    AVG(freight_value) AS avg_freight_value,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY avg_freight_value 
LIMIT 5

-- Top 5 states with highest average time to delivery

WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)

SELECT 
    customer_state,
    AVG(freight_value) AS avg_freight_value,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY mean_time_to_delivery DESC 
LIMIT 5

-- Top 5 states with lowest average time to delivery
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)

SELECT 
    customer_state,
    AVG(freight_value) AS avg_freight_value,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY mean_time_to_delivery 
LIMIT 5

-- Top 5 states where delivery is really fast/ not so fast compared to estimated date
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)


SELECT 
    customer_state,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY diff_estimated_delivery 
LIMIT 5

-- Top 5 states where delivery is really not so fast compared to estimated date
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date,
        DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date) AS days_to_actual_delivery_from_day_of_purchase,
        DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) AS diff_between_estimated_delivery_and_actual_delivery,
        c.customer_state,
        oi.freight_value

    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN customers c ON o.customer_id = c.customer_id

)


SELECT 
    customer_state,
    AVG(days_to_actual_delivery_from_day_of_purchase) AS mean_time_to_delivery,
    AVG(diff_between_estimated_delivery_and_actual_delivery) AS diff_estimated_delivery
FROM A
GROUP BY customer_state
ORDER BY diff_estimated_delivery DESC 
LIMIT 5 

==========
Question 6
==========
/*
Analysis on sales, freight and delivery time
*/
---------
Part 5.1
---------
/*
Payment type analysis:
 - Month over Month count of orders for different payment types
 - Count of orders based on the no. of payment installments
*/

-- Month over Month count of orders for different payment types 
SELECT * 
FROM orders;
SELECT * 
FROM payments
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        p.payment_type 
    FROM orders o 
    LEFT JOIN payments p ON o.order_id = p.order_id
)
SELECT 
    payment_type,
    year,
    month, 
    COUNT(1) AS no_of_orders
FROM A
GROUP BY payment_type, year, month 
ORDER BY payment_type, year, month

-- Count of orders based on the no. of payment installments
WITH A AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
        p.payment_type,
        p.payment_installments 
    FROM orders o 
    LEFT JOIN payments p ON o.order_id = p.order_id
)
SELECT 
    payment_installments,
    COUNT(1) AS no_of_orders
FROM A
GROUP BY payment_installments
ORDER BY payment_installments 
