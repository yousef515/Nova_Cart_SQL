USE NovaCart;
GO


/* Mission 1 - Customer & Product Overview*/

-- 1. Display all customers
SELECT *
FROM Customers;


--2. Display product name, category, and current price
SELECT
    name,
    category,
    price
FROM Products;


-- 3. Display products whose current price is greater than 5000
SELECT *
FROM Products
WHERE price > 5000;


-- 4. Display all customers ordered by join date, newest first
SELECT *
FROM Customers
ORDER BY join_date DESC;


-- 5. Display the total number of customers
SELECT COUNT(*) AS total_customers
FROM Customers;



/* Mission 2 - Aggregation & Business Totals */

-- 1. Calculate the average current product price
SELECT AVG(price) AS average_product_price
FROM Products;


-- 2. Display the highest and lowest current product prices
SELECT
    MAX(price) AS highest_price,
    MIN(price) AS lowest_price
FROM Products;


-- 3. Calculate the total available stock quantity
SELECT SUM(stock_quantity) AS total_stock
FROM Products;


-- 4. Calculate the total amount recorded in Payments
SELECT SUM(amount) AS total_payment_amount
FROM Payments;


-- 5. Display the number of orders for each order status
SELECT
    status,
    COUNT(*) AS order_count
FROM Orders
GROUP BY status;


-- 6. Display the total payment amount for each payment method
SELECT
    method,
    SUM(amount) AS total_amount
FROM Payments
GROUP BY method;



/*  Mission 3 - Order & Sales Analysis */

-- 1. Calculate the total sales amount for each order
SELECT
    order_id,
    SUM(quantity * unit_price) AS total_sales
FROM OrderDetails
GROUP BY order_id;


-- 2. Display only orders whose total sales exceed 5000
SELECT
    order_id,
    SUM(quantity * unit_price) AS total_sales
FROM OrderDetails
GROUP BY order_id
HAVING SUM(quantity * unit_price) > 5000;


-- 3. Display each order with customer's name, date, and status
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id;


-- 4. Display each order with its products, quantities, and historical prices
SELECT
    od.order_id,
    p.name AS product_name,
    od.quantity,
    od.unit_price
FROM OrderDetails od
JOIN Products p
    ON od.product_id = p.product_id;


-- 5. Display the total amount spent by each customer
SELECT
    c.customer_id,
    c.full_name,
    SUM(p.amount) AS total_spent
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
JOIN Payments p
    ON o.order_id = p.order_id
GROUP BY
    c.customer_id,
    c.full_name;



/*  Mission 4 - Reviews & Relationships */

-- 1. Number of reviews received by each product,
--    including products with no reviews
SELECT
    p.product_id,
    p.name AS product_name,
    COUNT(r.review_id) AS review_count
FROM Products p
LEFT JOIN Reviews r
    ON p.product_id = r.product_id
GROUP BY
    p.product_id,
    p.name;


-- 2. Display all reviews with customer name and product name
SELECT
    r.review_id,
    c.full_name,
    p.name AS product_name,
    r.rating,
    r.comment,
    r.review_date
FROM Reviews r
JOIN Customers c
    ON r.customer_id = c.customer_id
JOIN Products p
    ON r.product_id = p.product_id;


-- 3. Display customers who have placed at least one order
SELECT DISTINCT
    c.customer_id,
    c.full_name
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id;


-- 4. Display products that have never been ordered
SELECT
    p.product_id,
    p.name
FROM Products p
LEFT JOIN OrderDetails od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL;


-- 5. Display products that have never received a review
SELECT
    p.product_id,
    p.name
FROM Products p
LEFT JOIN Reviews r
    ON p.product_id = r.product_id
WHERE r.product_id IS NULL;


-- 6. Display all customers and their number of orders,
--    including customers with no orders
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name;



/* Mission 5 - Subqueries */

-- 1. Customers who placed more orders than
--    the average number of orders among customers
--    who placed at least one order

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.full_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) AS order_count
        FROM Orders
        GROUP BY customer_id
    ) AS customer_orders
);


-- 2. Products whose current price is above
--    the average current product price
SELECT
    product_id,
    name,
    price
FROM Products
WHERE price >
(
    SELECT AVG(price)
    FROM Products
);



/* Mission 6 - Common Table Expressions */

-- 1. Calculate total revenue by month

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(od.quantity * od.unit_price) AS total_revenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.order_id = od.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT *
FROM MonthlyRevenue
ORDER BY
    order_year,
    order_month;


-- 2. Calculate total spending by customer
--    and return customers whose spending exceeds 10000

WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.full_name,
        SUM(p.amount) AS total_spending
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Payments p
        ON o.order_id = p.order_id
    GROUP BY
        c.customer_id,
        c.full_name
)
SELECT *
FROM CustomerSpending
WHERE total_spending > 10000;


-- 3. Display customers whose total spending exceeds
--    the average among customers who made at least one payment

WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.full_name,
        SUM(p.amount) AS total_spending
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Payments p
        ON o.order_id = p.order_id
    GROUP BY
        c.customer_id,
        c.full_name
)
SELECT *
FROM CustomerSpending
WHERE total_spending >
(
    SELECT AVG(total_spending)
    FROM CustomerSpending
);



/* Mission 7 - Window Functions */

-- 1. Rank customers by total spending using RANK()

WITH CustomerSpending AS
(
    SELECT
        c.customer_id,
        c.full_name,
        SUM(p.amount) AS total_spending
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Payments p
        ON o.order_id = p.order_id
    GROUP BY
        c.customer_id,
        c.full_name
)
SELECT
    customer_id,
    full_name,
    total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM CustomerSpending;


-- 2. Rank products by total quantity sold using DENSE_RANK()

WITH ProductSales AS
(
    SELECT
        p.product_id,
        p.name,
        SUM(od.quantity) AS total_quantity_sold
    FROM Products p
    JOIN OrderDetails od
        ON p.product_id = od.product_id
    GROUP BY
        p.product_id,
        p.name
)
SELECT
    product_id,
    name,
    total_quantity_sold,
    DENSE_RANK() OVER (
        ORDER BY total_quantity_sold DESC
    ) AS sales_rank
FROM ProductSales;


-- 3. Display each payment together with
--    the previous payment amount

SELECT
    payment_id,
    order_id,
    payment_date,
    amount,
    LAG(amount) OVER (
        ORDER BY payment_date, payment_id
    ) AS previous_payment_amount
FROM Payments;


-- 4. Display a running total of payment amounts

SELECT
    payment_id,
    order_id,
    payment_date,
    amount,
    SUM(amount) OVER (
        ORDER BY payment_date, payment_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Payments;



/* Mission 8 - Views */

-- 1. Create a view for revenue by month
GO
CREATE OR ALTER VIEW vw_revenue_by_month
AS
SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM Orders o
JOIN OrderDetails od
    ON o.order_id = od.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date);
GO


-- 2. Create a view for best-selling products

CREATE OR ALTER VIEW vw_best_selling_products
AS
SELECT
    p.product_id,
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM Products p
JOIN OrderDetails od
    ON p.product_id = od.product_id
GROUP BY
    p.product_id,
    p.name;
GO


-- 3. Create a view for customer summary

CREATE OR ALTER VIEW vw_customer_summary
AS
SELECT
    c.customer_id,
    c.full_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    COALESCE(SUM(p.amount), 0) AS total_amount_spent
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
LEFT JOIN Payments p
    ON o.order_id = p.order_id
GROUP BY
    c.customer_id,
    c.full_name;
GO