import Foundation
import UIKit

class CurrencyRateViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var currencyRateTableView: UITableView!
    
    override func viewDidLoad() {
        currencyRateTableView.delegate = self
        currencyRateTableView.dataSource = self
    }
    
}
