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
3. **Index Hints Implementation**
   - Used FORCE INDEX hints to ensure the query optimizer uses our specific indexes
   - Applied idx_orders_date_status to both orders table references
   - Used idx_order_items_product for order_items joins
   - Enforced idx_products_category for products table joins
   - Applied idx_categories_name for categories table lookups
   - These hints helped ensure consistent index usage across all query components

4. **Index Usage Strategy**
   - Composite indexes were designed to support both filtering and joining operations
   - Index order was optimized for the most common access patterns
   - Index hints were necessary because the query optimizer sometimes chose suboptimal execution plans
   - The combination of proper index design and forced usage led to significant performance improvements

5. **Performance Impact**
   - Reduced full table scans
   - Improved join performance
   - Better filtering efficiency
   - Execution time dropped from 38ms to 16ms

