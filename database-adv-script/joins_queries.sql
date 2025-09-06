-- LEFT JOIN part
SELECT 
    u.user_id,
    u.name AS user_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.property_id
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id

UNION

-- RIGHT JOIN part
SELECT 
    u.user_id,
    u.name AS user_name,
    u.email,
    b.booking_id,
    b.booking_date,
    b.property_id
FROM 
    users u
RIGHT JOIN 
    bookings b ON u.user_id = b.user_id;

