/*
NEW MESSAGE
November 01, 2014

From: Tom Parmesan (Marketing Director)
Subject: Repeat Visitors

Hey there,
We've been thinking about customer value based solely on
their first session conversion and revenue. But if customers
have repeat sessions, they may be more valuable than we
thought. If that's the case, we might be able to spend a bit
more to acquire them.
Could you please pull data on how many of our website
visitors come back for another session? 2014 to date is good.
Thanks, Tom
*/

-- IDENTIFYING REPEAT VISITORS

select * from website_sessions;


CREATE TABLE user_w_repeat_session
SELECT 
	first_session.user_id,
    first_session.website_session_id as first_visit,
	w.website_session_id as second_visit
    
FROM (
	SELECT
		user_id,
		website_session_id
	FROM website_sessions
	WHERE 
		created_at < '2014-11-01'
		AND created_at >= '2014-01-01'
		AND is_repeat_session = 0
	) AS first_session 
    LEFT JOIN website_sessions w
		ON w.user_id = first_session.user_id
        AND w.is_repeat_session = 1
        AND w.website_session_id > first_session.website_session_id
        AND created_at < '2014-11-01'
		AND created_at >= '2014-01-01';
        

SELECT 
	repeat_session,
	COUNT(DISTINCT user_id) as users

FROM(
SELECT 
	user_id,
    COUNT(DISTINCT first_visit) as new_session,
    COUNT(DISTINCT second_visit) as repeat_session
FROM user_w_repeat_session
GROUP BY 1
) as user_id_with_repeat

GROUP BY 1;



/*
NEW MESSAGE
November 03, 2014

From:Tom Parmesan (Marketing Director)
Subject:Deeper Dive on Repeat

0k, so the repeat session data was really interesting to see.
Now you've got me curious to better understand the behavior
of these repeat customers.

Could you help me understand the minimum, maximum, and
average time between the first and second session for
customers who do come back? Again, analyzing 2014 to date
is probably the right time period.
Thanks, Tom
*/


-- STEP 1: Identify the relevant new sessions
-- STEP 2: Use the user_id values from Step 1 to find any repeat sessions those users had
-- STEP 3: Find the created at times for first and second sessions
-- STEP 4: Find the differences between first and second sessions at a user level
-- STEP 5: Aggregate the user level data to find the average, min, max

CREATE TEMPORARY TABLE sessions_w_repeats_for_time_diff
SELECT
	new_session.user_id,
	new_session.website_session_id AS new_session,
	new_session.created_at AS new_data,
    ws.website_session_id AS repeat_session,
    ws.created_at AS repear_date
FROM (
	SELECT 
		user_id,
		website_session_id,
		created_at
	FROM 
		website_sessions
	WHERE 
		created_at > '2014-01-01'
		AND created_at < '2014-11-03'
		AND is_repeat_session = 0
) AS new_session 
	LEFT JOIN website_sessions ws
		ON ws.user_id= new_session.user_id
        AND ws.website_session_id > new_session.website_session_id
        AND is_repeat_session = 1
        AND ws.created_at > '2014-01-01'
		AND ws.created_at < '2014-11-03';


CREATE TEMPORARY TABLE day_diff
SELECT 
	user_id,
    DATEDIFF(second_date, new_data) AS days_first_to_second_date
    FROM (
SELECT 
	user_id,
    new_session,
    new_data,
    MIN(repeat_session) AS second_session,
    MIN(repear_date) AS second_date
FROM
	sessions_w_repeats_for_time_diff
WHERE 
	repeat_session IS NOT NULL
GROUP BY 1,2,3
) AS session_date_table;


SELECT
	MIN(days_first_to_second_date) min_days, 
    AVG(days_first_to_second_date) avg_days,
    MAX(days_first_to_second_date) max_days
FROM 
	day_diff;
    
    
/*
NEW MESSAGE
November 05, 2014

From: Tom Parmesan (Marketing Director)
Subject: Repeat Channel Mix

Hi there,
Let's do a bit more digging into our repeat customers.
Can you help me understand the channels they come back
through? 

Curious if it's all direct type-in, or if we're paying for
these customers with paid search ads multiple times.
Comparing new vs. repeat sessions by channel would be
really valuable, if you're able to pull it! 2014 to date is great.
Thanks, Tom
*/
    
-- COMPARING NEW AND REPEAT SESSION BY CHANNEL

SELECT * FROM website_sessions;

 SELECT 
	utm_source,
    utm_campaign,
    http_referer,
    CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END AS first_session,
	CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END AS repeat_session
 FROM
	website_sessions
 WHERE 
	created_at < '2014-11-05'
    AND created_at > '2014-01-01';
    
    
SELECT
	CASE 
		WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in' 
		WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
		WHEN utm_source = 'socialbook' THEN 'paid_social'
		WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        ELSE 'not found'
	END as segment,
    COUNT(DISTINCT first_session) as first_session,
    COUNT(DISTINCT repeat_session) as repeat_session
    
    FROM (
 SELECT 
	utm_source,
    utm_campaign,
    http_referer,
    CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END AS first_session,
	CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END AS repeat_session
 FROM
	website_sessions
 WHERE 
	created_at < '2014-11-05'
    AND created_at > '2014-01-01'
) AS first_repeat_sessions

GROUP BY 1;