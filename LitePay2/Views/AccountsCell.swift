import Foundation
import UIKit
import coinbase_official

class AccountsCell : UITableViewCell {
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    var account : CoinbaseAccount! {
        didSet {
            accountName.text = account.name
            balance.text = "\(account.balance)"
        }
    }
}
