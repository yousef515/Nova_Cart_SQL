USE NovaCart;
GO

INSERT INTO Customers (full_name, email, phone, address, join_date)
VALUES
('Ahmed Hassan', 'ahmed.hassan@email.com', '01010000001', 'Tanta, Gharbia', '2025-01-10'),
('Sara Ali', 'sara.ali@email.com', '01010000002', 'Cairo', '2025-02-15'),
('Omar Mohamed', 'omar.mohamed@email.com', '01010000003', 'Alexandria', '2025-03-20'),
('Mariam Ahmed', 'mariam.ahmed@email.com', '01010000004', 'Mansoura', '2025-04-05'),
('Youssef Samir', 'youssef.samir@email.com', '01010000005', 'Tanta, Gharbia', '2025-05-12'),
('Nour Khaled', 'nour.khaled@email.com', '01010000006', 'Cairo', '2025-06-18'),
('Karim Adel', 'karim.adel@email.com', '01010000007', 'Giza', '2025-07-22'),
('Hana Mostafa', 'hana.mostafa@email.com', '01010000008', 'Alexandria', '2025-08-10'),
('Mahmoud Tarek', 'mahmoud.tarek@email.com', '01010000009', 'Mansoura', '2025-09-14'),
('Laila Ibrahim', 'laila.ibrahim@email.com', '01010000010', 'Cairo', '2025-10-01');
GO


INSERT INTO Products (name, category, price, stock_quantity)
VALUES
('Laptop Pro 15', 'Electronics', 5000.00, 15),
('Wireless Headphones', 'Electronics', 1500.00, 40),
('Mechanical Keyboard', 'Accessories', 900.00, 30),
('Smart Watch', 'Electronics', 2800.00, 20),
('Gaming Mouse', 'Accessories', 850.00, 50),
('Smart TV 55', 'Home Appliances', 6500.00, 10),
('Bluetooth Speaker', 'Electronics', 700.00, 35),
('Tablet 10', 'Electronics', 3200.00, 18),
('Office Chair', 'Furniture', 1600.00, 12),
('Coffee Machine', 'Home Appliances', 4500.00, 8);
GO


INSERT INTO Orders (customer_id, order_date, status)
VALUES
(1, '2025-01-15', 'Delivered'),
(1, '2025-02-20', 'Shipped'),
(2, '2025-03-25', 'Delivered'),
(3, '2025-04-10', 'Pending'),
(4, '2025-05-18', 'Delivered'),
(5, '2025-06-22', 'Cancelled'),
(6, '2025-07-05', 'Delivered'),
(7, '2025-08-12', 'Shipped'),
(8, '2025-09-17', 'Delivered'),
(9, '2025-10-03', 'Pending');
GO


INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 4500.00),
(1, 2, 1, 1200.00),

(2, 1, 1, 4300.00),
(2, 3, 2, 700.00),

(3, 4, 1, 2500.00),

(4, 5, 3, 800.00),
(4, 2, 1, 1300.00),

(5, 6, 1, 6000.00),

(6, 7, 2, 350.00),

(7, 8, 1, 3000.00),

(8, 9, 1, 1500.00),

(9, 2, 1, 1250.00),

(10, 4, 1, 2600.00);
GO


INSERT INTO Payments (order_id, payment_date, amount, method)
VALUES
(1, '2025-01-15', 10200.00, 'Credit Card'),
(2, '2025-02-20', 5700.00, 'PayPal'),
(3, '2025-03-25', 2500.00, 'COD'),
(4, '2025-04-10', 3700.00, 'Credit Card'),
(5, '2025-05-18', 6000.00, 'PayPal'),
(6, '2025-06-22', 700.00, 'COD'),
(7, '2025-07-05', 3000.00, 'Credit Card'),
(8, '2025-08-12', 1500.00, 'PayPal'),
(9, '2025-09-17', 1250.00, 'COD'),
(10, '2025-10-03', 2600.00, 'Credit Card');
GO


INSERT INTO Reviews (customer_id, product_id, rating, comment, review_date)
VALUES
(1, 1, 5, 'Excellent laptop and very fast.', '2025-01-25'),
(1, 2, 4, 'Good sound quality.', '2025-01-28'),
(2, 1, 4, 'Very good performance.', '2025-04-01'),
(3, 4, 3, 'Good but battery could be better.', '2025-04-20'),
(4, 5, 5, 'Great mouse for gaming.', '2025-05-25'),
(5, 6, 2, 'The picture is good but expensive.', '2025-06-30'),
(6, 7, 4, 'Nice sound for its size.', '2025-07-15'),
(7, 8, 5, 'Very useful tablet.', '2025-08-25'),
(8, 9, 3, 'Comfortable chair.', '2025-09-25'),
(9, 2, 1, 'The quality was not what I expected.', '2025-10-10');
GO