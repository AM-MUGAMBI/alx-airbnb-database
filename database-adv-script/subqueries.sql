-- 1. NON-CORRELATED SUBQUERY: Properties with average rating > 4.0
SELECT property_id, property_name, location
FROM Properties
WHERE property_id IN (
    SELECT property_id
    FROM Reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
);

-- 2. CORRELATED SUBQUERY: Users who made more than 3 bookings
SELECT user_id, user_name, email
FROM Users u
WHERE (
    SELECT COUNT(*)
    FROM Bookings b
    WHERE b.user_id = u.user_id
) > 3;
