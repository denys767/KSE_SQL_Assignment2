# Query Optimization Steps and Explanations

## Optimization Steps
0. Initial Query Analysis
1. Query Refactoring (CTEs, improved logic)
2. Index Optimization (covering indexes, index hints)


### Step 0 : Original Query Analysis
- The original query was complex, involving multiple joins and aggregations across several tables.
- It was executed without any indexes or logical improvements, leading to poor performance.
- Performance: +- 68.4 seconds (see `execution_plans/original_plan.txt`).

### Step 1: Query Refactoring
- Broke down the original query into CTEs for clarity and maintainability.
- Improved joins.
- Performance: +- 50.9 seconds (see `execution_plans/step1_plan.txt`).

### Step 2: Index Optimization
- Added covering indexes:
  - `orders(status, order_date)`
  - `order_items(order_id, product_id, quantity)`
  - `products(product_id, price, category_id)`
  - `categories(category_id, category_name)`
- Used `USE INDEX` hints to force the optimizer to use these indexes.
- Performance: +- 20.1 seconds (see `execution_plans/step2_plan.txt`).
- Covering indexes that match the query's join patterns can dramatically reduce execution time. Index hints (`USE INDEX`) can help the optimizer choose the best plan, especially with complex queries and CTEs.

