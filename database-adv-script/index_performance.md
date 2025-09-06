# Database Index Performance Optimization

## High-Usage Columns Identified

### Users Table
- `email` - Used in WHERE clauses for login queries
- `user_id` - Primary key, used in JOINs

### Bookings Table  
- `user_id` - Used in JOINs with Users table
- `property_id` - Used in JOINs with Properties table
- `check_in_date` - Used in WHERE clauses for date filtering

### Properties Table
- `location` - Used in WHERE clauses for location searches
- `property_id` - Primary key, used in JOINs

### Reviews Table
- `property_id` - Used in JOINs with Properties table
- `rating` - Used in WHERE clauses for filtering

## CREATE INDEX Commands

```sql
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
```

## Performance Testing Queries

### Test 1: User lookup by email
```sql
-- Before index
EXPLAIN ANALYZE
SELECT user_id, user_name FROM Users WHERE email = 'test@example.com';

-- After creating idx_users_email, run the same query
```

### Test 2: Bookings by user
```sql
-- Before index
EXPLAIN ANALYZE
SELECT * FROM Bookings WHERE user_id = 1;

-- After creating idx_bookings_user_id, run the same query
```

### Test 3: Properties by location
```sql
-- Before index
EXPLAIN ANALYZE
SELECT * FROM Properties WHERE location = 'New York';

-- After creating idx_properties_location, run the same query
```

### Test 4: Date range bookings
```sql
-- Before index
EXPLAIN ANALYZE
SELECT * FROM Bookings 
WHERE check_in_date BETWEEN '2024-01-01' AND '2024-12-31';

-- After creating idx_bookings_checkin_date, run the same query
```

### Test 5: Property reviews with rating filter
```sql
-- Before index
EXPLAIN ANALYZE
SELECT p.property_name, r.rating, r.comment
FROM Properties p
JOIN Reviews r ON p.property_id = r.property_id
WHERE r.rating >= 4.0;

-- After creating idx_reviews_property_id and idx_reviews_rating, run the same query
```

### Test 6: Complex query with multiple JOINs
```sql
-- Before index
EXPLAIN ANALYZE
SELECT u.user_name, p.property_name, b.check_in_date, b.check_out_date
FROM Users u
JOIN Bookings b ON u.user_id = b.user_id
JOIN Properties p ON b.property_id = p.property_id
WHERE u.email = 'test@example.com'
ORDER BY b.check_in_date DESC;

-- After creating all indexes, run the same query
```

## Expected Performance Improvements

- **User email lookup**: 50-100x faster with email index
- **JOIN operations**: 10-50x faster with foreign key indexes  
- **Date range queries**: 20-100x faster with date indexes
- **Location searches**: 25-75x faster with location index
- **Rating filters**: 15-40x faster with rating index

## Instructions for Testing

1. Run each EXPLAIN ANALYZE query before creating indexes
2. Note the execution time and query plan
3. Create the indexes using the CREATE INDEX commands
4. Run the same EXPLAIN ANALYZE queries again
5. Compare the performance improvements