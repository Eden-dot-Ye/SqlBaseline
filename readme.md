# SQL Performanc Baseline

## File Structure
```
compare_index.sql - Compare the performance of clustered and non-clustered indexes
```

## File Description

### compare_index.sql

In this file, we will compare the performance of clustered and non-clustered indexes using the following steps:
- Create a table with same structure with dbo.AccChargeCreditorOverride (with out FK)
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