/* CAPSTONE PROJECT:USAGE FUNNELS WITH WARBY PARKER
codecademy intensive course: Learn SQL from Scratch 
submitted by: Vladimir Kocic
date 06 July 2018*/

/*Please note that the SQL code follows the slide #heading# number (2.1, 2.2, 2.3 etc.)*/

/* 2.1 Quiz funnel*/
SELECT * FROM survey
LIMIT 10;

/* 2.2 Quiz funnel*/
SELECT 
	question as 'Questions',
	COUNT(DISTINCT user_id) AS 'N. of responses'
FROM survey
GROUP BY 1
ORDER BY 1 ASC;

/* 3.1 Home try-on funnnel*/
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* 3.2 Home try-on funnnel*/
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;

/* 3.3 Home try-on funnnel*/
WITH funnel AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT 
	COUNT(user_id) AS 'N. of Users',
  SUM(is_home_try_on) AS 'Home tries',
  SUM(is_purchase) AS 'Purchases'
FROM funnel;

/* 3.4 Home try-on funnnel*/
WITH funnel AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT 
	COUNT(user_id) AS 'N. of Users',
  SUM(is_home_try_on) AS 'Home tries',
  SUM(is_purchase) AS 'Purchases',
  1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'Quiz to Home try',
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'Home try to Purchase'
FROM funnel;

/* 3.5 Home try-on funnnel*/
WITH funnel AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT 
	number_of_pairs AS 'N. of pairs',
  COUNT(user_id) AS 'N. of Users',
  SUM(is_home_try_on) AS 'Home tries',
  SUM(is_purchase) AS 'Purchases',
  1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'Quiz to Home try',
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'Home try to Purchase'
FROM funnel
GROUP BY 1
ORDER BY 1 DESC;

/* 3.6 Home try-on funnnel*/
SELECT 
	style, 
  COUNT(user_id) 'n. of users'
FROM quiz 
GROUP BY 1
ORDER BY 2 DESC;

SELECT product_id, model_name, COUNT(user_id) AS 'N. of purchases'
FROM purchase
GROUP BY 1
ORDER BY 3 DESC;

/* 4. Insights*/
/*Conversion rates by style*/
WITH funnel AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase',
   q.style
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT 
	style AS 'Styles',
  COUNT(user_id) AS 'N. of Users',
  SUM(is_home_try_on) AS 'Home tries',
  SUM(is_purchase) AS 'Purchases',
  ROUND((1.0 * SUM(is_home_try_on) / COUNT(user_id))*100,2) AS 'Quiz to Home %',
   ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on))*100,2) AS 'Home try to Purchase %'
FROM funnel
GROUP BY 1
ORDER BY 1 DESC;
/* N. of purchases by price */
WITH funnel AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase',
   q.style,
	 p.price
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT 
	price AS 'Price',
  COUNT(user_id) AS 'N. of Users',
  SUM(is_home_try_on) AS 'Home tries',
  SUM(is_purchase) AS 'Purchases'
FROM funnel
WHERE price IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC;
/*EBITDA - highest earnings*/
SELECT product_id, model_name, style, COUNT(user_id) AS 'N. of purchases', price, 
COUNT(user_id) * price AS 'EBITDA'
FROM purchase
GROUP BY 1
ORDER BY 6 DESC;
/*EBITDA - highest n. of sold items*/
SELECT product_id, model_name, style, COUNT(user_id) AS 'N. of purchases', price, 
COUNT(user_id) * price AS 'EBITDA'
FROM purchase
GROUP BY 1
ORDER BY 4 DESC;
/*EBITDA - highest earning style+total sales*/
WITH ebitda AS (SELECT product_id, model_name, style, COUNT(user_id) AS 'N. of purchases', price, 
COUNT(user_id) * price AS 'EBITDA'
FROM purchase
GROUP BY 1)
SELECT 
style,
SUM(EBITDA) AS 'Total'
FROM ebitda
GROUP BY 1
ORDER BY 2 DESC;

WITH ebitda AS (SELECT product_id, model_name, style, COUNT(user_id) AS 'N. of purchases', price, 
COUNT(user_id) * price AS 'EBITDA'
FROM purchase
GROUP BY 1)
SELECT 
SUM(EBITDA) AS 'Total sales'
FROM ebitda;

