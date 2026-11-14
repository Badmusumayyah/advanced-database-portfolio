INSERT INTO account_types (type_name, min_balance, interest_rate) VALUES
('Savings', 0, 4.50), ('Current', 0, 0), ('Fixed Deposit', 50000, 10.00);

INSERT INTO customers (full_name, email, phone, kyc_status, created_at)
SELECT 'Customer ' || g,
       'customer' || g || '@nairapay.test',
       '080' || lpad((random()*99999999)::int::text, 8, '0'),
       (ARRAY['pending','verified','verified','verified','rejected'])[1 + floor(random()*5)::int],
       now() - (random()*730 || ' days')::interval
FROM generate_series(1, 50000) g;

INSERT INTO accounts (customer_id, type_id, account_number, balance, status, opened_at)
SELECT 1 + (g % 50000),
       1 + (g % 3),
       lpad(g::text, 10, '0'),
       round((random()*1000000)::numeric, 2),
       (ARRAY['active','active','active','active','frozen','closed'])[1 + floor(random()*6)::int],
       now() - (random()*700 || ' days')::interval
FROM generate_series(1, 100000) g;

INSERT INTO transfers (from_account, to_account, amount, status, created_at)
SELECT f,
       ((f + floor(random()*99999)::int) % 100000) + 1,
       round((100 + random()*50000)::numeric, 2),
       (ARRAY['completed','completed','completed','failed','reversed','pending'])[1 + floor(random()*6)::int],
       now() - (random()*365 || ' days')::interval
FROM (SELECT 1 + floor(random()*100000)::int AS f FROM generate_series(1, 200000)) s;

INSERT INTO transactions (account_id, txn_type, amount, balance_after, created_at)
SELECT 1 + floor(random()*100000)::int,
       (ARRAY['deposit','withdrawal','transfer_in','transfer_out','reversal'])[1 + floor(random()*5)::int],
       round((100 + random()*50000)::numeric, 2),
       round((random()*1000000)::numeric, 2),
       now() - (random()*365 || ' days')::interval
FROM generate_series(1, 500000);

ANALYZE;