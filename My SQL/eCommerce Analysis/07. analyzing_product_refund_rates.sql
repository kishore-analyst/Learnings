/*
NEW MESSAGE
October 15, 2014

From: Cindy Sharp (CEO)
Subject: Quality Issues & Refunds

Good morning,
Our Mr. Fuzzy supplier had some quality issues which
weren't corrected until September 2013. Then they had a
major problem where the bears' arms were falling off in
Aug/Sep 2014. As a result, we replaced them with a new
supplier on September 16, 2014.

Can you please pull monthly product refund rates, by
product, and confirm our quality issues are now fixed?
-Cindy
*/

select * from order_items;
select * from order_item_refunds;

SELECT
	YEAR(oi.created_at) year,
    Month(oi.created_at) month,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN oi.order_id ELSE NULL END) prd1_orders,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refund_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN product_id = 1 THEN oi.order_id ELSE NULL END) *100 prd1_ref_rt,
	COUNT(DISTINCT CASE WHEN product_id = 2 THEN oi.order_id ELSE NULL END) AS prd2_orders,
	COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_item_refund_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN product_id = 2 THEN oi.order_id ELSE NULL END) *100 prd2_ref_rt,
	COUNT(DISTINCT CASE WHEN product_id = 3 THEN oi.order_id ELSE NULL END) AS prd3_orders,
	COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_item_refund_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN product_id = 3 THEN oi.order_id ELSE NULL END) *100 prd3_ref_rt,
	COUNT(DISTINCT CASE WHEN product_id = 4 THEN oi.order_id ELSE NULL END) AS prd4_orders,
	COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_item_refund_id ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN product_id = 4 THEN oi.order_id ELSE NULL END) *100 prd4_ref_rt
FROM
	order_items oi
	LEFT JOIN order_item_refunds oir
		ON oir.order_item_id = oi.order_item_id
WHERE
	oi.created_at < '2014-10-15'
GROUP BY 1,2;