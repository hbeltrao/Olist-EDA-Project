SET @tot_reviews = (SELECT count(review_score) FROM olist_order_reviews_dataset);

SELECT review_score, count(review_score) as n_reviews, ROUND(100*count(review_score)/@tot_reviews,2) as "%_reviews"
FROM olist_order_reviews_dataset GROUP BY review_score ORDER BY review_score DESC;