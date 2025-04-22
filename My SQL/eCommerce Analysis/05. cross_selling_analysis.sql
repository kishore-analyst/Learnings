
-- finding cross selling products - bredown down by primary_product_id

SELECT * 
FROM orders 
WHERE order_id BETWEEN 10000 AND 11000;

SELECT * 
FROM order_items
WHERE order_id BETWEEN 10000 AND 11000;


SELECT 
	o.order_id,
    o.primary_product_id,
    oi.product_id
FROM 
	orders o
	LEFT JOIN order_items oi
		ON oi.order_id = o.order_id
        AND is_primary_item = 0 -- cross sale products

WHERE 
	o.order_id BETWEEN 10000 AND 11000;
    
    
SELECT
	primary_product_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_id ELSE NULL END) AS x_selling_prdt1,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_id ELSE NULL END) AS x_selling_prdt2,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_id ELSE NULL END) AS x_selling_prdt3,
    
    ROUND(COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_id ELSE NULL END)*100/COUNT(DISTINCT order_id),2) AS x_selling_prdt1_rt,
    ROUND(COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_id ELSE NULL END)*100/COUNT(DISTINCT order_id),2) AS x_selling_prdt2_rt,
    ROUND(COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_id ELSE NULL END)*100/COUNT(DISTINCT order_id),2) AS x_selling_prdt3_rt
FROM (
	SELECT 
	o.order_id,
    o.primary_product_id,
    oi.product_id
FROM 
	orders o
	LEFT JOIN order_items oi
		ON oi.order_id = o.order_id
        AND is_primary_item = 0 -- cross sale products

WHERE 
	o.order_id BETWEEN 10000 AND 11000
) AS orders_w_x_selling_prdt

GROUP BY 1;


/*
NEW MESSAGE
November 22, 2013

From: Cindy Sharp (CEO)
Subject: Cross-Selling Performance

Good morning,
On September 25th we started giving customers the option
to add a 2nd product while on the /cart page. Morgan says
this has been positive, but I'd like your take on it.

Could you please compare the month before vs the month
after the change? I'd like to see CTR from the /cart page,
Avg Products per Order, AOV, and overall revenue per
/cart page view.
Thanks, Cindy
*/

-- CROSS SELL ANALYSIS

-- STEP 1: Identify the relevant /cart page views and their sessions
-- STEP 2: See which of those /cart sessions clicked through to the shipping page
-- STEP 3: Find the orders associated with the /cart sessions. Analyze products purchased,AOV
-- STEP 4: Aggregate and analyze a summary of our findings 

-- STEP 1: Identify the relevant / cart page views and their sessions

CREATE TEMPORARY TABLE session_seeing_cart
SELECT 
	CASE 
		WHEN created_at > '2013-09-25' THEN 'A. pre_cross_sell'
        WHEN created_at < '2013-09-25' THEN 'B. post_cross_sell'
        ELSE 'NOT FOUND'
	END AS time_period,
    website_session_id,
    website_pageview_id
    
FROM
	website_pageviews
WHERE 
	created_at BETWEEN '2013-08-25' AND '2013-10-25'
    AND pageview_url = '/cart';
    

-- STEP 2: See which of those /cart sessions clicked through to the shipping page

-- select * from website_pageviews;

CREATE TEMPORARY TABLE cart_sessions_seeing_another_page
SELECT
	r.time_period,
    r.website_session_id,
    MIN(w.website_pageview_id) AS next_to_cart
FROM 
	session_seeing_cart r
    LEFT JOIN website_pageviews w
		ON w.website_session_id = r.website_session_id
        AND w.website_pageview_id > r.website_pageview_id
GROUP BY 1,2
HAVING 
	MIN(w.website_pageview_id) IS NOT NULL;
    

CREATE TEMPORARY TABLE pre_post_sessions_orders
SELECT
	time_period,
	s.website_session_id,
    order_id,
    items_purchased,
    price_usd
FROM session_seeing_cart s
	INNER JOIN orders o
		ON o.website_session_id = s.website_session_id;
        

SELECT 
  session_seeing_cart.time_period,
  CASE 
    WHEN cart_sessions_seeing_another_page.website_session_id IS NULL THEN 0 
    ELSE 1 
  END AS clicked_to_another_page,
  CASE 
    WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 
    ELSE 1 
  END AS placed_order,
  pre_post_sessions_orders.items_purchased,
  pre_post_sessions_orders.price_usd
FROM session_seeing_cart
LEFT JOIN cart_sessions_seeing_another_page
  ON session_seeing_cart.website_session_id = cart_sessions_seeing_another_page.website_session_id
LEFT JOIN pre_post_sessions_orders
  ON session_seeing_cart.website_session_id = pre_post_sessions_orders.website_session_id
ORDER BY session_seeing_cart.website_session_id;


SELECT 
	time_period,
    COUNT(DISTINCT website_session_id) AS cart_sessions,
    SUM(clicked_to_another_page) AS clickthroughs,
    SUM(clicked_to_another_page)/SUM(clicked_to_another_page) AS click_thr_rate,
	SUM(placed_order) AS orders_placed,
	SUM(items_purchased) AS products_purchased,
	SUM(items_purchased)/SUM(placed_order)	AS products_per_order,
	SUM(price_usd) AS revenue,
	SUM(price_usd)/SUM(placed_order) AS aov,
	SUM(price_usd)/COUNT(DISTINCT website_session_id) AS rev_per_cart_session
    
    
FROM (
	SELECT 
	session_seeing_cart.time_period,
	session_seeing_cart.website_session_id,
	CASE 
		WHEN cart_sessions_seeing_another_page.website_session_id IS NULL THEN 0 
		ELSE 1 
	END AS clicked_to_another_page,
	CASE 
		WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 
		ELSE 1 
	END AS placed_order,
	pre_post_sessions_orders.items_purchased,
	pre_post_sessions_orders.price_usd
	FROM session_seeing_cart
	LEFT JOIN cart_sessions_seeing_another_page
		ON session_seeing_cart.website_session_id = cart_sessions_seeing_another_page.website_session_id
	LEFT JOIN pre_post_sessions_orders
		ON session_seeing_cart.website_session_id = pre_post_sessions_orders.website_session_id
	ORDER BY session_seeing_cart.website_session_id
) AS full_data

GROUP BY 1;
