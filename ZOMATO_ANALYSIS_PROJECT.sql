DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup(userid INTEGER, gold_signup_date DATE);

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES 
(1, '2017-09-22'),
(3, '2017-04-21');

DROP TABLE IF EXISTS users;
CREATE TABLE users(userid INTEGER, signup_date DATE);

INSERT INTO users(userid, signup_date) 
VALUES 
(1, '2014-09-02'),
(2, '2015-01-15'),
(3, '2014-04-11');

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(userid INTEGER, created_date DATE, product_id INTEGER);

INSERT INTO sales(userid, created_date, product_id) 
VALUES 
(1, '2017-04-19', 2),
(3, '2019-12-18', 1),
(2, '2020-07-20', 3),
(1, '2019-10-23', 2),
(1, '2018-03-19', 3),
(3, '2016-12-20', 2),
(1, '2016-11-09', 1),
(1, '2016-05-20', 3),
(2, '2017-09-24', 1),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),
(3, '2016-11-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 2),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product(product_id INTEGER, product_name TEXT, price INTEGER);

INSERT INTO product(product_id, product_name, price) 
VALUES
(1, 'p1', 980),
(2, 'p2', 870),
(3, 'p3', 330);

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;

--what is the total amount each customer spent on zomato?
SELECT a.userid, sum(b.price) as total_amt_spent from sales a
INNER JOIN product b ON 
a.product_id=b.product_id
GROUP BY  a.userid 

--How many days has each customer visited zomato ?
SELECT userid,count(created_date)as distinct_days from sales
GROUP BY userid

--what was the first product purchased by each customer ?

SELECT* FROM(
SELECT *,
RANK() OVER (PARTITION BY userid ORDER BY created_date )AS rnk 
FROM sales)
WHERE rnk=1;

--what is the most purchased item on the menu and how many times was it purchased by all customers?(SELECT product_id
SELECT userid ,count(product_id) count_of_product FROM sales
WHERE product_id=(SELECT product_id FROM sales
GROUP BY product_id
ORDER BY count(product_id) desc
LIMIT 1)
GROUP BY userid

--which item is the most popular for each customer?
WITH ranked_sales AS (
    SELECT 
        userid, 
        product_id, 
        COUNT(*) AS purchase_count,
        RANK() OVER (PARTITION BY userid ORDER BY COUNT(*) DESC) AS rnk
    FROM sales
    GROUP BY userid, product_id
)
SELECT userid, product_id, purchase_count
FROM ranked_sales
WHERE rnk = 1;

--which items were purchased first by the customer after they became a member?
WITH purchases_after_membership AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date,
        g.gold_signup_date
    FROM sales s
    JOIN goldusers_signup g 
        ON s.userid = g.userid
    WHERE s.created_date >= g.gold_signup_date
),
ranked_purchases AS (
    SELECT *,
        RANK() OVER (PARTITION BY userid ORDER BY created_date ASC) AS rnk
    FROM purchases_after_membership
)
SELECT userid, product_id, created_date,gold_signup_date
FROM ranked_purchases
WHERE rnk = 1;

--which items were purchased by the customer just before they become a member?

WITH purchases_after_membership AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date,
        g.gold_signup_date
    FROM sales s
    JOIN goldusers_signup g 
        ON s.userid = g.userid
    WHERE s.created_date <= g.gold_signup_date
),
ranked_purchases AS (
    SELECT *,
        RANK() OVER (PARTITION BY userid ORDER BY created_date DESC) AS rnk
    FROM purchases_after_membership
)
SELECT userid, product_id, created_date,gold_signup_date
FROM ranked_purchases
WHERE rnk = 1;

--WHAT IS THE TOTAL ORDERS AND AMOUNT SPENT FOR EACH MEMBER BEFORE THEY BECAME A MEMBER?
DROP TABLE IF EXISTS goldusers_signup;
CREATE TABLE goldusers_signup(userid INTEGER, gold_signup_date DATE);

INSERT INTO goldusers_signup(userid, gold_signup_date) 
VALUES 
(1, '2017-09-22'),
(3, '2017-04-21');

DROP TABLE IF EXISTS users;
CREATE TABLE users(userid INTEGER, signup_date DATE);

INSERT INTO users(userid, signup_date) 
VALUES 
(1, '2014-09-02'),
(2, '2015-01-15'),
(3, '2014-04-11');

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(userid INTEGER, created_date DATE, product_id INTEGER);

