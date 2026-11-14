# Portfolio 1: Database Design and Modelling

## Case study
**Organisation:** NairaPay, a simulated Nigerian digital bank.
**Users:** customers, support staff, auditors, the transfer service.
**Major data:** customers, accounts, account types, transfers, ledger transactions, audit logs.
**Key operations:** open account, deposit, withdraw, transfer funds, reverse failed transfers, audit balances.

## Design
- Primary keys uniquely identify each row.
- Foreign keys link tables (e.g. each account belongs to one customer).
- CHECK constraints enforce rules (balance can't be negative, transfer amount must be positive).
- UNIQUE constraints prevent duplicates (email, account number).

## Normalisation
- **1NF:** every column holds one value; no repeating groups.
- **2NF:** every non-key column depends on the whole primary key.
- **3NF:** account type details (minimum balance, interest rate) are in `account_types`, not repeated in `accounts`.
- `accounts.balance` is a deliberate denormalisation for fast reads; the `transactions` ledger is the audit source of truth.

## How to run
`docker exec -i bank-pg psql -U postgres -d bankdb < schema.sql`

## Evidence
See screenshots in this folder.