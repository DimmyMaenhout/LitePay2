import Foundation
import UIKit
import coinbase_official

class SelectAccountViewController : UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    var accounts : [CoinbaseAccount] = []
    //dict accountIDs has currencies as keys and account's id's as values
    //there can be multiple accounts with the same currency, so we use an array
    var currencyAccountIDs : [String: [CoinbaseAccount]] = [:]
    
                /*      Belangrijk      */
    /*  Todo reload table data moet nog aangeroepen worden  */
                /*      Belangrijk!     */
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        getAccounts()
    }
    
    //Gets all of the users accounts (wallets)
    func getAccounts()  {
        
        let accessTkn = UserDefaults.standard.object(forKey: "access_token")
        print("Home view controller line 86, accessTkn: \(String(describing: accessTkn))")
        //If accessTkn has a value (not nil) go in statement
        if let accessToken = accessTkn
        {
            client = Coinbase(oAuthAccessToken: accessToken as! String)
            //If client has a value (not nil) go in statement
            if let client = client
            {
                client.getAccountsList({( accounts : [Any]?, pagingHelper : CoinbasePagingHelper?, error : Error?) -> Void in
                    //If there is an error, show alert
                    print("Home view controller line 94, got till here")
                    if error != nil{
                        print("Home view controller line 96, error occured when trying to get accounts. error: \(String(describing: error?.localizedDescription))")
                        
                        let alert = UIAlertController(title: "Error", message: "Er is een fout opgtreden bij het ophalen van de accounts", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                        print("Home view controller line 102, exiting method getAccounts")
                        return
                    }
                    print("Home view controller line 105, got till here")
                    //If accounts is nil go in (else) statement
                    guard let accounts = accounts else
                    {
                        print("Home view controller line 109, accounts is nil, exiting method getAccounts")
                        return
                    }
                    //If pagingHelper is nil go in (else) statement
                    guard let pagingHelper = pagingHelper else
                    {
                        print("Home view controller line 115, pagingHelper is nil, exiting method getAccounts")
                        return
                    }
                    
                    self.accounts = accounts as! [CoinbaseAccount]
                    print("Home view controller line 122, # accounts: \(accounts.count)")
                    print("Home view controller line 123, # account in self.accounts: \(self.accounts.count)")
                    self.getAccountIDs(self.accounts)
                    self.tableView.reloadData()
                    
                })
                
                /*print(self)
                 return self.accounts;*/
            }
            else {
                print("Home view controller line 131, client is nil: \(String(describing: client))")
            }
        }
    }
    
    func getAccountIDs(_ accounts : [CoinbaseAccount]) -> [String : String] {
        
        var ltc : [CoinbaseAccount] = []
        var btc : [CoinbaseAccount] = []
        var bch : [CoinbaseAccount] = []
        var eth : [CoinbaseAccount] = []
        var eur : [CoinbaseAccount] = []
        var other: [CoinbaseAccount] = []
        var ltcAccountIDs : [String: String] = [:]
        //var ltcIDs : [String] = []    Mag waarschijnlijk verwijderd worden
        
        print("Select Account view controller line 100, accessed method getAccountsIDs")
        for account in self.accounts {
            
            switch(account.balance.currency){
            case "\(CurrencyCode.LTC)":
                ltc.append(account)
                currencyAccountIDs["\(CurrencyCode.LTC)"] = ltc
                print("Home view controller line 156, LTC account id: \(account.accountID)")
                //ltcIDs.append(account.accountID) Mag waarschijnlijk verwijderd worden
                //ltcAccountIDs["\(account.name)"] = ltcIDs
                ltcAccountIDs["\(account.name)"] = account.accountID
                print("Home view controller line 164, ltcAccountIDs # \(ltcAccountIDs.count), ltcAccountIDS name: \(account.name), accountID: \(account.accountID)")
                
                
            case "\(CurrencyCode.BTC)":
                btc.append(account)
                currencyAccountIDs["\(CurrencyCode.BTC)"] = btc
                
            case "\(CurrencyCode.BCH)":
                bch.append(account)
                currencyAccountIDs["\(CurrencyCode.BCH)"] = bch
                
            case "\(CurrencyCode.ETH)":
                eth.append(account)
                currencyAccountIDs["\(CurrencyCode.ETH)"] = eth
                
            case "\(CurrencyCode.EUR)":
                eur.append(account)
                currencyAccountIDs["\(CurrencyCode.EUR)"] = eur
                
            default:
                other.append(account)
                currencyAccountIDs["\(CurrencyCode.OTHER)"] = other
            }
            
        }
        print("home view controller line 180, currencyAccountIDs for LTC: \(String(describing: currencyAccountIDs["\(CurrencyCode.LTC)"]?.count)) \n currencyAccountIDs for BTC: \(String(describing: currencyAccountIDs["\(CurrencyCode.BTC)"]?.count)) \n currencyAccountIDs for BCH: \(String(describing: currencyAccountIDs["\(CurrencyCode.BCH)"]?.count)) \n currencyAccountIDs for ETH: \(String(describing: currencyAccountIDs["\(CurrencyCode.ETH)"]?.count)) \n currencyAccountIDs for EUR: \(String(describing: currencyAccountIDs["\(CurrencyCode.EUR)"]?.count)) \n currencyAccountIDs for OTHER: \(String(describing: currencyAccountIDs["\(CurrencyCode.OTHER)"]?.count))")
        
        //return currencyAccountIDs
        return ltcAccountIDs
    }
    
}
extension SelectAccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //gaan naar scherm
        // performSegue(withIdentifier: "selectedMovie", sender: self)
        //performSegue(withIdentifier: "<#T##String#>", sender: self)
    }
    
}

