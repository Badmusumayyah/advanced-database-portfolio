db = db.getSiblingDB('nairapay');
const acct = db.customers.findOne({ customerId: 100 }).accounts[0].accountNumber;

print('--- Q1: Find a customer by email (accounts come embedded, no join) ---');
printjson(db.customers.findOne({ email: 'customer100@nairapay.test' }));

print('--- Q2: Customers with a frozen account (query inside embedded array) ---');
printjson(db.customers.find({ 'accounts.status': 'frozen' }, { fullName: 1, 'accounts.accountNumber': 1 }).limit(3).toArray());

print('--- Q3: Last 5 transactions for one account ---');
printjson(db.transactions.find({ accountNumber: acct }).sort({ createdAt: -1 }).limit(5).toArray());

print('--- Q4: Total and count per transaction type (aggregation) ---');
printjson(db.transactions.aggregate([
  { $group: { _id: '$type', total: { $sum: '$amount' }, count: { $sum: 1 } } },
  { $sort: { total: -1 } }
]).toArray());

print('--- Q5: Transactions per channel (flexible metadata, differs per document) ---');
printjson(db.transactions.aggregate([
  { $group: { _id: '$channel', count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]).toArray());

print('--- Q6: Update a balance inside an embedded account ---');
printjson(db.customers.updateOne(
  { 'accounts.accountNumber': acct },
  { $inc: { 'accounts.$.balance': 1000 } }
));