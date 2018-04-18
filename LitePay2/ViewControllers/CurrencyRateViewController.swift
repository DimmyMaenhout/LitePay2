import Foundation
import UIKit

class CurrencyRateViewController : UIViewController {
    
    @IBOutlet weak var currencyRateTableView: UITableView!
    var timer = Timer()
    var currencyRates : [String: String]? {
//        This is a property observer.
//        The willSet and didSet observers provide a way to observe (and to respond appropriately) when the value of a variable          or property is being set.
//        Observers aren't called when the or property is first initialized, they are only called when the value is set outside of an initialization context
//        didSet is called immediatly after the new value is set
        didSet {
            scheduledTimerInterval()
            print("\n\nCurrency rates view controller line 15, var currencyRate didSet: \(String(describing: currencyRates))\n\n")
            currencyRateTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currencyRateTableView.dataSource = self
        getCurrencyRates()
        
//        removes the unwanted space between the navbar and first cell
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @objc func getCurrencyRates(){
        
        print("Currency rate view controller line 32, got here")
        CoinbaseAPIService.getExchangeRates(completion: ({ response in
            
//            print("Currency rate view controller line 35, response: \(response!)")
            
            self.currencyRates = response!
//            print("Currency rate view controller line 38, self.currencyRates: \(String(describing: self.currencyRates))")
        }))
    }
    
//    Repeat getCurrencyRates every 30 seconds (to get new data, currencyRates could have changed from 30 seconds ago
    func scheduledTimerInterval(){

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getCurrencyRates), userInfo: nil, repeats: true)
        currencyRateTableView.reloadData()
    }
}

extension CurrencyRateViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        all elements in currencyRates need to be showed, if currencyRates = nil return 0
        return currencyRates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = currencyRateTableView.dequeueReusableCell(withIdentifier: "currencyRateCell", for: indexPath) as! KoersCell
        
//        show the key and value at indexPath.row, to show every key and value we use Array(key/value)[ at this position ]
        cell.codeCurrencyLbl.text = Array(currencyRates!.keys)[indexPath.row]
        cell.valueCurrencyLabel.text = Array(currencyRates!.values)[indexPath.row]
        return cell
    }
}
