/*SQL Data Analysis Questions & Queries1. Provide the list of markets in which customer "Atliq Exclusive" 
operates its business in the APAC region.*/
SELECT DISTINCT market
FROM dim_customer
WHERE customer = "Atliq Exclusive" 
  AND region = "APAC";
  
/*2. What is the percentage of unique product increase in 2021 vs. 2020?
Output Fields: unique_products_2020, unique_products_2021, percentage_chg*/

WITH cte1 AS (
    SELECT COUNT(DISTINCT product_code) AS unique_products_2020
    FROM fact_sales_monthly
    WHERE fiscal_year = "2020"
),
cte2 AS (
    SELECT COUNT(DISTINCT product_code) AS unique_products_2021
    FROM fact_sales_monthly
    WHERE fiscal_year = "2021"
)
SELECT 
    p1.unique_products_2020,
    p2.unique_products_2021,
    ROUND(((p2.unique_products_2021 - p1.unique_products_2020) / p1.unique_products_2020) * 100, 2) AS percentage_chg
FROM cte1 p1
CROSS JOIN cte2 p2;


/*3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
Output Fields: segment, product_count*/

SELECT 
    segment,
    COUNT(DISTINCT product_code) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;

/*4. Which segment had the most increase in unique products in 2021 vs 2020?
Output Fields: segment, product_count_2020, product_count_2021, difference*/

WITH count_2020 AS (
    SELECT 
        p1.segment,
        COUNT(DISTINCT fs1.product_code) AS products_count_2020
    FROM fact_sales_monthly fs1
    JOIN dim_product p1 ON fs1.product_code = p1.product_code
    WHERE fs1.fiscal_year = "2020"
    GROUP BY p1.segment
),
count_2021 AS (
    SELECT 
        p2.segment,
        COUNT(DISTINCT fs2.product_code) AS products_count_2021
    FROM fact_sales_monthly fs2
    JOIN dim_product p2 ON fs2.product_code = p2.product_code
    WHERE fs2.fiscal_year = "2021"
    GROUP BY p2.segment
)
SELECT 
    c1.segment,
    c1.products_count_2020,
    c2.products_count_2021,
    (c2.products_count_2021 - c1.products_count_2020) AS difference
FROM count_2020 c1
JOIN count_2021 c2 ON c1.segment = c2.segment
ORDER BY difference DESC
LIMIT 1;

/*5. Get the products that have the highest and lowest manufacturing costs.
Output Fields: product_code, product, manufacturing_cost*/

WITH cost_extremes AS (
    SELECT 
        MAX(manufacturing_cost) AS max_cost,
        MIN(manufacturing_cost) AS min_cost
    FROM fact_manufacturing_cost
)
SELECT 
    p.product_code,
    p.product,
    mc.manufacturing_cost
FROM dim_product p
JOIN fact_manufacturing_cost mc 
    ON p.product_code = mc.product_code
JOIN cost_extremes ce 
    ON mc.manufacturing_cost IN (ce.max_cost, ce.min_cost);
    
    
/*6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct 
for the fiscal year 2021 and in the Indian market.
Output Fields: customer_code, customer, average_discount_percentage*/

SELECT 
    c.customer_code,
    c.customer,
    ROUND(AVG(id.pre_invoice_discount_pct) * 100, 2) AS average_discount_percentage
FROM dim_customer c
JOIN fact_pre_invoice_deductions id 
    ON c.customer_code = id.customer_code
WHERE id.fiscal_year = "2021" 
  AND c.market = "India"
GROUP BY c.customer_code, c.customer
ORDER BY average_discount_percentage DESC
LIMIT 5;


/*7. Get the complete report of the Gross sales amount for the customer "Atliq Exclusive" for each month.
Output Fields: Month, Year, Gross sales Amount*/

SELECT
    MONTH(sm.date) AS month,
    YEAR(sm.date) AS year,
    ROUND(SUM(gp.gross_price * sm.sold_quantity), 2) AS Gross_sales_Amount
FROM dim_customer c
JOIN fact_sales_monthly sm 
    ON c.customer_code = sm.customer_code
JOIN fact_gross_price gp 
    ON sm.product_code = gp.product_code
    AND sm.fiscal_year = gp.fiscal_year
WHERE c.customer = "Atliq Exclusive"
GROUP BY year, month
ORDER BY year, month;

/*8. In which quarter of 2020 did we get the maximum total_sold_quantity?
Output Fields: Quarter, total_sold_quantity*/

WITH sales_with_quarter AS (
    SELECT 
        CASE 
            WHEN MONTH(date) IN (9, 10, 11) THEN "Q1"
            WHEN MONTH(date) IN (12, 1, 2) THEN "Q2"
            WHEN MONTH(date) IN (3, 4, 5) THEN "Q3"
            WHEN MONTH(date) IN (6, 7, 8) THEN "Q4"
        END AS Quarter,
        sold_quantity
    FROM fact_sales_monthly
    WHERE fiscal_year = "2020"
)
SELECT 
    Quarter,
    SUM(sold_quantity) AS total_sold_quantity
FROM sales_with_quarter
GROUP BY Quarter
ORDER BY total_sold_quantity DESC;

/*9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
Output Fields: channel, gross_sales_mln, percentage*/

WITH channel_gross_sale AS (
    SELECT 
        c.channel,
        SUM(gp.gross_price * sm.sold_quantity) AS gross_sale
    FROM dim_customer c 
    JOIN fact_sales_monthly sm 
        ON c.customer_code = sm.customer_code
    JOIN fact_gross_price gp 
        ON sm.product_code = gp.product_code
        AND sm.fiscal_year = gp.fiscal_year
    WHERE sm.fiscal_year = "2021"
    GROUP BY c.channel
)
SELECT 
    channel,
    ROUND(gross_sale / 1000000, 2) AS gross_sales_mln,
    ROUND((gross_sale / SUM(gross_sale) OVER()) * 100, 2) AS percentage
FROM channel_gross_sale
ORDER BY gross_sale DESC;


/*10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021.
Output Fields: division, product_code, product, total_sold_quantity, rank_order*/

WITH division_sold_quantity AS (
    SELECT 
        p.division,
        p.product_code,
        p.product,
        SUM(sm.sold_quantity) AS total_sold_quantity
    FROM dim_product p 
    JOIN fact_sales_monthly sm 
        ON p.product_code = sm.product_code
    WHERE sm.fiscal_year = "2021"
    GROUP BY p.division, p.product_code, p.product
),
ranked_product AS (
    SELECT 
        division,
        product_code,
        product,
        total_sold_quantity,
        RANK() OVER(PARTITION BY division ORDER BY total_sold_quantity DESC) AS rank_order
    FROM division_sold_quantity
)
SELECT 
    division,
    product_code,
    product,
    total_sold_quantity,
    rank_order
FROM ranked_product
WHERE rank_order <= 3
ORDER BY division, rank_order;
