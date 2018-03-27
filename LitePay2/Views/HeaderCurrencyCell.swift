import UIKit

class HeaderCurrencyCell : UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    
    var currency : String! {
        didSet {
            currencyLabel.text = currency
        }
    }
}
