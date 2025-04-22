/*
NEW MESSAGE
January 02, 2013

FROM: Cindy Sharp (CEO)
SUB: Understanding Seasonality

Good morning,
2012 was a great year for us. As we continue to grow, we
should take a look at 2012's monthly and weekly volume
patterns, to see if we can find any seasonal trends we
should plan for in 2013.
If you can pull session volume and order volume, that
would be excellent.
Thanks,
-Cindy
*/


-- understanding monthly sessions and order trend

SELECT 
	MONTH(ws.created_at) AS month,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM 
	website_sessions ws
    LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE
	ws.created_at < '2013-01-01'
GROUP BY
	1;
    
-- understanding weekly sessions and order trend

SELECT
	WEEK(ws.created_at) AS year_week,
    MIN(DATE(ws.created_at)) AS start_week_date,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders

FROM 
	website_sessions ws
    LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE
	ws.created_at < '2013-01-01'
GROUP BY
	1;
 
 /*
NEW MESSAGE
January 05, 2013

FROM: Cindy Sharp (CEO)
SUB: Data for Customer Service

Good morning,
We're considering adding live chat support to the website
to improve our customer experience. Could you analyze
the average website session volume, by hour of day and
by day week, so that we can staff appropriately?
Let's avoid the holiday time period and use a date range of
sep 15 - Nov 15, 2012.
Thanks, Cindy
*/

-- understanding the daywise and hour wise session in order indentify the high traffic period   

SELECT 
	hour,
    ROUND(AVG(sessions)) as avg_session,
    ROUND(AVG(CASE WHEN day = 0 THEN sessions ELSE NULL END)) AS mon,
    ROUND(AVG(CASE WHEN day = 1 THEN sessions ELSE NULL END)) AS tue,
    ROUND(AVG(CASE WHEN day = 2 THEN sessions ELSE NULL END)) AS wed,
    ROUND(AVG(CASE WHEN day = 3 THEN sessions ELSE NULL END)) AS thur,
    ROUND(AVG(CASE WHEN day = 4 THEN sessions ELSE NULL END)) AS fri,
    ROUND(AVG(CASE WHEN day = 5 THEN sessions ELSE NULL END)) AS sat,
    ROUND(AVG(CASE WHEN day = 6 THEN sessions ELSE NULL END)) AS sun
FROM (
SELECT 
	DATE(created_at) date,
    WEEKDAY(created_at) day,
    HOUR(created_at) hour,
    COUNT(DISTINCT website_session_id) AS sessions
    
FROM
	website_sessions
WHERE 
	created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3
) AS day_hour_sessions
GROUP BY 1
ORDER BY 1
;


