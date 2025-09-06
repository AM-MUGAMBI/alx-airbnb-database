-- INITIAL QUERY: All bookings with user, property, and payment details

-- Original inefficient query
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.user_name,
    u.email,
    u.phone_number,
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    p.property_type,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
ORDER BY b.check_in_date DESC;

-- REFACTORED OPTIMIZED QUERY

-- Version 1: Select only necessary columns
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    u.user_name,
    u.email,
    p.property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
ORDER BY b.check_in_date DESC;

-- Version 2: Add WHERE clause to limit results
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    u.user_name,
    u.email,
    p.property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
WHERE b.check_in_date >= '2024-01-01'
ORDER BY b.check_in_date DESC
LIMIT 100;

-- Version 3: Use subquery for specific cases
SELECT 
    booking_data.booking_id,
    booking_data.check_in_date,
    booking_data.user_name,
    booking_data.property_name,
    pay.amount,
    pay.payment_method
FROM (
    SELECT 
        b.booking_id,
        b.check_in_date,
        u.user_name,
        p.property_name
    FROM Bookings b
    INNER JOIN Users u ON b.user_id = u.user_id
    INNER JOIN Properties p ON b.property_id = p.property_id
    WHERE b.check_in_date >= '2024-01-01'
    ORDER BY b.check_in_date DESC
    LIMIT 100
) booking_data
LEFT JOIN Payments pay ON booking_data.booking_id = pay.booking_id;

-- PERFORMANCE ANALYSIS QUERIES

-- Analyze original query
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.user_name,
    u.email,
    u.phone_number,
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    p.property_type,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
ORDER BY b.check_in_date DESC;

-- Analyze optimized query
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    u.user_name,
    u.email,
    p.property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Properties p ON b.property_id = p.property_id
LEFT JOIN Payments pay ON b.booking_id = pay.booking_id
WHERE b.check_in_date >= '2024-01-01'
ORDER BY b.check_in_date DESC
LIMIT 100;
