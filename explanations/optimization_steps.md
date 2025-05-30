# Query Optimization Steps and Explanations

## Optimization Process

### Step 1: Query Refactoring
1. **Original Query Analysis**
   - The original query used multiple LEFT JOINs which could lead to inefficient execution
   - Complex WHERE clause with date filtering and status check
   - Multiple aggregations in a single query

2. **Refactoring Changes**
   - Introduced CTEs to break down the complex query into logical components
   - Changed LEFT JOINs to INNER JOINs
   - Separated the order total calculation into its own CTE

3. **Performance Impact**
   - Execution time increased from 27ms to 38ms. While CTEs improved code readability and maintainability, they introduced overhead. This demonstrates that structural improvements don't always improve performance.

### Step 2: Index Optimization
1. **Index Changes**
   - Created composite index on orders(order_date, status) for efficient filtering
   - Added index on order_items(order_id, product_id) for join optimization
   - Created index on products(product_id, category_id) for category lookups
   - Added index on categories(category_id, category_name) for name retrieval

2. **Performance Impact**
   - Reduced full table scans
   - Improved join performance
   - Better filtering efficiency
   - Execution time dropped from 38ms to 16ms

