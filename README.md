# SQL Query Optimization Assignment

## Overview
This assignment demonstrates the process of optimizing a complex SQL query using syntax refactoring with CTEs / optimized joins, indexes and index hints. CSV-Data for tables was generated with Python script in `dbeaver_run`. 

## Project Structure
```
.
├── README.md
├── query_versions/
│   ├── original_query.sql
│   ├── step1_refactor.sql
│   ├── step2_indexing.sql
├── execution_plans/
│   ├── original_plan.txt
│   ├── step1_plan.txt
│   ├── step2_plan.txt
├── dbeaver_run/
│   ├── csv/
│   ├── run_queries.sql
│   ├── database_setup.sql
├── explanations/
│   └── optimization_steps.md
.
```

## Performance Metrics
Each optimization step will be evaluated based on execution time

# Query Optimization Steps Summary
| Step | Description | Execution Time | Improvement |
|------|-------------|----------------|-------------|
| 0 | Original Query (complex joins, no optimization) | 68.4 seconds | Baseline |
| 1 | Query Refactoring with CTEs and improved joins | 50.9 seconds | 25.6% faster |
| 2 | Index Optimization with covering indexes and hints | 20.1 seconds | 70.6% faster than original |

The optimization process achieved a total performance improvement of 70.6%, reducing query execution time from 68.4 seconds to 20.1 seconds through logical restructuring and proper indexing strategies. See `explanations/optimization_steps.md` for detailed explanations of each step.


