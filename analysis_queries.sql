-- =========================================
-- Project: Product Sales Performance Analysis
-- Description: SQL queries for analyzing sales trends, product performance, and revenue insights
-- =========================================

-- 1. Top 3 Pizzas by Revenue (Window Function)
-- Purpose: Identify highest revenue-generating pizzas within each category

SELECT category, name, revenue
FROM (
    SELECT pizza_types.category,
           pizza_types.name,
           SUM(order_details.quantity * pizzas.price) AS revenue,
           RANK() OVER (
               PARTITION BY pizza_types.category
               ORDER BY SUM(order_details.quantity * pizzas.price) DESC
           ) AS rnk
    FROM pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
) ranked
WHERE rnk <= 3;

-- =========================================
-- 2. Top 5 Most Ordered Pizzas

SELECT pizza_types.name, SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- =========================================
-- 3. Revenue by Category

SELECT pizza_types.category,
SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- =========================================
-- 4. Orders by Hour

SELECT HOUR(time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY hour
ORDER BY hour;

-- =========================================
-- 5. Cumulative Revenue

SELECT orders.date,
SUM(order_details.quantity * pizzas.price) AS daily_revenue,
SUM(SUM(order_details.quantity * pizzas.price))
OVER (ORDER BY orders.date) AS cumulative_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY orders.date
ORDER BY orders.date;

-- =========================================
-- 6. Top 3 Pizzas by Revenue (Window Function)

SELECT category, name, revenue
FROM (
    SELECT pizza_types.category,
           pizza_types.name,
           SUM(order_details.quantity * pizzas.price) AS revenue,
           RANK() OVER (
               PARTITION BY pizza_types.category
               ORDER BY SUM(order_details.quantity * pizzas.price) DESC
           ) AS rnk
    FROM pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
) ranked
WHERE rnk <= 3;
-- =========================================
