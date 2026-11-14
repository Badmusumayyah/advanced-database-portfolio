CREATE OR REPLACE PROCEDURE transfer_funds(p_from BIGINT, p_to BIGINT, p_amount NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE
  v_from_bal NUMERIC;
  v_to_bal   NUMERIC;
  v_tid      BIGINT;
BEGIN
  -- Lock both accounts (always in id order, to prevent deadlocks)
  PERFORM 1 FROM accounts WHERE account_id IN (p_from, p_to)
  ORDER BY account_id FOR UPDATE;

  UPDATE accounts SET balance = balance - p_amount
  WHERE account_id = p_from RETURNING balance INTO v_from_bal;

  UPDATE accounts SET balance = balance + p_amount
  WHERE account_id = p_to RETURNING balance INTO v_to_bal;

  INSERT INTO transfers (from_account, to_account, amount, status)
  VALUES (p_from, p_to, p_amount, 'completed') RETURNING transfer_id INTO v_tid;

  INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after)
  VALUES (p_from, v_tid, 'transfer_out', p_amount, v_from_bal),
         (p_to,   v_tid, 'transfer_in',  p_amount, v_to_bal);
END;
$$;