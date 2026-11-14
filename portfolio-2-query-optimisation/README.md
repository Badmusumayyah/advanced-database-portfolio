# Portfolio 2: Query Processing and Optimisation

## Data
Synthetic data generated with `seed.sql`: 50,000 customers, 100,000 accounts, 200,000 transfers, 500,000 transactions.

## Queries
See `queries.sql`. Q1 finds accounts by customer, Q2 gets recent transactions for an account, Q3 ranks customers by total transfers sent.

## Results

| Query | Plan before | Time before (ms) | Plan after | Time after (ms) |
|-------|-------------|------------------|------------|-----------------|
| Q1 | Seq Scan on accounts | __ | Index Scan / Bitmap Index Scan | __ |
| Q2 | Seq Scan on transactions | __ | Index Scan | __ |
| Q3 | Seq Scan (joins) | __ | __ | __ |

Full outputs: `results/before.txt` and `results/after.txt`.

## Analysis
- Without an index on `accounts.customer_id`, PostgreSQL scanned all 100,000 rows to find one customer. PostgreSQL does not automatically index foreign keys.
- The composite index on `transactions(account_id, created_at DESC)` lets the database find one account's rows and return them already sorted by date, avoiding a full scan and a sort.
- Indexes speed up reads but slow down inserts/updates and use disk space, so only columns used in WHERE, JOIN, and ORDER BY are indexed.
- Q3 improved __ (more/less) than Q1 and Q2 because it must still aggregate many rows after joining.

## How to run
1. `seed.sql`  2. `queries.sql` (before)  3. `indexes.sql`  4. `queries.sql` (after)