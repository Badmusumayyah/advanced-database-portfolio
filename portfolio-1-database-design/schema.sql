CREATE TABLE customers (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE,
  phone       VARCHAR(20),
  kyc_status  VARCHAR(10) NOT NULL DEFAULT 'pending'
              CHECK (kyc_status IN ('pending','verified','rejected')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE account_types (
  type_id      SMALLSERIAL PRIMARY KEY,
  type_name    VARCHAR(30) NOT NULL UNIQUE,
  min_balance  NUMERIC(14,2) NOT NULL DEFAULT 0,
  interest_rate NUMERIC(5,2) NOT NULL DEFAULT 0
);

CREATE TABLE accounts (
  account_id     BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT NOT NULL REFERENCES customers(customer_id),
  type_id        SMALLINT NOT NULL REFERENCES account_types(type_id),
  account_number CHAR(10) NOT NULL UNIQUE,
  balance        NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
  currency       CHAR(3) NOT NULL DEFAULT 'NGN',
  status         VARCHAR(10) NOT NULL DEFAULT 'active'
                 CHECK (status IN ('active','frozen','closed')),
  opened_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE transfers (
  transfer_id  BIGSERIAL PRIMARY KEY,
  from_account BIGINT NOT NULL REFERENCES accounts(account_id),
  to_account   BIGINT NOT NULL REFERENCES accounts(account_id),
  amount       NUMERIC(14,2) NOT NULL CHECK (amount > 0),
  status       VARCHAR(10) NOT NULL DEFAULT 'pending'
               CHECK (status IN ('pending','completed','failed','reversed')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (from_account <> to_account)
);

CREATE TABLE transactions (
  txn_id        BIGSERIAL PRIMARY KEY,
  account_id    BIGINT NOT NULL REFERENCES accounts(account_id),
  transfer_id   BIGINT REFERENCES transfers(transfer_id),
  txn_type      VARCHAR(15) NOT NULL
                CHECK (txn_type IN ('deposit','withdrawal','transfer_in','transfer_out','reversal')),
  amount        NUMERIC(14,2) NOT NULL CHECK (amount > 0),
  balance_after NUMERIC(14,2) NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_log (
  audit_id   BIGSERIAL PRIMARY KEY,
  table_name VARCHAR(40) NOT NULL,
  record_id  BIGINT NOT NULL,
  action     VARCHAR(10) NOT NULL,
  old_data   JSONB,
  new_data   JSONB,
  changed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);