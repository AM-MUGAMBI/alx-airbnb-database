this is the noramlization file.

# Normalization Analysis for Airbnb Database

- All tables comply with 1NF and 2NF because of atomic fields and single-column primary keys.
- The `Property` table's `location` attribute may contain multiple data points; to avoid redundancy, a separate `Location` table is recommended.
- The `Booking` table contains `total_price`, a derived attribute, which violates 3NF. This attribute should be removed to prevent update anomalies.
- All other tables have no transitive dependencies and meet 3NF.

By implementing these changes, the schema achieves full 3NF compliance, reducing redundancy and improving data integrity.
