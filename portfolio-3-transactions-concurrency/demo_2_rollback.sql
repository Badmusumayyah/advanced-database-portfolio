-- Part A: transfer more than the balance (violates CHECK balance >= 0)
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2) ORDER BY account_id;

BEGIN;
CALL transfer_funds(1, 2, 999999);   -- this will ERROR
ROLLBACK;

-- Balances unchanged: the failed transfer left no trace
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2) ORDER BY account_id;

-- Part B: manual rollback
BEGIN;
UPDATE accounts SET balance = 0 WHERE account_id = 1;
SELECT account_id, balance FROM accounts WHERE account_id = 1;  -- shows 0 inside the transaction
ROLLBACK;
SELECT account_id, balance FROM accounts WHERE account_id = 1;  -- back to 7500