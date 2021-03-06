import Foundation
import UIKit

class KoersCell : UITableViewCell{

    @IBOutlet weak var codeCurrencyLbl: UILabel!
    @IBOutlet weak var valueCurrencyLabel: UILabel!
    
    var valuta : Currency! {
        didSet{
            codeCurrencyLbl.text = valuta.code
            valueCurrencyLabel.text = String(describing: valuta.value)
        }
    }
}
