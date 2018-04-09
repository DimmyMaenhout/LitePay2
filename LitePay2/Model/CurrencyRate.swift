import Foundation

class CurrencyRate {
    
    
    init (){
        
    }
    
    func converseToLTC(amountEuro: NSDecimalNumber, currencyRate: NSDecimalNumber) -> NSDecimalNumber {
        
        let amountLTC = (amountEuro as Decimal) * (currencyRate as Decimal) as NSDecimalNumber
        return amountLTC
    }
    
    func conversToEuro(amountLTC: NSDecimalNumber, currencyRate: NSDecimalNumber) -> NSDecimalNumber {
        
        let amountEuro = (amountLTC as Decimal) * (currencyRate as Decimal) as NSDecimalNumber
        return amountEuro
    }
//          Testen
//    1. amountEuro of currencyRate is 0
//    2. amountEuro of currencyRate is negatief
//    3. amountLtc of currencyRate is negatief
//    4. amount of currrencyRate is geen getal
}
