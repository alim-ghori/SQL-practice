select * from product;

-- FIRST_VALUE
--write a query to display the most expensive product under each category
-- (coresponding to each record)

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product;

-- LAST_VALUE
-- write a query to display the most least product under each category (coresponding to each record)

select *,
first_value(product_name)
		over(partition by product_category order by price desc)
		as most_exp_product,
last_value(product_name)
		over (partition by product_category order by price desc
			 range between 2 preceding and 2 following)
		as least_exp_product
from product
where product_category = 'Phone';

-- alternate way of writing SQL windows function

select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w	as least_exp_product
from product
window w as (partition by product_category order by price desc
			 range between unbounded preceding and unbounded following);

--NTH_VALUE
-- write query to display the SECOND most expensive product under each category


select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w	as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_prod
from product
window w as (partition by product_category order by price desc
			 range between unbounded preceding and unbounded following);

-- NTILE
-- write a query to segregate all the expensive phones, mid range phones and cheaper phones

select product_name,
case when x.buckets = 1 then 'Expensive Phones'
	 when x.buckets = 2 then 'Mid Range Phones'
	 when x.buckets = 3 then 'Cheaper Phones' END phone_range
from(
	select *,
	ntile(3) over (order by price desc ) as buckets
	from product
	where product_category = 'Phone') x ;

-- CUME_DIST (cummilative distribution)
-- Value --> 1 <= CUME_DIST > 0
-- FOrmula  = Current Row No (Row number as value same as Current Row) / Total no of rows

-- Query to fetch all products which are consistuiting the first 30% of the data in produt table based on price  

select product_name, (cume_dist_percentage ||'%') as cume_dist_percentage
from(
	select *,
	cume_dist() over(order by price desc) as cume_distribution,
	round(cume_dist() over(order by price desc):: numeric * 100,2) as cume_dist_percentage
	from product) x
where x.cume_dist_percentage <= 30;

-- PERCENT_RANK (relative rank of the current row / Percentage Ranking)
-- value --> 1 <= PERCENT_RANK > 0
-- Formula = Current Row No - 1/ Total no of rows - 1

-- Query to identify how much percentage more expensive is "Galaxy z Fold 3" when compared to all products.

select product_name, percentage_rank
from(
	select *,
	percent_rank() over(order by price) as perc_rank,
	round(percent_rank() over(order by price)::numeric * 100, 2) as percentage_rank
	from product) x
where x.product_name = 'Galaxy Z Fold 3'





