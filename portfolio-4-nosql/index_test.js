db = db.getSiblingDB('nairapay');
const acct = db.customers.findOne({ customerId: 100 }).accounts[0].accountNumber;
db.transactions.dropIndexes();

function plan(label) {
  const e = db.transactions.find({ accountNumber: acct }).sort({ createdAt: -1 }).explain('executionStats');
  const usesIndex = JSON.stringify(e.queryPlanner.winningPlan).includes('IXSCAN');
  print(label + ' | scan: ' + (usesIndex ? 'IXSCAN (index)' : 'COLLSCAN (full scan)') +
        ' | docsExamined: ' + e.executionStats.totalDocsExamined +
        ' | returned: ' + e.executionStats.nReturned +
        ' | ms: ' + e.executionStats.executionTimeMillis);
}

plan('BEFORE index');
db.transactions.createIndex({ accountNumber: 1, createdAt: -1 });
plan('AFTER index ');