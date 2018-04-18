import Foundation

 class CurrencyRate {

    
    public func converseToLTC(amountEuro: NSDecimalNumber, currencyRate: NSDecimalNumber) throws -> NSDecimalNumber {
        
        if amountEuro.decimalValue < NSDecimalNumber(decimal: 0.00000000000) as Decimal{
            
            throw CurrencyRateError.negativeAmount
        }
        else {
            
            let amountLTC = (amountEuro.decimalValue  * currencyRate.decimalValue) as NSDecimalNumber
            return amountLTC
        }
        
    }
    
    public func converseToEuro(amountLTC: NSDecimalNumber, spotPrice: NSDecimalNumber) throws -> NSDecimalNumber {
        
        if amountLTC.decimalValue < NSDecimalNumber(decimal: 0.00000000000) as Decimal {
            
            throw CurrencyRateError.negativeAmount
        }
        else {
            
            let amountEuro = (amountLTC.decimalValue * spotPrice.decimalValue ) as NSDecimalNumber
            return amountEuro
        }
        
    }
}

enum CurrencyRateError : Error {
    
    case negativeAmount
}
