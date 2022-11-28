//
//  SearchView.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import SwiftUI
import XCAStocksAPI

struct SearchView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        List(searchVM.tickers) { ticker in
            TickerListRowView(
                data: .init(
                    symbol: ticker.symbol,
                    name: ticker.shortname,
                    price: quotesVM.priceForTicker(ticker),
                    type: .search(
                        isSaved: appVM.isAddedToMyTickers(ticker: ticker),
                        onButtonTapped: {
                            Task { @MainActor in
                                appVM.toggleTicker(ticker)
                            }
                        }
                    )
                )
            )
            .contentShape(Rectangle())
            .onTapGesture {
                Task { @MainActor in
                    appVM.selectedTicker = ticker
                }
            }
        }
        .listStyle(.plain)
        .refreshable { await quotesVM.fetchQuotes(tickers: searchVM.tickers) }
        .task(id: searchVM.tickers) { await quotesVM.fetchQuotes(tickers: searchVM.tickers) }
        .overlay { listSearchOverlay }
    }
    
    @ViewBuilder
    private var listSearchOverlay: some View {
        switch searchVM.phase {
        case .failure(let error):
            ErrorStateView(error: error.localizedDescription) {
                Task { await searchVM.searchTickers() }
            }
        case .empty:
            EmptyStateView(text: searchVM.emptyListText)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    @StateObject static var stubbedSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { Ticker.stubs }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var emptySearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { [] }
        return SearchViewModel(query: "Theranos", stocksAPI: mock)
    }()
    
    @StateObject static var loadingSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = {
            await withCheckedContinuation { _ in }
        }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var errorSearchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has been occured"]) }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var appVM: AppViewModel = {
        var mock = MockTickerListRepository()
        mock.stubbedLoad = { Array(Ticker.stubs.prefix(upTo: 2)) }
        return AppViewModel(repository: mock)
    }()
        
    static var quotesVM: QuotesViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedFetchQuotesCallback = { Quote.stubs }
        return QuotesViewModel(stocksAPI: mock)
    }()
    
    static var previews: some View {
        Group {
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: stubbedSearchVM)
            }
            .searchable(text: $stubbedSearchVM.query)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: emptySearchVM)
            }
            .searchable(text: $emptySearchVM.query)
            .previewDisplayName("Empty Results")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: loadingSearchVM)
            }
            .searchable(text: $loadingSearchVM.query)
            .previewDisplayName("Loading State")
            
            NavigationStack {
                SearchView(quotesVM: quotesVM, searchVM: errorSearchVM)
            }
            .searchable(text: $errorSearchVM.query)
            .previewDisplayName("Error State")
            
            
        }.environmentObject(appVM)
    }
}
