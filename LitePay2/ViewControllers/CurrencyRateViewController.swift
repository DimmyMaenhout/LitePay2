import Foundation
import UIKit

class CurrencyRateViewController : UIViewController {
    
    @IBOutlet weak var currencyRateController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyRateController.dataSource = self
        currencyRateController.delegate = self
    }
}

extension CurrencyRateViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* TODO
         * aanpassen (afhankelijk van hoeveel currencies er binnen komen .count()
         */
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyRateCell", for: indexPath) as! KoersCell
        
        /* TODO
         * code aanvullen voor cell op te vullen (afkorting, volledige naam, waarde currency)
         */
        
        return cell
    }
    
}

extension CurrencyRateViewController : UITableViewDelegate {
    
    
}
