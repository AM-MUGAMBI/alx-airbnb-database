-- TABLE PARTITIONING ON BOOKING TABLE

-- Step 1: Create partitioned Booking table based on start_date
CREATE TABLE Bookings_Partitioned (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id)
) PARTITION BY RANGE (YEAR(start_date));

-- Step 2: Create individual partitions for different years
CREATE TABLE Bookings_2022 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM (2022) TO (2023);

CREATE TABLE Bookings_2023 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM (2023) TO (2024);

CREATE TABLE Bookings_2024 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM (2024) TO (2025);

CREATE TABLE Bookings_2025 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM (2025) TO (2026);

-- Alternative MySQL syntax for partitioning
CREATE TABLE Bookings_MySQL_Partitioned (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Step 3: Create indexes on partitioned table
CREATE INDEX idx_bookings_part_start_date ON Bookings_Partitioned(start_date);
CREATE INDEX idx_bookings_part_user_id ON Bookings_Partitioned(user_id);
CREATE INDEX idx_bookings_part_property_id ON Bookings_Partitioned(property_id);

-- Step 4: Migrate data from original table to partitioned table
INSERT INTO Bookings_Partitioned 
SELECT * FROM Bookings;

-- PERFORMANCE TESTING QUERIES

-- Test 1: Query specific date range (single partition)
EXPLAIN ANALYZE
SELECT booking_id, user_id, start_date, end_date, total_price
FROM Bookings_Partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31';

-- Test 2: Query across multiple partitions
EXPLAIN ANALYZE
SELECT booking_id, user_id, start_date, end_date, total_price
FROM Bookings_Partitioned
WHERE start_date BETWEEN '2023-06-01' AND '2024-06-30';

-- Test 3: Aggregate query on single partition
EXPLAIN ANALYZE
SELECT COUNT(*) as total_bookings, 
       AVG(total_price) as avg_price,
       MONTH(start_date) as booking_month
FROM Bookings_Partitioned
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY MONTH(start_date);

-- Test 4: JOIN query with partitioned table
EXPLAIN ANALYZE
SELECT b.booking_id, u.user_name, p.property_name, b.start_date
FROM Bookings_Partitioned b
JOIN Users u ON b.user_id = u.user_id
JOIN Properties p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
AND b.status = 'confirmed';

-- COMPARISON WITH NON-PARTITIONED TABLE

-- Non-partitioned query for comparison
EXPLAIN ANALYZE
SELECT booking_id, user_id, start_date, end_date, total_price
FROM Bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-03-31';

-- PARTITION MAINTENANCE COMMANDS

-- Add new partition for 2026
ALTER TABLE Bookings_Partitioned ADD PARTITION (
    PARTITION p2026 VALUES LESS THAN (2027)
);

-- Drop old partition (removes data permanently)
-- ALTER TABLE Bookings_Partitioned DROP PARTITION p2022;

-- View partition information
SELECT 
    table_name,
    partition_name,
    table_rows,
    data_length,
    index_length
FROM information_schema.partitions 
WHERE table_schema = DATABASE() 
AND table_name = 'Bookings_Partitioned';

-- Check which partition a specific query will use
EXPLAIN PARTITIONS
SELECT * FROM Bookings_Partitioned 
WHERE start_date = '2024-06-15';
