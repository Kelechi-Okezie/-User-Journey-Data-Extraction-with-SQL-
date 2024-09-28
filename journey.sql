--- Inspecting Tables
select *
from front_interactions
limit 10;

select *
from front_visitors
order by visitor_id
limit 20;

--- Solution 1
WITH paid_users as (    
SELECT user_id, 
    MIN(date_purchased) AS first_purchase_date,
    CASE 
        WHEN purchase_type = 0 THEN 'Monthly'
        WHEN purchase_type = 1 THEN 'Quarterly'
        WHEN purchase_type = 2 THEN 'Annual'
        ELSE 'Unknown' 
    END AS subscription_type,
    purchase_price
from student_purchases
where purchase_price > 0
AND date_purchased BETWEEN '2023-01-01' AND '2023-03-31'
group by user_id, subscription_type, purchase_price) 

select pu.user_id, fi.session_id, pu.subscription_type, GROUP_CONCAT(CONCAT(
CASE when fi.event_source_url = 'https://365datascience.com' THEN 'Homepage'
when fi.event_source_url like '%https://365datascience.com/login/%' THEN 'Login' 
when fi.event_source_url like '%https://365datascience.com/signup/%' THEN 'Sign up' 
when fi.event_source_url like '%https://365datascience.com/resources-center/' THEN 'Resources center'
when fi.event_source_url like '%https://365datascience.com/courses/%' THEN 'courses' 
when fi.event_source_url like '%https://365datascience.com/career-tracks/%' THEN 'Career tracks' 
when fi.event_source_url like '%https://365datascience.com/upcoming-courses/%' THEN 'Upcoming courses' 
when fi.event_source_url like '%https://365datascience.com/career-track-certificate/%' THEN 'Career track certificate' 
when fi.event_source_url like '%https://365datascience.com/course-certificate/%' THEN 'Course certificate'
when fi.event_source_url like '%https://365datascience.com/success-stories/%' THEN 'success stories'
when fi.event_source_url like '%https://365datascience.com/blog/%' THEN 'Blog'
when fi.event_source_url like '%https://365datascience.com/pricing/%' THEN 'Pricing' 
when fi.event_source_url like '%https://365datascience.com/about-us%' THEN 'About us' 
when fi.event_source_url like '%https://365datascience.com/instructors/%' THEN 'Instructors'
when fi.event_source_url like '%https://365datascience.com/checkout/%' and fi.event_source_url like '%coupon%' THEN 'coupon'
when fi.event_source_url like '%https://365datascience.com/checkout/%' and fi.event_source_url not like '%coupon%' THEN 'checkout'
ELSE 'Other'
END, '-',

CASE when fi.event_destination_url = 'https://365datascience.com' THEN 'Homepage'
when fi.event_destination_url like '%https://365datascience.com/login/%' THEN 'Login' 
when fi.event_destination_url like '%https://365datascience.com/signup/%' THEN 'Sign up' 
when fi.event_destination_url like '%https://365datascience.com/resources-center/' THEN 'Resources center'
when fi.event_destination_url like '%https://365datascience.com/courses/%' THEN 'courses' 
when fi.event_destination_url like '%https://365datascience.com/career-tracks/%' THEN 'Career tracks' 
when fi.event_destination_url like '%https://365datascience.com/upcoming-courses/%' THEN 'Upcoming courses' 
when fi.event_destination_url like '%https://365datascience.com/career-track-certificate/%' THEN 'Career track certificate' 
when fi.event_destination_url like '%https://365datascience.com/course-certificate/%' THEN 'Course certificate'
when fi.event_destination_url like '%https://365datascience.com/success-stories/%' THEN 'success stories'
when fi.event_destination_url like '%https://365datascience.com/blog/%' THEN 'Blog'
when fi.event_destination_url like '%https://365datascience.com/pricing/%' THEN 'Pricing' 
when fi.event_destination_url like '%https://365datascience.com/about-us%' THEN 'About us' 
when fi.event_destination_url like '%https://365datascience.com/instructors/%' THEN 'Instructors'
when fi.event_destination_url like '%https://365datascience.com/checkout/%' and fi.event_destination_url like '%coupon%' THEN 'coupon'
when fi.event_destination_url like '%https://365datascience.com/checkout/%' and fi.event_destination_url not like '%coupon%' THEN 'checkout'
ELSE 'Other'
END) SEPARATOR '-') AS user_journey