INSERT INTO sales(userid, created_date, product_id) 
VALUES 
(1, '2017-04-19', 2),
(3, '2019-12-18', 1),
(2, '2020-07-20', 3),
(1, '2019-10-23', 2),
(1, '2018-03-19', 3),
(3, '2016-12-20', 2),
(1, '2016-11-09', 1),
(1, '2016-05-20', 3),
(2, '2017-09-24', 1),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),
(3, '2016-11-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 2),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3);

DROP TABLE IF EXISTS product;
CREATE TABLE product(product_id INTEGER, product_name TEXT, price INTEGER);

INSERT INTO product(product_id, product_name, price) 
VALUES
(1, 'p1', 980),
(2, 'p2', 870),
(3, 'p3', 330);

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;

--what is the total amount each customer spent on zomato?
SELECT a.userid, sum(b.price) as total_amt_spent from sales a
INNER JOIN product b ON 
a.product_id=b.product_id
GROUP BY  a.userid 

--How many days has each customer visited zomato ?
SELECT userid,count(created_date)as distinct_days from sales
GROUP BY userid

--what was the first product purchased by each customer ?

SELECT* FROM(
SELECT *,
RANK() OVER (PARTITION BY userid ORDER BY created_date )AS rnk 
FROM sales)
WHERE rnk=1;

--what is the most purchased item on the menu and how many times was it purchased by all customers?(SELECT product_id
SELECT userid ,count(product_id) count_of_product FROM sales
WHERE product_id=(SELECT product_id FROM sales
GROUP BY product_id
ORDER BY count(product_id) desc
LIMIT 1)
GROUP BY userid

--which item is the most popular for each customer?
WITH ranked_sales AS (
    SELECT 
        userid, 
        product_id, 
        COUNT(*) AS purchase_count,
        RANK() OVER (PARTITION BY userid ORDER BY COUNT(*) DESC) AS rnk
    FROM sales
    GROUP BY userid, product_id
)
SELECT userid, product_id, purchase_count
FROM ranked_sales
WHERE rnk = 1;

--which items were purchased first by the customer after they became a member?
WITH purchases_after_membership AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date,
        g.gold_signup_date
    FROM sales s
    JOIN goldusers_signup g 
        ON s.userid = g.userid
    WHERE s.created_date >= g.gold_signup_date
),
ranked_purchases AS (
    SELECT *,
        RANK() OVER (PARTITION BY userid ORDER BY created_date ASC) AS rnk
    FROM purchases_after_membership
)
SELECT userid, product_id, created_date,gold_signup_date
FROM ranked_purchases
WHERE rnk = 1;

--which items were purchased by the customer just before they become a member?

WITH purchases_after_membership AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date,
        g.gold_signup_date
    FROM sales s
    JOIN goldusers_signup g 
        ON s.userid = g.userid
    WHERE s.created_date <= g.gold_signup_date
),
total_amount_spent AS (
    SELECT p.*,pr.price 
	FROM purchases_after_membership p
	INNER JOIN 
	product pr ON p.product_id=pr.product_id
)
SELECT userid, 
count(created_date) AS TOTAL_PURCHASES,
sum(price) AS TOTAL_AMOUNT
FROM total_amount_spent
GROUP BY userid;

--if buying each product generates points for eg 5rs=2 Zomato point and each product has differenct purchasing points
-- for eg for p1 5rs=1 zomato point, for p2 10rs=5 zomato point and p3 5rs=1 zomato point,
--calculate points collected by each customer and for which product most points have been given till now.

WITH product_points AS (
    SELECT 
        product_id,
        CASE 
            WHEN product_id = 1 THEN (price / 5) * 1  -- p1: ₹5 = 1 point
            WHEN product_id = 2 THEN (price / 10) * 5 -- p2: ₹10 = 5 points
            WHEN product_id = 3 THEN (price / 5) * 1  -- p3: ₹5 = 1 point
        END AS points_per_purchase
    FROM product
),
customer_points AS (
    SELECT 
        s.userid, 
        s.product_id,
        COUNT(*) * p.points_per_purchase AS total_points
    FROM sales s
    JOIN product_points p 
        ON s.product_id = p.product_id
    GROUP BY s.userid, s.product_id, p.points_per_purchase
),
total_product_points AS (
    SELECT 
        product_id, 
        SUM(total_points) AS total_product_points
    FROM customer_points
    GROUP BY product_id
)
SELECT 
    c.userid, 
    c.product_id, 
    c.total_points, 
    (SELECT product_id FROM total_product_points ORDER BY total_product_points DESC LIMIT 1) AS most_rewarded_product
FROM customer_points c
ORDER BY c.userid, c.total_points DESC;


--In the first one year after  a customer joins the gold program (including their join date) irrespective 
--of what the customer has purchased they earn 5 zomato points for every 10 rs spent who earned more 1 or 3
--and what was their points earnings in their first yr? query this and explain in detail 

WITH first_year_sales AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date, 
        p.price, 
        g.gold_signup_date
    FROM sales s
    JOIN goldusers_signup g ON s.userid = g.userid
    JOIN product p ON s.product_id = p.product_id
    WHERE s.created_date BETWEEN g.gold_signup_date AND g.gold_signup_date + INTERVAL '1 year'

),
points_earned AS (
    SELECT 
        userid,
        SUM((price / 10) * 5) AS total_points
    FROM first_year_sales
    GROUP BY userid
)
SELECT * FROM points_earned;

--Rank all the transactions of the customers
SELECT 
    userid, 
    product_id, 
    created_date,
    RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rank_order
FROM sales;

--rnk all the transactions for each member whenever they are a zomato gold member for every non gold member mark as na 
WITH ranked_transactions AS (
    SELECT 
        s.userid, 
        s.product_id, 
        s.created_date, 
        g.gold_signup_date,
        CASE 
            WHEN g.userid IS NOT NULL AND s.created_date >= g.gold_signup_date 
            THEN CAST(RANK() OVER (PARTITION BY s.userid ORDER BY s.created_date) AS TEXT) 
            ELSE 'NA'
        END AS transaction_rank
    FROM sales s
    LEFT JOIN goldusers_signup g ON s.userid = g.userid
)
SELECT userid, product_id, created_date, gold_signup_date, transaction_rank
FROM ranked_transactions;
