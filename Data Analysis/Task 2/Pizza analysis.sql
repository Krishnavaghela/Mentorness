create Database Pizza;
USE Pizza;


create table pizza (
	pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(50),
    price decimal 
    );
 
 SELECT * FROM pizza.pizza;



create table pizza_type (
	pizza_type_id VARCHAR(50) PRIMARY KEY,
    name_ VARCHAR(50),
    category VARCHAR(50),
    ingredients VARCHAR(200)
    );

SELECT * FROM pizza.pizza_type;



create table orders (
	order_id INT PRIMARY KEY,
    date_ date,
    time_ time
    );

SELECT * FROM pizza.orders;


create table order_details (
	order_details_id INT PRIMARY KEY,
	order_id INT ,
    pizza_id VARCHAR(50),
    quantity INT
    );
    
SELECT * FROM pizza.order_details;
    
    
-- Q1: The total number of order place

select count(order_id) as Total_order from orders;

#    The total number of order placed is 21350



-- Q2: The total revenue generated from pizza sales

select sum(p.price * od.quantity) as total_revenue
from pizza as p
join order_details as od
on p.pizza_id = od.pizza_id;

#  827450 is the total revenue generated from the pizza sales



-- Q3: The highest priced pizza.

select pt.name_ , p.price 
from pizza as p
join pizza_type as pt on pt.pizza_type_id = p.pizza_type_id
order by p.price desc
limit 1;

#  "The Greek Pizza" is the highest priced pizza



-- Q4: The most common pizza size ordered.

select size  as pizza_size,count(size) as total_order from pizza
group by size 
order by count(size) desc
limit 1 ;

# The most common pizza size ordered is "S".



-- Q5: The top 5 most ordered pizza types along their quantities. pizzas p

select pizza_id as pizzas, count(quantity) from order_details
group by pizza_id
order by count(quantity) desc
limit 5;

# The top 5 most ordered pizza types along their quantities



-- Q6: The quantity of each pizza categories ordered.

select pt.category ,count(od.quantity)
from pizza_type as pt
join pizza as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by category;

# The quantity of each pizza categories ordered is "classic = 14579" , "Veggie = 11449" , "Supreme = 11777" , "chicken = 10815".



-- Q7: The distribution of orders by hours of the day.

select hour(time_) as hour, COUNT(*) AS total_orders from orders
group by hour(time_)
order by hour(time_); 



-- Q8: The category-wise distribution of pizzas.

select category, count(pizza_type_id) from pizza_type
group by category;

# category-wise distribution of pizzas is "Chicken = 6" , "Classic = 8" , "Supreme = 9" , "Veggie = 9"



-- Q9: The average number of pizzas ordered per day.	


select round(avg(quantity), 0) as Average_order
from
    (select o.date_ as date, sum(od.quantity) as quantity
    from orders as o
    join order_details as od 
    on o.order_id = od.order_id
    group by date) as order_quantity;

# The average number of pizzas ordered per day is 138



-- Q10: Top 3 most ordered pizza type base on revenue.

select p.pizza_type_id as pizza_type, sum(p.price * od.quantity) as revenue 
from pizza as p
join order_details as od
on od.pizza_id = p.pizza_id
group by pizza_type_id
order by revenue desc
limit 3;

#  Top 3 most ordered pizza type base on revenue are "thai_ckn = 44027" , "bbq_ckn = 43376" , "cali_ckn = 42002"



-- Q11: The percentage contribution of each pizza type to revenue.	

SELECT 
pt.category,
ROUND(SUM(p.price * od.quantity) / (SELECT ROUND(SUM(p.price * od.quantity), 2)
from pizza as p
join order_details as od 
on p.pizza_id = od.pizza_id) * 100,2) as revenue
from pizza_type as pt
join pizza as p 
on pt.pizza_type_id = p.pizza_type_id
join order_details as od 
on od.pizza_id = p.pizza_id
group by pt.category;

#   The percentage contribution of each pizza type to revenue is " Classic = 26.96% " , "  Veggie = 23.53%" , " Supreme = 25.51%" , " Chicken = 24.01%"  
 

-- Q12: The cumulative revenue generated over time.
	 
select date , sum(revenue)  over ( order by date) as cum_revenue from
(select o.date_ as date , sum(p.price* od.quantity) as Revenue from order_details as od
join pizza as p
on p.pizza_id = od.pizza_id
join orders as o
on od.order_id = o.order_id
group by date) as sales;
     
     
     
     
-- Q13: The top 3 most ordered pizza type based on revenue for each pizza category.

select pt.category , sum(p.price * od.quantity) as revenue 
from pizza_type as pt
join pizza as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id
group by category
order by revenue desc
limit 3;

# The top 3 most ordered pizza type based on revenue for each pizza category are "Classic = 223058" , "Supreme = 211042" , "Chicken = 198682"
