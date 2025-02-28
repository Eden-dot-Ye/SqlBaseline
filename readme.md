# SQL Performanc Baseline

## File Structure
```
compare_index_query_and_rebuild.sql - Compare the performance of clustered and non-clustered indexes when querying and rebuilding indexes
compare_index_using_same_column.sql - Compare clustered and non-clustered indexes for same column, which will be used in query
```

## File Description

### compare_index_query_and_rebuild.sql

In this file, we will compare the performance of clustered and non-clustered indexes using the following steps:
- Create a table with same structure with dbo.AccChargeCreditorOverride (without FK)
- Create a clustered index on the table
- Create a table with 1000/10000/100000/1000000 rows
- Do the below experiment 10 times
  - Randomly query 100 times and recorded the time cost (clear buffer and cache before each query)
  - Rebuild the index 
- Truncate the table
- Drop the clustered index
- Create a **non**-clustered index on the table
- Do the below experiment 10 times
  - Randomly query 100 times and recorded the time cost (clear buffer and cache before each query)
  - Rebuild the index

Results:

```
Table size: 1000
Average query costs (clustered indexes): 128ms
Average index rebuild costs (clustered indexes): 19ms
Average query costs (non-clustered indexes): 104ms
Average index rebuild costs (non-clustered indexes): 11ms

Table size: 10000
Average query costs (clustered indexes): 141ms
Average index rebuild costs (clustered indexes): 68ms
Average query costs (non-clustered indexes): 127ms
Average index rebuild costs (non-clustered indexes): 40ms

Table size: 100000
Average query costs (clustered indexes): 117ms
Average index rebuild costs (clustered indexes): 292ms
Average query costs (non-clustered indexes): 123ms
Average index rebuild costs (non-clustered indexes): 222ms

Table size: 1000000
Average query costs (clustered indexes): 65ms
Average index rebuild costs (clustered indexes): 4513ms
Average query costs (non-clustered indexes): 137ms
Average index rebuild costs (non-clustered indexes): 1931ms
```

### compare_index_using_same_column.sql

In this file, we will compare for clustered and non-clustered indexes for same column, which will be used in query using the following steps:
- Create a table with same structure with dbo.AccChargeCreditorOverride (without FK)
- Create a clustered index on the table
- Create a **non**-clustered index on the table with the same column
- Create a table with 1000/10000/100000/1000000 rows
- Do the below experiment 10 times
  - Randomly query 100 times and recorded the time cost (clear buffer and cache before each query)
  - Check which index is used in the query

Results:

```
compare_index_using_same_column_1000_rows.json - using clustered index
compare_index_using_same_column_10000_rows.json - using clustered index
compare_index_using_same_column_100000_rows.json - using non-clustered index first, then clustered index 
compare_index_using_same_column_1000000_rows.json - using non-clustered index first, then clustered index

And if we use include to contain all column in non-clustered index, the result will be all using non-clustered index only.
```

Perfromance comparison between clustered & non-clustered indexes and covering index (query 100 times):

```
1000 rows: 3ms vs 2ms
10000 rows: 2ms vs 4ms
100000 rows: 4ms vs 4ms
1000000 rows: 3ms vs 7ms
```