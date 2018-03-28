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
    var currencyAccountIDs : [Int: [CoinbaseAccount]] = [:]

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
                
                currencyAccountIDs[0] = ltc
                print("Home view controller line 156, LTC account id: \(account.accountID)")
                //ltcIDs.append(account.accountID) Mag waarschijnlijk verwijderd worden
                //ltcAccountIDs["\(account.name)"] = ltcIDs
                ltcAccountIDs["\(account.name)"] = account.accountID
                print("Home view controller line 164, ltcAccountIDs # \(ltcAccountIDs.count), ltcAccountIDS name: \(account.name), accountID: \(account.accountID)")
                
                
            case "\(CurrencyCode.BTC)":
                btc.append(account)
                currencyAccountIDs[1] = btc
                
            case "\(CurrencyCode.BCH)":
                bch.append(account)
                currencyAccountIDs[2] = bch
                
            case "\(CurrencyCode.ETH)":
                eth.append(account)
                currencyAccountIDs[3] = eth
                
            case "\(CurrencyCode.EUR)":
                eur.append(account)
                currencyAccountIDs[4] = eur
                
            default:
                other.append(account)
                currencyAccountIDs[5] = other
            }
            
        }
        print("home view controller line 180, currencyAccountIDs for LTC: \(String(describing: currencyAccountIDs[0]?.count)) \n currencyAccountIDs for BTC: \(String(describing: currencyAccountIDs[1]?.count)) \n currencyAccountIDs for BCH: \(String(describing: currencyAccountIDs[2]?.count)) \n currencyAccountIDs for ETH: \(String(describing: currencyAccountIDs[3]?.count)) \n currencyAccountIDs for EUR: \(String(describing: currencyAccountIDs[4]?.count)) \n currencyAccountIDs for OTHER: \(String(describing: currencyAccountIDs[5]?.count))")
        
        //return currencyAccountIDs
        return ltcAccountIDs
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "selectedAccountSegue" else {
            fatalError("Unknown Error")
        }
        let QRCodeViewController = segue.destination as! QRCodeViewController
        QRCodeViewController.account = currencyAccountIDs[tableView.indexPathForSelectedRow!.section]![tableView.indexPathForSelectedRow!.row]
    }

}
extension SelectAccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "selectedAccountSegue", sender: self)
    }
    
}

extension SelectAccountViewController : UITableViewDataSource {
    /*  The amount of sections equals the amount of keys in currencyAccountIDs  */
    func numberOfSections(in tableView: UITableView) -> Int {
        return currencyAccountIDs.keys.count
    }
    
    /*  Rows in section depends on the number of valeus a key has (accounts with the same currency) */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencyAccountIDs[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountsCell
        let account = currencyAccountIDs[indexPath.section]![indexPath.row]
        
        cell.accountName.text = account.name
        
        if let amount = account.balance.amount
        {
            cell.balance.text = "\(amount)"
        }
        else {
                print("Select Account view controller line 196, amount is nil for \(currencyAccountIDs[indexPath.section]![indexPath.row])")
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
    /*  Shows alert when unsupported currency account is selected   */
    func selectedUnsuportedPaymentCurrency(){
        let alert = UIAlertController(title: "", message: "Enkel Litecoin betalingen worden (momenteel) ondersteund)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Select Account view controller line 281, indexPath.section: \(indexPath.section)")
        if indexPath.section != 0 {
            selectedUnsuportedPaymentCurrency()
            return nil
        }
        else {
            return indexPath
        }
    }
}