-- 1. INNER JOIN: All bookings with their users
SELECT b.booking_id, 
       b.check_in_date, 
       b.check_out_date,
       u.user_name, 
       u.email
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id;

-- 2. LEFT JOIN: All properties with reviews (including properties with no reviews)
SELECT p.property_id,
       p.property_name,
       p.location,
       r.rating,
       r.comment
FROM Properties p
LEFT JOIN Reviews r ON p.property_id = r.property_id;

-- 3. FULL OUTER JOIN: All users and bookings (even unmatched ones)
SELECT u.user_id,
       u.user_name,
       b.booking_id,
       b.check_in_date,
       b.check_out_date
FROM Users u
FULL OUTER JOIN Bookings b ON u.user_id = b.user_id;