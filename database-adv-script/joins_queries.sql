-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.booking_date,
    b.property_id,
    u.user_id,
    u.name AS user_name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id;


-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.property_name,
    IFNULL(r.review_id, 'NO REVIEW') AS review_id,
    r.rating,
    r.comment
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id;


-- 3. FULL OUTER JOIN (emulated in MySQL): Retrieve all users and all bookings, even if unmatched
-- Part 1: Users LEFT JOIN Bookings
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

-- Part 2: Users RIGHT JOIN Bookings
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
