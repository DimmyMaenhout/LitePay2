import Foundation
import UIKit
import coinbase_official

class SelectAccountViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    var accounts : [CoinbaseAccount] = []
//    dict accountIDs has currencies as keys and account's id's as values
//    there can be multiple accounts with the same currency, so we use an array
    var currencyAccountIDs : [Int: [CoinbaseAccount]] = [:]
    var btnPressedPreviousVc : String = ""
    var sv = UIView()
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getAccounts()
        self.automaticallyAdjustsScrollViewInsets = false
        sv = UIViewController.displaySpinner(onView: self.view)
    }
    
//    Gets all of the users accounts (wallets)
    func getAccounts()  {
        
        let accessTkn = UserDefaults.standard.object(forKey: "access_token")
        print("Select Account view controller line 31, accessTkn: \(String(describing: accessTkn))")
        
//        If accessTkn has a value (not nil) go in statement
        if let accessToken = accessTkn
        {
            client = Coinbase(oAuthAccessToken: accessToken as! String)
//            If client has a value (not nil) go in statement
            if let client = client
            {
                client.getAccountsList({( accounts : [Any]?, pagingHelper : CoinbasePagingHelper?, error : Error?) -> Void in
                    UIViewController.removeSpinner(spinner: self.sv)
//                    If there is an error, show alert
                    print("Select Account view controller line 42, got till here")
                    if error != nil{
                        print("Select Account view controller line 44, error occured when trying to get accounts. error: \(String(describing: error?.localizedDescription))")
                        
                        let alert = UIAlertController(title: "Error", message: "Er is een fout opgtreden bij het ophalen van de accounts", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                        print("Select Account view controller line 50, exiting method getAccounts")
                        return
                    }
                    
                    print("Select Account view controller line 54, got till here")
//                    If accounts is nil go in (else) statement
                    guard let accounts = accounts else
                    {
                        print("Select Account view controller line 58, accounts is nil, exiting method getAccounts")
                        return
                    }
//                    If pagingHelper is nil go in (else) statement
                    guard pagingHelper != nil else
                    {
                        print("Select Account view controller line 64, pagingHelper is nil, exiting method getAccounts")
                        return
                    }
                    
                    self.accounts = accounts as! [CoinbaseAccount]
                    print("Select Account view controller line 69, # accounts: \(accounts.count)")
                    print("Select Account view controller line 70, # account in self.accounts: \(self.accounts.count)")
                    self.getAccountIDs(self.accounts)
//                    Put data in table
                    self.tableView.reloadData()
                    
                })
            }
            else {
                
                print("Select Account view controller line 79, client is nil: \(String(describing: client))")
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
        
        print("Select Account view controller line 94, accessed method getAccountsIDs")
        for account in self.accounts {
            
            switch(account.balance.currency){
                
            case "\(CurrencyCode.LTC)":
                ltc.append(account)
                
                currencyAccountIDs[0] = ltc
                print("Select Account view controller line 103, LTC account id: \(account.accountID)")
                
                ltcAccountIDs["\(account.name)"] = account.accountID
                print("Select Account view controller line 106, ltcAccountIDs # \(ltcAccountIDs.count), ltcAccountIDS name: \(account.name), accountID: \(account.accountID)")
                
                
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
        
        print("Select Account view controller line 131,, currencyAccountIDs for LTC: \(String(describing: currencyAccountIDs[0]?.count)) \n currencyAccountIDs for BTC: \(String(describing: currencyAccountIDs[1]?.count)) \n currencyAccountIDs for BCH: \(String(describing: currencyAccountIDs[2]?.count)) \n currencyAccountIDs for ETH: \(String(describing: currencyAccountIDs[3]?.count)) \n currencyAccountIDs for EUR: \(String(describing: currencyAccountIDs[4]?.count)) \n currencyAccountIDs for OTHER: \(String(describing: currencyAccountIDs[5]?.count))")
        
//        return currencyAccountIDs
        return ltcAccountIDs
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Select account view controller line 139, button pressed previous controller = \(btnPressedPreviousVc)")
        switch segue.identifier {
            
        case "payView"?:
            
            let payviewController = segue.destination as! PayViewController
            payviewController.account = currencyAccountIDs[tableView.indexPathForSelectedRow!.section]![tableView.indexPathForSelectedRow!.row]
            print("Select account view controller line 146, payviewController.account = \(payviewController.account)")
        case "receiveView"?:
            
            let QRCodeViewController = segue.destination as! QRCodeViewController
            QRCodeViewController.account = currencyAccountIDs[tableView.indexPathForSelectedRow!.section]![tableView.indexPathForSelectedRow!.row]
            
        default:
            
            fatalError("Select account view controller line 154, unknown segue")
        }
    }

}
extension SelectAccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch btnPressedPreviousVc {
            
        case "pay":
            
            performSegue(withIdentifier: "payView", sender: self)
            
        case "receive":
            
            performSegue(withIdentifier: "receiveView", sender: self)
            
        default:
            
            fatalError("Select account view controller line 174, btn pressed not found (not in switch)")
        }
    }
}

extension SelectAccountViewController : UITableViewDataSource {
    
//    The amount of sections equals the amount of keys in currencyAccountIDs
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return currencyAccountIDs.keys.count
    }
    
//    Rows in section depends on the number of valeus a key has (accounts with the same currency)
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
                print("Select Account view controller line 205, amount is nil for \(currencyAccountIDs[indexPath.section]![indexPath.row])")
        }
        
        return cell
    }
    
//    Names for the sections
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
    
//    Shows alert when unsupported currency account is selected
    func selectedUnsuportedPaymentCurrency(){
        
        let alert = UIAlertController(title: "", message: "Enkel Litecoin betalingen worden (momenteel) ondersteund", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //if currency != litecoin show alert and exit method
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        print("Select Account view controller line 246, indexPath.section: \(indexPath.section)")
        if indexPath.section != 0 {
            
            selectedUnsuportedPaymentCurrency()
            return nil
        }
        else {
            
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
