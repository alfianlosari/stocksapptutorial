//
//  TickerQuoteViewModel.swift
//  StocksApp
//
//  Created by Alfian Losari on 16/10/22.
//

import Foundation
import SwiftUI
import XCAStocksAPI

@MainActor
class TickerQuoteViewModel: ObservableObject {
    
    @Published var phase = FetchPhase<Quote>.initial
    var quote: Quote? { phase.value }
    var error: Error? { phase.error }
    
    let ticker: Ticker
    let stocksAPI: StocksAPI
    
    init(ticker: Ticker, stocksAPI: StocksAPI = XCAStocksAPI()) {
        self.ticker = ticker
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuote() async {
        phase = .fetching
        
        do {
            let response = try await stocksAPI.fetchQuotes(symbols: ticker.symbol)
            if let quote = response.first {
                phase = .success(quote)
            } else {
                phase = .empty
            }
        } catch {
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
    
}
