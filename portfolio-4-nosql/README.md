# Portfolio 4: NoSQL and Advanced Data Models

## Model chosen: document database (MongoDB)
Same case study as Portfolios 1-3: NairaPay digital bank.

## Data model
**customers** (5,000 documents): customer details with accounts **embedded** as an array.
**transactions** (50,000 documents): one document per ledger entry, with a flexible `metadata` object.

## Design decisions
- **Embedding accounts in customers:** a customer's accounts are almost always read together with the customer, so one read replaces a SQL join. A customer has a small, bounded number of accounts, so documents stay small.
- **Separate transactions collection:** transactions grow without limit. Embedding them would hit MongoDB's 16 MB document limit and make documents slow to update.
- **Flexible metadata:** mobile transactions store device/appVersion, USSD stores network, ATM stores atmId. In SQL this needs many nullable columns or extra tables; in MongoDB each document holds only the fields that apply.

## Implementation evidence
- `seed.js`: creates data. Output: `results/seed_output.txt`
- `queries.js`: find, nested query, sort, aggregation, embedded update. Output: `results/queries_output.txt`
- `index_test.js`: index comparison. Output: `results/index_test_output.txt`

## Index result
| | Scan type | Docs examined | Time (ms) |
|---|---|---|---|
| Before index | COLLSCAN | 50,000 | __ |
| After index `{accountNumber:1, createdAt:-1}` | IXSCAN | __ | __ |

## Suitability: when MongoDB fits and when it does not
**Good fit:** customer profiles, transaction history, activity logs, and event data. These are read-heavy, have varied shapes, and benefit from embedded data and horizontal scaling.
**Poor fit:** the core money-moving ledger. PostgreSQL gives strict ACID transactions, foreign keys, and constraints (`CHECK balance >= 0`) by default. MongoDB cannot enforce relationships between collections, and multi-document transactions need a replica set and are heavier.
**Conclusion:** a realistic fintech design is polyglot. PostgreSQL holds balances and transfers (correctness). MongoDB holds profiles, activity feeds, and flexible logs (flexibility and scale).

## How to run
1. Start MongoDB with Docker  2. Run `seed.js`  3. Run `queries.js`  4. Run `index_test.js`