extension SelectAccountViewController : UITableViewDataSource {
    /*  The amount of sections equals the amount of keys in currencyAccountIDs  */
    func numberOfSections(in tableView: UITableView) -> Int {
        return currencyAccountIDs.keys.count
    }
    /*  Rows in section depends on the number of valeus a key has (accounts with the same currency) */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section){
        case 0:
            let currency = "\(CurrencyCode.LTC)"
            return currencyAccountIDs[currency]?.count ?? 0
        case 1:
            let currency = "\(CurrencyCode.BTC)"
            return currencyAccountIDs[currency]?.count ?? 0
        case 2:
            let currency = "\(CurrencyCode.BCH)"
            return currencyAccountIDs[currency]?.count ?? 0
        case 4:
            let currency = "\(CurrencyCode.ETH)"
            return currencyAccountIDs[currency]?.count ?? 0
        case 5:
            let currency = "\(CurrencyCode.EUR)"
            return currencyAccountIDs[currency]?.count ?? 0
        case 6:
            let currency = "\(CurrencyCode.OTHER)"
            return currencyAccountIDs[currency]?.count ?? 0
        default:
            return 0
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountsCell
        //if section is not 0 (LTC), make the cells in section not clickable
        if indexPath.section != 0 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        switch(indexPath.section){
        case 0:
            let account = currencyAccountIDs["\(CurrencyCode.LTC)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 193, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
        case 1:
            let account = currencyAccountIDs["\(CurrencyCode.BTC)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 202, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
        case 2:
            let account = currencyAccountIDs["\(CurrencyCode.BCH)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 210, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
        case 3:
            let account = currencyAccountIDs["\(CurrencyCode.ETH)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 218, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
        case 4:
            let account = currencyAccountIDs["\(CurrencyCode.EUR)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 226, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
        case 5:
            let account = currencyAccountIDs["\(CurrencyCode.OTHER)"]![indexPath.row]
            cell.accountName.text = account.name
            guard let amount = account.balance.amount else {
                print("Select Account view controller line 234, amount is nil")
                break
            }
            cell.balance.text = "\(amount)"
        default:
            break
        }
        return cell
    }
    /*  Names for the sections  */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as! HeaderCurrencyCell
        
        switch(section){
        case 0:
            cell.currencyLabel.text = "Litecoin"
        case 1:
            cell.currencyLabel.text = "Bitcoin"
        case 2:
            cell.currencyLabel.text = "Bitcoin cash"
        case 3:
            cell.currencyLabel.text = "Ethereum"
        case 4:
            cell.currencyLabel.text = "Euro"
        case 5:
            cell.currencyLabel.text = "Other"
        default :
            break
        }
        return cell
    }
}
