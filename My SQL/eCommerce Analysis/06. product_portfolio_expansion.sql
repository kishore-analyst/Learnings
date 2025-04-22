/*
NEW MESSAGE
January 12, 2014
Cindy Sharp (CEO)
From: Cindy Sharp (CEO)
Subject: Recent Product Launch

Good morning,
On December 12th 2013, we launched a third product
targeting the birthday gift market (Birthday Bear).
Could you please run a pre-post analysis comparing the
month before vs. the month after, in terms of session-to-
order conversion rate, AOV, products per order, and
revenue per session?
Thank you !
-Cindy
*/

select* from orders;

SELECT 
	CASE 
		WHEN ws.created_at < '2013-12-12' THEN 'A. pre_launch'
        WHEN ws.created_at >= '2013-12-12' THEN 'B. post_launch'
        ELSE 'ouchh not found'
	END AS time_period,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price_usd) AS total_revenue,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT ws.website_session_id) AS cvr,
    SUM(items_purchased) AS total_product_sold,
    SUM(items_purchased)/COUNT(DISTINCT order_id) AS product_per_order,
    SUM(price_usd)/COUNT(DISTINCT order_id) AS avg_order_value,
    SUM(price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session
FROM
	website_sessions ws
    LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id

WHERE
	ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'

GROUP BY 1