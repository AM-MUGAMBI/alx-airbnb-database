-- 1. AGGREGATION: Total bookings per user using COUNT and GROUP BY
SELECT u.user_id,
       u.user_name,
       COUNT(b.booking_id) as total_bookings
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_bookings DESC;

-- 2. WINDOW FUNCTIONS: Rank properties by total bookings using ROW_NUMBER
SELECT p.property_id,
       p.property_name,
       COUNT(b.booking_id) as total_bookings,
       ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) as row_rank
FROM Properties p
LEFT JOIN Bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.property_name
ORDER BY total_bookings DESC;

-- 3. WINDOW FUNCTIONS: Rank properties using RANK (handles ties differently)
SELECT p.property_id,
       p.property_name,
       COUNT(b.booking_id) as total_bookings,
       RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) as property_rank
FROM Properties p
LEFT JOIN Bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.property_name
ORDER BY total_bookings DESC;
