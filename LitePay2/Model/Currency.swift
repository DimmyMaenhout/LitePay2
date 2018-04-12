import Foundation

class Currency {
    
    var fullName = ""
    var value : NSDecimalNumber = 0
    var code = ""
    
    convenience init(fullNameCurrency : String, valueCurrency : NSDecimalNumber, codeCurrency : String){
        self.init()
        self.fullName = fullNameCurrency
        self.value = valueCurrency
        self.code = codeCurrency
    }
}
//Type is int to use with table view  */
enum CurrencyCode : Int {
//    Used for abbreviation of currency   */
    case LTC = 0, BTC, BCH, ETH, EUR, OTHER

}

