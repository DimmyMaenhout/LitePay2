import Foundation


enum Permissions : String {
    
    /*  Account  */

    //List user’s accounts and their balances
    case userAccountsAndBalance = "wallet:accounts:read"
    //update account (e.g. change name)
    case updateAccount = "wallet:accounts:update"
    //create new account (e.g BTC wallet)
    case createAccount = "wallet:accounts:create"
    //delete existing account
    case deleteAccount = "wallet:accounts:delete"
    
    
    /*  Address  */
    //Address resource represents a bitcoin, bitcoin cash, litecoin or ethereum address for an account. Account can have unlimited amount of addresses and they should be used only once.
    
    //List account’s bitcoin or ethereum addresses
    case readAccountAddresses = "wallet:addresses:read"
    //Create new LTC addresses for wallets
    case createAddress = "wallet:addresses:create"
    //delete existing account
    case deleteAddress = "wallet:addresses:delete"
    //List account's buys
    case readBuys = "wallet:buys:read"
    //Buy BTC or ETH
    case createBuy = "wallet:buys:create"
    //List users merchant checkouts
    case readCheckouts = "wallet:checkouts:read"
    //create a new merchant checkout
    case createCheckout = "wallet:checkouts:create"
    //list accounts deposits
    case readDeposits = "wallet:deposits:read"
    //create a new deposit
    case createDeposit = "wallet:deposits:create"
    //list users notifications
    case readNotifications = "wallet:notifications:read"
    //list users merchant order
    case readOrders = "wallet:orders:read"
    //create a new merchant order
    case createOrder = "wallet:orders:create"
    //refund merchant order
    case refundOrder = "wallet:orders:refund"
    //list users payment methods
    case readPaymentMethods = "wallet:payment-method:read"
    //remvoe existing payment methods
    case deletePaymentMethods = "wallet:payment-method:delete"
    //Get detailed limits for payment methods, is used together with wallet:payment-methods:read
    case readPaymentMethodsLimits = "wallet:payment-methods:limits"
    //list accounts sells
    case readSells = "wallet:sells:read"
    //Sell BTC or ETH
    case createSells = "wallet:sells:create"
    //list accounts transactions
    case readTransactions = "wallet:transactions:read"
    //Send BTC or ETH
    case sendTransaction = "wallet:transactions:send"
    //Request BTC or ETH from a Coinbase user
    case requestTransaction = "wallet:transactions:request"
    //Transfer funds between users two BTC or ETH accounts
    case transferTransaction = "wallet:transactions:funds"
    //list detailed user information
    case readUser = "wallet:user:read"
    //update current user
    case updateUser = "wallet:user:update"
    //read Current users email address
    case readEmailAddress = "wallet:user:email"
    //list account withdrawals
    case readWithDrawals = "wallet:withdrawals:read"
    //create a new withdrawel
    case createWithDrawal = "wallet:withdrawals:create"
    
    static let allRequestedPermissions = [userAccountsAndBalance,
                                          updateAccount,
                                          createAccount,
                                          deleteAccount,
                                          readAccountAddresses,
                                          createAddress,
                                          deleteAddress,
                                          readBuys,
                                          createBuy,
                                          readCheckouts,
                                          createCheckout,
                                          readDeposits,
                                          readNotifications,
                                          readOrders,
                                          createOrder,
                                          refundOrder,
                                          readPaymentMethods,
                                          deletePaymentMethods,
                                          readPaymentMethodsLimits,
                                          readTransactions,
                                          sendTransaction,
                                          requestTransaction,
                                          transferTransaction,
                                          readUser,
                                          updateUser,
                                          readEmailAddress,
                                          readWithDrawals,
                                          createWithDrawal]
}
