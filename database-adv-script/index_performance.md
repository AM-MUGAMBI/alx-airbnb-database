-- CREATE INDEX COMMANDS

-- Single column indexes
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX idx_bookings_checkin_date ON Bookings(check_in_date);
CREATE INDEX idx_properties_location ON Properties(location);
CREATE INDEX idx_reviews_property_id ON Reviews(property_id);
CREATE INDEX idx_reviews_rating ON Reviews(rating);

-- Composite indexes
CREATE INDEX idx_bookings_user_checkin ON Bookings(user_id, check_in_date);
CREATE INDEX idx_reviews_property_rating ON Reviews(property_id, rating);

-- PERFORMANCE TESTING QUERIES

-- Test user lookup by email
EXPLAIN ANALYZE
SELECT user_id, user_name FROM Users WHERE email = 'test@example.com';

-- Test bookings by user
EXPLAIN ANALYZE
SELECT * FROM Bookings WHERE user_id = 1;

-- Test properties by location
EXPLAIN ANALYZE
SELECT * FROM Properties WHERE location = 'New York';

-- Test date range bookings
EXPLAIN ANALYZE
SELECT * FROM Bookings 
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Test property reviews with rating filter
EXPLAIN ANALYZE
SELECT p.property_name, r.rating, r.comment
FROM Properties p
JOIN Reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4.0;

-- Test complex query with multiple JOINs
EXPLAIN ANALYZE
SELECT u.user_name, p.property_name, b.check_in_date, b.check_out_date
FROM Users u
JOIN Bookings b ON u.user_id = b.user_id
JOIN Properties p ON b.property_id = p.property_id
WHERE u.email = 'test@example.com'
ORDER BY b.check_in_date DESC;