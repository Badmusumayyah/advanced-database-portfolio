-- Q1: Find all accounts of one customer
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM accounts WHERE customer_id = 12345;

-- Q2: Last 30 days of transactions for one account
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM transactions
WHERE account_id = 500 AND created_at >= now() - interval '30 days'
ORDER BY created_at DESC;

-- Q3: Top 10 customers by total completed transfers sent
EXPLAIN (ANALYZE, BUFFERS)
SELECT c.customer_id, c.full_name, SUM(t.amount) AS total_sent
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transfers t ON t.from_account = a.account_id
WHERE t.status = 'completed'
GROUP BY c.customer_id, c.full_name
ORDER BY total_sent DESC
LIMIT 10;