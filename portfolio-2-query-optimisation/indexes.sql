CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_txn_account_created ON transactions(account_id, created_at DESC);
CREATE INDEX idx_transfers_from_status ON transfers(from_account, status);
ANALYZE;
