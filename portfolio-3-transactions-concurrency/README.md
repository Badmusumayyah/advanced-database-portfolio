# Portfolio 3: Transactions and Concurrency

## Transfer procedure
`transfer_procedure.sql` defines `transfer_funds(from, to, amount)`. It locks both accounts, debits one, credits the other, and writes a transfer record plus two ledger entries. Accounts are locked in id order to prevent deadlocks.

## ACID demonstrated
- **Atomicity:** `demo2_rollback.sql`. A transfer exceeding the balance violates `CHECK (balance >= 0)`. The whole transaction rolls back and no partial change remains.
- **Consistency:** database constraints (CHECK, FOREIGN KEY) reject invalid states.
- **Isolation:** demo 4 below.
- **Durability:** after COMMIT (`demo1_commit.sql`) the change is permanent.

## Demo 1: COMMIT
Transfer of 2500 from account 1 to 2. Balances changed 10000/10000 to 7500/12500 and ledger rows were created. Output: `results/demo1_commit.txt`.

## Demo 2: ROLLBACK
Failed transfer left balances unchanged. A manual `ROLLBACK` reverted an `UPDATE`. Output: `results/demo2_rollback.txt`.

## Demo 3: Concurrency problem and control
- **Problem (lost update):** two transactions read balance 10000, then wrote 9000 and 9500. Final balance was 9500; the correct value is 8500.
- **Fix:** `SELECT ... FOR UPDATE` locks the row. The second transaction waited, then read the updated balance (9000), and the final result was correct (8500).

## Demo 4: Isolation levels
- **READ COMMITTED (default):** a repeated SELECT inside one transaction saw another transaction's committed change (non-repeatable read).
- **REPEATABLE READ:** the transaction kept its snapshot and saw the same value until it finished.
- Trade-off: stronger isolation gives more consistency but can cause more serialization failures and retries under heavy load.

## Evidence
Screenshots in `results/`.