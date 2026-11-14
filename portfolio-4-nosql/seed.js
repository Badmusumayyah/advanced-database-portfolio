db = db.getSiblingDB('nairapay');
db.dropDatabase();

const types = ['Savings', 'Current', 'Fixed Deposit'];
const kyc = ['pending', 'verified', 'verified', 'verified', 'rejected'];
const acctStatus = ['active', 'active', 'active', 'frozen', 'closed'];
const txnTypes = ['deposit', 'withdrawal', 'transfer_in', 'transfer_out', 'reversal'];
const channels = ['mobile', 'web', 'ussd', 'atm'];
const banks = ['GTBank', 'Access', 'Zenith', 'UBA', 'First Bank'];
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
const money = (max) => Math.round(Math.random() * max * 100) / 100;

// Customers with EMBEDDED accounts
const customers = [];
const accountNumbers = [];
for (let i = 1; i <= 5000; i++) {
  const accounts = [];
  const n = 1 + Math.floor(Math.random() * 3);
  for (let j = 0; j < n; j++) {
    const num = String(i * 10 + j).padStart(10, '0');
    accountNumbers.push(num);
    accounts.push({
      accountNumber: num,
      type: pick(types),
      balance: money(1000000),
      currency: 'NGN',
      status: pick(acctStatus)
    });
  }
  customers.push({
    customerId: i,
    fullName: 'Customer ' + i,
    email: 'customer' + i + '@nairapay.test',
    phone: '080' + String(Math.floor(Math.random() * 99999999)).padStart(8, '0'),
    kycStatus: pick(kyc),
    accounts: accounts,
    createdAt: new Date(Date.now() - Math.random() * 730 * 86400000)
  });
}
db.customers.insertMany(customers);

// Transactions with FLEXIBLE metadata (different shape per channel)
let batch = [];
for (let k = 0; k < 50000; k++) {
  const channel = pick(channels);
  const txn = {
    accountNumber: pick(accountNumbers),
    type: pick(txnTypes),
    amount: money(50000),
    channel: channel,
    createdAt: new Date(Date.now() - Math.random() * 365 * 86400000),
    metadata: {}
  };
  if (channel === 'mobile') txn.metadata = { device: pick(['android', 'ios']), appVersion: '3.' + Math.floor(Math.random() * 9) };
  if (channel === 'ussd') txn.metadata = { network: pick(['MTN', 'Airtel', 'Glo']) };
  if (channel === 'atm') txn.metadata = { atmId: 'ATM' + Math.floor(Math.random() * 500) };
  if (channel === 'web') txn.metadata = { browser: pick(['Chrome', 'Firefox', 'Safari']) };
  if (txn.type === 'transfer_out') txn.metadata.beneficiaryBank = pick(banks);
  batch.push(txn);
  if (batch.length === 5000) { db.transactions.insertMany(batch); batch = []; }
}

print('customers: ' + db.customers.countDocuments());
print('transactions: ' + db.transactions.countDocuments());