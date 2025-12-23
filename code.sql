-- Enriched Events Table
SELECT
e.visit_id,
e.cookie_id,
u.user_id,
e.page_id,
ph.page_name,
ph.product_category,
ph.product_id,
e.event_type,
ei.event_name,
e.sequence_number,
e.event_time
FROM events e
LEFT JOIN users u
ON e.cookie_id = u.cookie_id
LEFT JOIN event_identifier ei
ON e.event_type = ei.event_type
LEFT JOIN page_hierarchy ph
ON e.page_id = ph.page_id;

-- Total no of users
SELECT 
COUNT(DISTINCT user_id) AS user_count
FROM users;

-- Total number of distinct visits
SELECT 
COUNT(DISTINCT visit_id) AS visits 
FROM events;

-- Average Cookies per each user 
WITH cookie AS (
SELECT 
user_id, 
COUNT(cookie_id) AS cookie_id_count
FROM users
GROUP BY user_id)

SELECT 
ROUND(AVG(cookie_id_count),1) AS avg_cookie_id
FROM cookie;


-- Unique number of visits by all users per month
SELECT 
EXTRACT(MONTH FROM event_time) as month, 
COUNT(DISTINCT visit_id) AS unique_visit_count
FROM events
GROUP BY EXTRACT(MONTH FROM event_time);


-- Number of events for each event type
SELECT 
event_name, 
COUNT(*) AS event_count
FROM events e
JOIN event_identifier ei
ON ei.event_type = e.event_type
GROUP BY event_name
ORDER BY COUNT(*) DESC;


-- Percentage of visits which have a purchase event
SELECT 
100 * COUNT(DISTINCT e.visit_id)/
(SELECT COUNT(DISTINCT visit_id) FROM events) AS percentage_purchase
FROM events AS e
JOIN event_identifier AS ei
ON e.event_type = ei.event_type
WHERE ei.event_name = 'Purchase';

-- Top 3 pages by number of views
SELECT 
ph.page_name, 
ph.product_category,
COUNT(*) AS page_views
FROM events AS e
JOIN page_hierarchy AS ph
ON e.page_id = ph.page_id
WHERE e.event_type = 1
GROUP BY ph.page_name, ph.product_category
ORDER BY page_views DESC
LIMIT 3;

-- Product Funnel Analysis
SELECT 
ph.page_name,
ph.product_category, 
SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds,
SUM(CASE WHEN e.event_type = 3 THEN 1 ELSE 0 END) AS purchase
FROM events AS e
JOIN page_hierarchy AS ph
ON e.page_id = ph.page_id
WHERE ph.product_category IS NOT NULL
GROUP BY ph.page_name, ph.product_category
ORDER BY ph.product_category;

-- Drop Across Multiple stages
SELECT
ph.page_name,
ph.product_category,
COUNT(DISTINCT CASE WHEN e.event_type = 1 THEN e.visit_id END) AS views,
COUNT(DISTINCT CASE WHEN e.event_type = 2 THEN e.visit_id END) AS carts,
COUNT(DISTINCT CASE WHEN pv.visit_id IS NOT NULL THEN e.visit_id END) AS purchases,
COUNT(DISTINCT CASE WHEN e.event_type = 1 THEN e.visit_id END)
- COUNT(DISTINCT CASE WHEN e.event_type = 2 THEN e.visit_id END) AS view_drop,
COUNT(DISTINCT CASE WHEN e.event_type = 2 THEN e.visit_id END)
- COUNT(DISTINCT CASE WHEN pv.visit_id IS NOT NULL THEN e.visit_id END) AS cart_drop
FROM events e
JOIN page_hierarchy ph ON e.page_id = ph.page_id
LEFT JOIN (
SELECT DISTINCT visit_id FROM events WHERE event_type = 3
) pv ON e.visit_id = pv.visit_id
WHERE ph.product_category IS NOT NULL
GROUP BY ph.page_name, ph.product_category
ORDER BY  ph.product_category;

