-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Payment Management Queries

-- 2.1. Record a payment for a membership
-- Insert a payment record for member with ID 11

INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, CURRENT_TIMESTAMP, 'Credit Card', 'Monthly membership fee');

-- 2.2. Calculate total revenue from membership fees for each month of the last year
SELECT 
    strftime('%Y-%m', payment_date) AS month, -- Format the date as YYYY-MM
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_type = 'Monthly membership fee'
    AND payment_date >= DATE('now', '-1 year') -- Filter for the last year
GROUP BY strftime('%Y-%m', payment_date)
ORDER BY month;

-- 2.3. Find all day pass purchases
SELECT 
    payment_id, 
    amount, 
    payment_date, 
    payment_method 
FROM payments
WHERE payment_type = 'Day pass';