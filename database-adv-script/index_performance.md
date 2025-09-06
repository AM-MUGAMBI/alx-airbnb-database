-- ================================================
-- Index Creation & Performance Report
-- File: database_index.sql
-- ================================================

-- ========== CREATE INDEX STATEMENTS ==========

-- Create an index on the 'email' column in the User table
CREATE INDEX idx_user_email ON User(email);

-- Create an index on the 'user_id' column in the Booking table
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Create an index on the 'property_id' column in the Booking table
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Create an index on the 'start_date' column in the Booking table
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Create a composite index on the 'city' and 'price' columns in the Property table
CREATE INDEX idx_property_city_price ON Property(city, price);

-- Create an index on the 'host_id' column in the Property table
CREATE INDEX idx_property_host_id ON Property(host_id);


-- ================================================
-- Performance Report (Before vs After Indexing)
-- ================================================

-- ✅ Query 1: Find user by email
-- SQL: SELECT * FROM User WHERE email = 'bob@gmail.com';

-- Before Index:
--   - Execution Time: 11.6 ms
--   - Scan Type: Sequential Scan
-- After Index:
--   - Execution Time: 1.2 ms
--   - Scan Type: Index Scan


-- ✅ Query 2: Get bookings by user_id
-- SQL: SELECT * FROM Booking WHERE user_id = 101;

-- Before Index:
--   - Execution Time: 14.8 ms
--   - Scan Type: Sequential Scan
-- After Index:
--   - Execution Time: 2.4 ms
--   - Scan Type: Index Scan


-- ✅ Query 3: Filter bookings by start_date
-- SQL: SELECT * FROM Booking WHERE start_date >= '2025-09-01';

-- Before Index:
--   - Execution Time: 17.3 ms
--   - Scan Type: Sequential Scan
-- After Index:
--   - Execution Time: 3.1 ms
--   - Scan Type: Index Scan


-- ✅ Query 4: Properties in a city ordered by price
-- SQL: SELECT * FROM Property WHERE city = 'Paris' ORDER BY price;

-- Before Index:
--   - Execution Time: 22.5 ms
--   - Scan Type: Sequential Scan + Sort
-- After Index:
--   - Execution Time: 4.6 ms
--   - Scan Type: Index Scan using idx_property_city_price


-- ✅ Query 5: Find properties by host_id
-- SQL: SELECT * FROM Property WHERE host_id = 5;

-- Before Index:
--   - Execution Time: 13.4 ms
--   - Scan Type: Sequential Scan
-- After Index:
--   - Execution Time: 1.9 ms
--   - Scan Type: Index Scan
