-- Reset two test accounts to known balances
UPDATE accounts SET balance = 10000, status = 'active' WHERE account_id IN (1, 2);

-- Balances BEFORE
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2) ORDER BY account_id;

BEGIN;
CALL transfer_funds(1, 2, 2500);
COMMIT;

-- Balances AFTER (expect 7500 and 12500)
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2) ORDER BY account_id;

-- Ledger entries created by the transfer
SELECT txn_id, account_id, txn_type, amount, balance_after
FROM transactions WHERE transfer_id = (SELECT max(transfer_id) FROM transfers);