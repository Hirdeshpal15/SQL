-- -------------------------------------------Basic:--------------------------------------------------------------------------------

-- 1. Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS Total_num_of_orders
FROM
    orders;



-- 2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(price * quantity), 2) AS Total_revenue
FROM
    pizzas pi
        JOIN
    order_details od ON pi.pizza_id = od.pizza_id;





-- 3. Identify the highest-priced pizza.

SELECT 
    pt.name, pi.price
FROM
    pizzas pi
        JOIN
    pizza_types pt ON pi.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC;





-- 4. Identify the most common pizza size ordered.

SELECT 
    size, COUNT(*) AS order_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY order_count DESC;





-- 5. List the top 5 most ordered pizza types 
--             along with their quantities.


SELECT 
    pt.name, SUM(od.quantity) AS Total_ordered
FROM
    pizzas pi
        JOIN
    pizza_types pt ON pt.pizza_type_id = pi.pizza_type_id
        JOIN
    order_details od ON pi.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Total_ordered DESC
LIMIT 5;








-- --------------------------------------------Intermediate:-----------------------------------------------------


-- 1. Join the necessary tables to find the total quantity of each pizza category ordered.


SELECT 
    pt.category, SUM(od.quantity) AS Total_ordered
FROM
    pizzas pi
        JOIN
    pizza_types pt ON pt.pizza_type_id = pi.pizza_type_id
        JOIN
    order_details od ON pi.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY Total_ordered DESC;




-- 2. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS ordered_hour,
    COUNT(order_id) AS ordered_count
FROM
    orders
GROUP BY ordered_hour
ORDER BY ordered_count DESC;






-- 3. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(*) AS count
FROM
    pizza_types
GROUP BY category
ORDER BY count DESC;





-- 4. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT AVG(quantity) FROM
(SELECT o.order_date, SUM(od.quantity) AS quantity
FROM orders o JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_date) as order_quantity;




-- 5. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, SUM(od.quantity * pi.price) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas pi ON pi.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pi.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;




-- ------------------------------------------------Advanced:-----------------------------------------------------

-- 1. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    concat(round((SUM(od.quantity * pi.price) / (SELECT 
            ROUND(SUM(price * quantity), 2) AS Total_revenue
        FROM
            pizzas pi
                JOIN
            order_details od ON pi.pizza_id = od.pizza_id)) * 100,2),' %') AS Revenue 
FROM
    pizza_types pt
        JOIN
    pizzas pi ON pi.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pi.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC;


 
 
 
 
 
-- 2 Analyze the cumulative revenue generated over time.

SELECT 
	order_date,
    round(sum(revenue) over(order by order_date),2) as cum_revenue
FROM 
	(SELECT o.order_date, 
		    round(SUM(od.quantity * pi.price),2) AS revenue
	FROM order_details od 
		JOIN pizzas pi 
			ON pi.pizza_id = od.pizza_id
		JOIN orders o 
			ON o.order_id = od.order_id 
	group by o.order_date) AS sales;







-- 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT  category,
        name, 
		Revenue 
FROM
(SELECT category,
	name,
    Revenue, 
    RANK() OVER(PARTITION BY category ORDER BY Revenue DESC) AS Rank_Num
FROM 
(SELECT 
    pt.category,
    pt.name,
    ROUND(SUM(od.quantity * pi.price), 2) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas pi ON pi.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = pi.pizza_id
GROUP BY pt.category , pt.name
ORDER BY pt.category ASC , Revenue DESC) as a) AS b
WHERE Rank_num <= 3 ;


-- Error Code: 1248. Every derived table must have its own alias so add 'a' & 'b' at last










