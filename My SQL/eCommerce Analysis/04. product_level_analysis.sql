-- understanding the product's - revenue, margin, aov, and orders

SELECT 
	primary_product_id AS product_id,
    COUNT(DISTINCT order_id) AS orders,
    SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin,
    AVG(price_usd) AS aov
FROM 
	orders
WHERE 
	order_id  BETWEEN '10000' AND '11000'
GROUP BY
	1;
    


/*
NEW MESSAGE
January 04, 2013

FROM: Cindy Sharp (CEO)
SUB: Sales Trends

Good morning,
We're about to launch a new product, and I'd like to do a
deep dive on our current flagship product.
Can you please pull monthly trends to date for number of
sales, total revenue, and total margin generated for the
business?
-Cindy
*/

-- PRODUCT LEVEL SALES ANALYSIS

SELECT 
	YEAR(created_at) AS year,
	MONTH(created_at) AS month,
	COUNT(order_id) AS sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
    
FROM
	orders
WHERE
	created_at < '2013-01-04'
GROUP BY 1,2
ORDER BY 1,2 ;

/*
NEW MESSAGE
April 05, 2013

From: Cindy Sharp (CEO)
Subject: Impact of New Product Launch

Good morning,
We launched our second product back on January 6th. Can
you pull together some trended analysis?
I'd like to see monthly order volume, overall conversion
rates, revenue per session, and a breakdown of sales by
product, all for the time period since April 1, 2012.
Thanks,
-Cindy
*/

-- ANALYSING PRODDUCT LAUNCH

