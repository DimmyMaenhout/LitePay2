//
//  KoersCell.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 28/02/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
import UIKit

class KoersCell : UITableViewCell{
    
    
    @IBOutlet weak var iconCurrency: UIImageView!
    @IBOutlet weak var codeCurrencyLbl: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var valueCurrencyLabel: UILabel!
    
    var valuta : Currency! {
        didSet{
            codeCurrencyLbl.text = valuta.code
            fullNameLabel.text = valuta.fullName
            valueCurrencyLabel.text = String(describing: valuta.value)
        }
    }
}
