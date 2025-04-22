/*
Analyzing your branded or direct traffic is about keeping a pulse on how well
your brand is doing with consumers, and how well your brand drives business

COMMON USE CASES:

	# Identifying how much revenue you are
generating from direct traffic this is high
margin revenue without a direct cost of
customer acquisition

	# Understanding whether or not your paid
traffic is generating a "halo" effect, and
promoting additional direct traffic

	# Assessing the impact of various initiatives on
how many customers seek out your business

*/


/*
NEW MESSAGE
December 23, 2012

FROM: Cindy Sharp (CEO)
SUBJECT: Site traffic breakdown

Good morning,
A potential investor is asking if we're building any
momentum with our brand or if we'll need to keep relying
on paid traffic.
Could you pull organic search, direct type in, and paid
brand search sessions by month, and show those sessions
as a % of paid search nonbrand?
-Cindy
*/



SELECT DISTINCT
	utm_source,
    utm_campaign,
    http_referer
FROM
	website_sessions
WHERE
	created_at < '2012-12-24';
    
SELECT DISTINCT
	CASE
		WHEN utm_content IS NULL AND http_referer IS NULL THEN 'direct_search'
        WHEN utm_content IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        ELSE 'others'
	END AS channel_group,
    utm_campaign,
	utm_source,
    http_referer
FROM
	website_sessions
WHERE
	created_at < '2012-12-24';
    
SELECT 
	website_session_id,
    created_at,
	CASE
		WHEN utm_content IS NULL AND http_referer IS NULL THEN 'direct_search'
        WHEN utm_content IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        ELSE 'others'
	END AS channel_group
   
FROM
	website_sessions
WHERE
	created_at < '2012-12-24';
    
SELECT 
	MONTH(created_at) AS month,
    MIN(DATE(created_at)) AS min_month_date,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END) AS brand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS pct_brand_of_nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) AS organic_search,
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS pct_brand_of_organic,
	COUNT(DISTINCT CASE WHEN channel_group = 'direct_search' THEN website_session_id ELSE NULL END) AS direct_search,
	COUNT(DISTINCT CASE WHEN channel_group = 'direct_search' THEN website_session_id ELSE NULL END)		
		/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS pct_brand_of_direct
    
FROM (
	SELECT 
	website_session_id,
    created_at,
	CASE
		WHEN utm_content IS NULL AND http_referer IS NULL THEN 'direct_search'
        WHEN utm_content IS NULL AND http_referer IS NOT NULL THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        ELSE 'others'
	END AS channel_group
   
FROM
	website_sessions
WHERE
	created_at < '2012-12-24'
) AS channel_group

GROUP BY 1;
