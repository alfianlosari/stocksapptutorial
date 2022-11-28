//
//  Stubs.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import Foundation
import XCAStocksAPI

#if DEBUG
extension Ticker {
    
    static var stubs: [Ticker] {
        [
            Ticker(symbol: "AAPL", shortname: "Apple Inc.", exchDisp: "NASDAQ"),
            Ticker(symbol: "TSLA", shortname: "Tesla."),
            Ticker(symbol: "NVDA", shortname: "Nvidia Corp."),
            Ticker(symbol: "AMD", shortname: "Advanced Micro Device")
        ]
    }
    
    static var stub: Ticker {
        stubs[0]
    }

}

extension Quote {
    
    static var stubs: [Quote] {
        [
            Quote(symbol: "AAPL", regularMarketPrice: 150.43, regularMarketChange: -2.31),
            Quote(symbol: "TSLA", regularMarketPrice: 250.43, regularMarketChange: 2.89),
            Quote(symbol: "NVDA", regularMarketPrice: 100.43, regularMarketChange: -19.32),
            Quote(symbol: "AMD", regularMarketPrice: 70.43, regularMarketChange: 12.55)
        ]
    }
    
    static var stubsDict: [String: Quote] {
        var dict = [String: Quote]()
        stubs.forEach { dict[$0.symbol] = $0 }
        return dict
    }
    
    static func stub(isTrading: Bool) -> Quote {
        Quote(symbol: "AAPL",
              currency: "USD",
              marketState: isTrading ? "REGULAR" : "CLOSED",
              regularMarketPrice: 150.43,
              regularMarketChange: -2.31,
              postMarketPrice: 172.43,
              postMarketChange: 5.34,
              regularMarketOpen: 150,
              regularMarketDayHigh: 160,
              regularMarketDayLow: 140,
              regularMarketVolume: 86_000_000.0,
              trailingPE: 24.54,
              marketCap: 2_300_000_000_000.0,
              fiftyTwoWeekLow: 130.42,
              fiftyTwoWeekHigh: 183.77,
              averageDailyVolume3Month: 80_128_000.0,
              epsTrailingTwelveMonths: 6.05
        )
    }
  
}

#endif

