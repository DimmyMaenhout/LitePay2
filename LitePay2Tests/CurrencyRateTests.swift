import XCTest

@testable import LitePay2

class CurrencyRateTests: XCTestCase {
    
    var currRate : CurrencyRate?
    
    func testCurrencyRateIsZero() {
        
        let decimalEuro = NSDecimalNumber(decimal: 1.0000000000)
        currRate = CurrencyRate()
        
        XCTAssertEqual(0, currRate?.converseToLTC(amountEuro: decimalEuro, currencyRate: 0), "Result should be 0 (multiplied with 0) ")
    }
    
    func testEuroAmountIsZero() {
        
        let currencyRate = NSDecimalNumber(decimal: 1.0000000000)
        currRate = CurrencyRate()
        
        XCTAssertEqual(0, currRate?.converseToLTC(amountEuro: 0.000000000, currencyRate: currencyRate), "Result should be 0 (multiplied with 0) ")
    }
    
    func testLtcAmountIsZero(){
        
        let spotPrice = NSDecimalNumber(decimal: 1.0000000000)
        
        currRate = CurrencyRate()
        XCTAssertEqual(0, currRate?.converseToEuro(amountLTC: 0.000000000, spotPrice: spotPrice), "Result should be 0 (multiplied with 0)")
    }
    
    func testSpotPriceIsZero() {
        
        let decimalLTC = NSDecimalNumber(decimal: 1.0000000000)
        currRate = CurrencyRate()
        
        XCTAssertEqual(0, currRate?.converseToEuro(amountLTC: decimalLTC, spotPrice: 0.000000000), "Result should be 0 (multiplied with 0) ")
    }
    
    func testNormalParametersConvertToEURO(){
        
        let amountLTC = NSDecimalNumber(decimal: 1.0000000000)
        let spotPrice = NSDecimalNumber(decimal: 97.186514)
        
//        result = amountLTC * spotPrice
        let result = NSDecimalNumber(decimal: 97.186514)
        currRate = CurrencyRate()
        
        XCTAssertEqual(result, currRate?.converseToEuro(amountLTC: amountLTC, spotPrice: spotPrice), "Result should be \(result) ")
    }
    
    func testNormalParametersConvertToOtherCurrency(){
        
        let amountEuro = NSDecimalNumber(decimal: 15.0000000000)
        let currencyRate = NSDecimalNumber(decimal: 0.010296)
        let result = NSDecimalNumber(decimal: 0.15444)
        currRate = CurrencyRate()
        
        XCTAssertEqual(result, currRate?.converseToLTC(amountEuro: amountEuro, currencyRate: currencyRate), "Result should be  \(result)")
    }
    
    func testSpotPriceIsNegative(){
        
    }
    
}

//          Testen
//    1. amountEuro of currencyRate is 0
//    2. amountEuro of currencyRate is negatief
//    3. amountLtc of currencyRate is negatief
