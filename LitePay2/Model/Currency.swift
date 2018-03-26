//
//  Currency.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 28/02/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
class Currency {
    
    var fullName = ""
    var value : NSDecimalNumber = 0 /* gaat nog aangepast moeten worden naar BigDecimal! */
    var code = ""
    
    convenience init(fullNameCurrency : String, valueCurrency : NSDecimalNumber, codeCurrency : String){
        self.init()
        self.fullName = fullNameCurrency
        self.value = valueCurrency
        self.code = codeCurrency
    }
}
enum CurrencyCode {
    /*Used for abbreviation of currency*/
    case EUR
    case LTC
    case BTC
    case BCH
    case ETH
    case OTHER
}