from paid_users pu
join front_visitors fv ON pu.user_id = fv.user_id
join front_interactions fi ON fv.visitor_id = fi.visitor_id
where fi.event_date < first_purchase_date
group by fi.session_id, pu.user_id, pu.subscription_type
order by pu.user_id
;

 




--- Solution 2
WITH paid_users AS (
    SELECT user_id, 
           MIN(date_purchased) AS first_purchase_date,
           CASE 
               WHEN purchase_type = 0 THEN 'Monthly'
               WHEN purchase_type = 1 THEN 'Quarterly'
               WHEN purchase_type = 2 THEN 'Annual'
               ELSE 'Unknown' 
           END AS subscription_type,
           purchase_price
    FROM student_purchases
    WHERE purchase_price > 0
      AND date_purchased BETWEEN '2023-01-01' AND '2023-03-31'
    GROUP BY user_id, subscription_type, purchase_price
) 

SELECT pu.user_id, 
       fi.session_id, 
       pu.subscription_type, 
       GROUP_CONCAT(CONCAT(
           CASE 
               WHEN fi.event_source_url = 'https://365datascience.com' THEN 'Homepage'
               WHEN fi.event_source_url LIKE '%/login/%' THEN 'Login' 
               WHEN fi.event_source_url LIKE '%/signup/%' THEN 'Sign up' 
               WHEN fi.event_source_url LIKE '%/resources-center%' THEN 'Resources center'
               WHEN fi.event_source_url LIKE '%/courses/%' THEN 'courses' 
               WHEN fi.event_source_url LIKE '%/career-tracks/%' THEN 'Career tracks' 
               WHEN fi.event_source_url LIKE '%/upcoming-courses/%' THEN 'Upcoming courses' 
               WHEN fi.event_source_url LIKE '%/career-track-certificate/%' THEN 'Career track certificate' 
               WHEN fi.event_source_url LIKE '%/course-certificate/%' THEN 'Course certificate'
               WHEN fi.event_source_url LIKE '%/success-stories/%' THEN 'Success stories'
               WHEN fi.event_source_url LIKE '%/blog/%' THEN 'Blog'
               WHEN fi.event_source_url LIKE '%/pricing/%' THEN 'Pricing' 
               WHEN fi.event_source_url LIKE '%/about-us%' THEN 'About us' 
               WHEN fi.event_source_url LIKE '%/instructors/%' THEN 'Instructors'
               WHEN fi.event_source_url LIKE '%/checkout/%coupon%' THEN 'coupon'
               WHEN fi.event_source_url LIKE '%/checkout/%' THEN 'checkout'
               ELSE 'Other'
           END, '-', 
           CASE 
               WHEN fi.event_destination_url = 'https://365datascience.com' THEN 'Homepage'
               WHEN fi.event_destination_url LIKE '%/login/%' THEN 'Login' 
               WHEN fi.event_destination_url LIKE '%/signup/%' THEN 'Sign up' 
               WHEN fi.event_destination_url LIKE '%/resources-center%' THEN 'Resources center'
               WHEN fi.event_destination_url LIKE '%/courses/%' THEN 'courses' 
               WHEN fi.event_destination_url LIKE '%/career-tracks/%' THEN 'Career tracks' 
               WHEN fi.event_destination_url LIKE '%/upcoming-courses/%' THEN 'Upcoming courses' 
               WHEN fi.event_destination_url LIKE '%/career-track-certificate/%' THEN 'Career track certificate' 
               WHEN fi.event_destination_url LIKE '%/course-certificate/%' THEN 'Course certificate'
               WHEN fi.event_destination_url LIKE '%/success-stories/%' THEN 'Success stories'
               WHEN fi.event_destination_url LIKE '%/blog/%' THEN 'Blog'
               WHEN fi.event_destination_url LIKE '%/pricing/%' THEN 'Pricing' 
               WHEN fi.event_destination_url LIKE '%/about-us%' THEN 'About us' 
               WHEN fi.event_destination_url LIKE '%/instructors/%' THEN 'Instructors'
               WHEN fi.event_destination_url LIKE '%/checkout/%coupon%' THEN 'coupon'
               WHEN fi.event_destination_url LIKE '%/checkout/%' THEN 'checkout'
               ELSE 'Other'
           END
       ) SEPARATOR '-') AS user_journey

FROM paid_users pu
JOIN front_visitors fv ON pu.user_id = fv.user_id
JOIN front_interactions fi ON fv.visitor_id = fi.visitor_id
AND fi.event_date < pu.first_purchase_date  -- Moved condition to JOIN clause
GROUP BY pu.user_id, pu.subscription_type, fi.session_id
order by pu.user_id;

