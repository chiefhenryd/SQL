 /*SELECT
  s.customer_id,
  SUM(m.price) AS total_spent
FROM
  sales s
JOIN
  menu m ON s.product_id = m.product_id
GROUP BY
  s.customer_id;

SELECT
customer_id, 
COUNT(DISTINCT order_date) AS days_visited
FROM
sales
GROUP BY
customer_id

/* What was the first item from the menu purchased by each customer? */

/*
WITH RankedSales AS (
  SELECT
    s.customer_id,
    m.product_name,
    ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS row_num
  FROM
    sales s
  JOIN
    menu m ON s.product_id = m.product_id
)
SELECT
  customer_id,
  product_name
FROM
  RankedSales
WHERE
  row_num = 1;
*/

/* What is the most purchased item on the menu and how many times was it purchased by all customers? */
/*
SELECT
  m.product_name,
  COUNT(s.product_id) AS times_purchased
FROM
  sales s
JOIN
  menu m ON s.product_id = m.product_id
GROUP BY
  m.product_name
ORDER BY
  times_purchased DESC
LIMIT 1;
*/

/*Which item was the most popular for each customer? */

/*
SELECT
  s.customer_id,
  m.product_name,
  COUNT(s.product_id) AS purchase_count
FROM
  sales s
JOIN
  menu m ON s.product_id = m.product_id
GROUP BY
  s.customer_id, m.product_name
ORDER BY
  s.customer_id, purchase_count DESC;
*/

/*Which item was purchased first by the customer after they became a member?*/
/*
WITH RankedPurchases AS (
  SELECT
    s.customer_id,
    m.product_name,
    s.order_date,
    ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS row_num
  FROM
    sales s
  JOIN
    members mb ON s.customer_id = mb.customer_id
  JOIN
    menu m ON s.product_id = m.product_id
  WHERE
    s.order_date >= mb.join_date
)
SELECT
  customer_id,
  product_name,
  order_date AS first_purchase_after_join
FROM
  RankedPurchases
WHERE
  row_num = 1
ORDER BY
  customer_id;
*/

/* Which item was purchased just before the customer became a member? 

SELECT
  s.customer_id,
  m.product_name,
  MAX(s.order_date) AS last_purchase_before_join
FROM
  sales s
JOIN
  members mb ON s.customer_id = mb.customer_id
JOIN
  menu m ON s.product_id = m.product_id
WHERE
  s.order_date < mb.join_date
GROUP BY
  s.customer_id, m.product_name
ORDER BY
  s.customer_id, last_purchase_before_join DESC;
  
  */

/* What is the total items and amount spent for each member before they became a member? 

SELECT
  s.customer_id,
  COUNT(s.product_id) AS total_items,
  SUM(m.price) AS total_spent
FROM
  sales s
JOIN
  members mb ON s.customer_id = mb.customer_id
JOIN
  menu m ON s.product_id = m.product_id
WHERE
  s.order_date < mb.join_date
GROUP BY
  s.customer_id;

*/

/* If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
how many points would each customer have?

SELECT
  s.customer_id,
  SUM(
    CASE
      WHEN m.product_name = 'sushi' THEN m.price * 20
      ELSE m.price * 10
    END
  ) AS total_points
FROM
  sales s
JOIN
  menu m ON s.product_id = m.product_id
GROUP BY
  s.customer_id;

*/

/* In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January? */

SELECT
  s.customer_id,
  SUM(
    CASE
      WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
      THEN m.price * 20
      ELSE
        CASE
          WHEN m.product_name = 'sushi' THEN m.price * 20
          ELSE m.price * 10
        END
    END
  ) AS total_points
FROM
  sales s
JOIN
  members mb ON s.customer_id = mb.customer_id
JOIN
  menu m ON s.product_id = m.product_id
WHERE
  s.order_date <= '2021-01-31'
GROUP BY
  s.customer_id;


