
/*
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'mavenfuzzyfactory'
ORDER BY 
    TABLE_NAME, ORDINAL_POSITION;
*/
    
    
SELECT * FROM website_sessions;


-- understanding which ad generates more orders and having high conversion rate

SELECT
	ws.utm_content,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT ws.website_session_id) AS CVR
FROM
	website_sessions ws
    LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE 
	ws.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- arbitrary date	
GROUP BY 1
ORDER BY 3 DESC;


/*
NEW MESSAGE
November 29, 2012

FROM: 		Tom Parmesan (Marketing Director)
SUBJECT:	Expanded Channel Portfolio

Hi there,
With gsearch doing well and the site performing better, we
launched a second paid search channel, bsearch, around
August 22.
Can you pull weekly trended session volume since then and
compare to gsearch nonbrand so I can get a sense for how
important this will be for the business?
Thanks, Tom

*/


SELECT 
	YEARWEEK(created_at) AS year_week,
    MIN(DATE (created_at)) AS min_week_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
    
FROM 
	website_sessions
    
WHERE 
	created_at > '2012-08-22' 
    AND created_at < '2012-11-29'
    AND utm_campaign = 'nonbrand'
    
GROUP BY
	1;
    
    
/* 
NEW MESSAGE
November 30, 2012

FROM: Tom Parmesan (Marketing Director)
SUBJECT: Comparing Our Channels

Hi there,
I'd like to learn more about the bsearch nonbrand campaign.
Could you please pull the percentage of traffic coming on
Mobile, and compare that to gsearch?
Feel free to dig around and share anything else you find
interesting. Aggregate data since August 22nd is great, no
need to show trending at this point.
Thanks, Tom
*/


SELECT 
	utm_source,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_session,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS per_mob_session
FROM
	website_sessions
WHERE
	created_at > '2012-08-22'
    AND created_at < '2012-11-30'
    AND utm_campaign = 'nonbrand' 
GROUP BY 
	1;
    
    
    
/*
NEW MESSAGE
December 01, 2012

FROM: Tom Parmesan (Marketing Director)
SUBJECT: Multi-Channel Bidding

Hi there,
I'm wondering if bsearch nonbrand should have the same
bids as gsearch. Could you pull nonbrand conversion rates
from session to order for gsearch and bsearch, and slice the
data by device type?
Please analyze data from August 22 to September 18; we
ran a special pre-holiday campaign for gsearch starting on
September 19th, so the data after that isn't fair game.
Thanks, Tom
*/

SELECT 
	ws.device_type,
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS oders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS CVR
    
FROM
	website_sessions ws
	LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE
	ws.created_at > '2012-08-22'
    AND ws.created_at < '2012-09-19'
	AND ws.utm_campaign = 'nonbrand'
    
GROUP BY
	1,2;
    
    
/*
NEW MESSAGE
December 22, 2012

FROM: Tom Parmesan (Marketing Director)
SUB: Impact of Bid Changes

Hi there,
Based on your last analysis, we bid down bsearch nonbrand or
December 2nd.
Can you pull weekly session volume for gsearch and bsearch
nonbrand, broken down by device, since November 4th?
If you can include a comparison metric to show bsearch as a
percent of gsearch for each device, that would be great too.
Thanks, Tom
*/

SELECT 
	YEARWEEK(created_at) AS year_week,
    MIN(DATE(created_at)) AS min_week_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS g_desktop_sesion,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS b_desktop_sesion,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS b_pct_of_g_dskt,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS g_mob_sesion,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS b_mob_sesion,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS b_pct_of_g_mob
        
FROM website_sessions

WHERE 
	created_at > '2012-11-4'
    AND created_at < '2012-12-23'
    AND utm_campaign = 'nonbrand'

GROUP BY
	1;