SELECT
	YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(DISTINCT CASE WHEN o.primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_sales,
	COUNT(DISTINCT CASE WHEN o.primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_sales,
    COUNT(DISTINCT ws.website_session_id) / COUNT(DISTINCT o.order_id) AS cvr,
    SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS rev_per_session

FROM 
	website_sessions ws
    LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
        
WHERE 
	ws.created_at > '2012-04-01'
    AND ws.created_at < '2013-04-01'
	
GROUP BY 1,2

ORDER BY 1,2;



/*
NEW MESSAGE
April 06, 2013

From: Morgan Rockwell (Website Manager)
Subject: Help w/ User Pathing

Hi there!
Now that we have a new product, I'm thinking about our
user path and conversion funnel. Let's look at sessions which
hit the /products page and see where they went next.
Could you please pull clickthrough rates from /products
since the new product launch on January 6th 2013, by
product, and compare to the 3 months leading up to launch
as a baseline?
Thanks, Morgan
*/


-- Step 1: find the relevant /products pageviews with website_session_id
-- Step 2: find the next pageview id that occurs AFTER the product pageview
-- Step 3: find the pageview_url associated with any applicable next pageview id
-- Step 4: summarize the data and analyze the pre vs post periods

-- Step 1: find the relevant /products pageviews with website_session_id

SELECT * FROM website_sessions;
SELECT * FROM website_pageviews;

CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id, 
    website_pageview_id,	
    created_at,
    CASE 
		WHEN created_at < '2013-01-06' THEN 'A.pre_product_2'
        WHEN created_at >= '2013-01-06' THEN 'B.post_product_2'
        ELSE 'not found'
	END AS time_period
FROM 
	website_pageviews

WHERE 
	created_at > '2012-10-06'
    AND created_at < '2013-04-06'
	AND pageview_url = '/products';

-- Step 2: find the next pageview id that occurs AFTER the product pageview

CREATE TEMPORARY TABLE sess_w_next_pageviews_id
SELECT 
	fp.time_period,
    fp.website_session_id,
    MIN(ws.website_pageview_id) min_next_pageview
FROM
	first_pageview fp
	LEFT JOIN website_pageviews ws
		ON ws.website_session_id = fp.website_session_id
        AND ws.website_pageview_id > fp.website_pageview_id
GROUP BY 1,2;


-- Step 3: find the pageview_url associated with any applicable next pageview id

CREATE TEMPORARY TABLE sess_w_next_pageurl
SELECT 
	s.time_period,
    s.website_session_id,
    wp.pageview_url
FROM
	sess_w_next_pageviews_id s
	LEFT JOIN website_pageviews wp
		ON wp.website_pageview_id = s.min_next_pageview;


-- Step 4: summarize the data and analyze the pre vs post periods

SELECT
	 time_period,
     COUNT(DISTINCT website_session_id) AS total_sessions,
     COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS total_pageview_url,
     COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT website_session_id) AS prct_url_to_session,
     COUNT(DISTINCT CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_fuzzy,
     COUNT(DISTINCT CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT website_session_id) AS prct_to_fuzzy,
     COUNT(DISTINCT CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_fuzzy,
     COUNT(DISTINCT CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT website_session_id) AS prct_to_forever
FROM
	sess_w_next_pageurl

GROUP BY 1;



/*
NEW MESSAGE
April 10, 2014

From: Morgan Rockwell (Website Manager)
Subject: Product Conversion Funnels

Hi there!
I'd like to look at our two products since January 6th and
analyze the conversion funnels from each product page to
conversion.
It would be great if you could produce a comparison between
the two conversion funnels, for all website traffic.
Thanks!
-Morgan
 */

-- BUILDING PRODUCT CONVERSION FUNNEL

-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: figure out which pageview ur Is to look for
-- STEP 3: pull all pageviews and identify the funnel steps
-- STEP 4: create the session—level conversion funnel view
-- STEP 5-: aggregate the data to assess funnel performance


-- STEP 1: select all pageview_id from relevant sessions

-- CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT
	website_session_id,
    website_pageview_id, 
    pageview_url
FROM
	website_pageviews
WHERE
	created_at > '2013-01-06'
	AND created_at < '2013-04-10'
	AND pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear');

-- STEP 2: figure which page url to look for

SELECT
	DISTINCT wp.pageview_url
FROM 
	sessions_seeing_product_pages s
	LEFT JOIN website_pageviews wp
		ON wp.website_session_id = s.website_session_id
        AND wp.website_pageview_id > s.website_pageview_id;
        
-- STEP 3: pull all pageviews and identify the funnel steps

CREATE TEMPORARY TABLE flagged_session
SELECT	
	s.website_session_id,
    CASE
		WHEN s.pageview_url = '/the-original-mr-fuzzy' THEN 'mr_fuzzy'
        WHEN s.pageview_url = '/the-forever-love-bear' THEN 'forever'
        ELSE 'invalid'
	END AS product_seen,
    MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart,
    MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping,
    MAX(CASE WHEN wp.pageview_url = '/billing-2' THEN 1 ELSE 0 END) AS billing,
    MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thank_you
FROM
	sessions_seeing_product_pages  s
    LEFT JOIN website_pageviews wp
		ON wp.website_session_id = s.website_session_id
		AND wp.website_pageview_id > s.website_pageview_id

GROUP BY 1,2;

-- finding the funnel of each url page

SELECT 
	product_seen,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN cart = 1 THEN website_session_id ELSE NULL END) AS cart_made_it,
    COUNT(DISTINCT CASE WHEN shipping = 1 THEN website_session_id ELSE NULL END) AS shipping_made_it,
    COUNT(DISTINCT CASE WHEN billing = 1 THEN website_session_id ELSE NULL END) AS billing_made_it,
    COUNT(DISTINCT CASE WHEN thank_you = 1 THEN website_session_id ELSE NULL END) AS thank_you_made_it
FROM
	flagged_session
    
GROUP BY 1;

-- finding the click through rate

SELECT 
	product_seen,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS cart_made_it,
    COUNT(DISTINCT CASE WHEN shipping = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart = 1 THEN website_session_id ELSE NULL END) AS shipping_made_it,
    COUNT(DISTINCT CASE WHEN billing = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping = 1 THEN website_session_id ELSE NULL END) AS billing_made_it,
    COUNT(DISTINCT CASE WHEN thank_you = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing = 1 THEN website_session_id ELSE NULL END) AS thank_you_made_it
FROM
	flagged_session
    
GROUP BY 1;