-- Category Funnel Analysis
WITH category_funnel as(
SELECT 
ph.product_category, 
SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds,
SUM(CASE WHEN e.event_type = 3 THEN 1 ELSE 0 END) AS purchase
FROM events AS e
JOIN page_hierarchy AS ph
ON e.page_id = ph.page_id
WHERE ph.product_category IS NOT NULL
GROUP BY ph.product_category
ORDER BY page_views DESC
)

SELECT * 
FROM category_funnel;

-- Conversion Rate for each Category
WITH category_funnel as(
SELECT 
ph.product_category, 
SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds,
SUM(CASE WHEN e.event_type = 3 THEN 1 ELSE 0 END) AS purchase
FROM events AS e
JOIN page_hierarchy AS ph
ON e.page_id = ph.page_id
WHERE ph.product_category IS NOT NULL
GROUP BY ph.product_category
ORDER BY page_views DESC
)

SELECT 
*, 
ROUND((100.0* cart_adds/page_views)::numeric, 2) as view_to_cart_conv,
ROUND((100.0* purchase/page_views)::numeric, 2) as view_to_purchase_conv
FROM category_funnel;

--- Average Funnel Depth
SELECT
ROUND(AVG(step_count), 2) AS avg_funnel_depth
FROM (
SELECT
visit_id,
COUNT(DISTINCT event_type) AS step_count
FROM events
WHERE event_type IN (1,2,3)
GROUP BY visit_id
) t;

-- campaign analysis
WITH user_funnel AS (
SELECT
visit_id,
MIN(event_time) AS visit_start_time,
SUM(CASE WHEN ei.event_name = 'Page View' THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN ei.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS cart_adds,
MAX(CASE WHEN ei.event_name = 'Purchase' THEN 1 ELSE 0 END) AS purchase
FROM events e
JOIN event_identifier ei
ON e.event_type = ei.event_type
GROUP BY visit_id
)

SELECT ci.campaign_name, COUNT(DISTINCT u.visit_id)
FROM user_funnel u
JOIN campaign_identifier ci
ON u.visit_start_time > ci.start_date
AND u.visit_start_time < ci.end_date
GROUP BY ci.campaign_name;

-- Conversion Rate by campaign
WITH visit_purchase AS (
SELECT DISTINCT visit_id
FROM events
WHERE event_type = 3
),
campaign_visits AS (
SELECT
u.visit_id,
ci.campaign_name,
ci.start_date,
ci.end_date
FROM (
SELECT visit_id, MIN(event_time) AS visit_start_time
FROM events
GROUP BY visit_id
) u
JOIN campaign_identifier ci
ON u.visit_start_time BETWEEN ci.start_date AND ci.end_date
)
SELECT
campaign_name,
(cv.end_date::date - cv.start_date::date) AS days,
COUNT(DISTINCT cv.visit_id) AS visits,
COUNT(DISTINCT vp.visit_id) AS purchases,
ROUND(100 * COUNT(DISTINCT vp.visit_id)::numeric
/ COUNT(DISTINCT cv.visit_id), 2) AS conversion_rate
FROM campaign_visits cv
LEFT JOIN visit_purchase vp
ON cv.visit_id = vp.visit_id
GROUP BY
campaign_name,
cv.start_date,
cv.end_date
ORDER BY conversion_rate DESC;

-- Product Affinity
SELECT
p1.page_name AS product_1,
p2.page_name AS product_2,
COUNT(*) AS times_viewed_together
FROM events e1
JOIN events e2
ON e1.visit_id = e2.visit_id
AND e1.page_id < e2.page_id
JOIN page_hierarchy p1 ON e1.page_id = p1.page_id
JOIN page_hierarchy p2 ON e2.page_id = p2.page_id
WHERE e1.event_type = 1
AND e2.event_type = 1
AND p1.product_category IS NOT NULL
AND p2.product_category IS NOT NULL
GROUP BY product_1, product_2
ORDER BY times_viewed_together DESC;

