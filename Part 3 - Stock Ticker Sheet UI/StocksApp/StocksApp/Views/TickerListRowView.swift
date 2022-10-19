//
//  TickerListRowView.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import SwiftUI

@MainActor
struct TickerListRowView: View {
    
    let data: TickerListRowData
    
    var body: some View {
        HStack(alignment: .center) {
            if case let .search(isSaved, onButtonTapped) = data.type {
                Button {
                    onButtonTapped()
                } label: {
                    image(isSaved: isSaved)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(data.symbol).font(.headline.bold())
                if let name = data.name {
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
            }
            
            Spacer()
            
            if let (price, change) = data.price {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(price)
                    priceChangeView(text: change)
                }
                .font(.headline.bold())
            }
        }
    }
    
    @ViewBuilder
    func image(isSaved: Bool) -> some View {
        if isSaved {
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.accentColor)
                .imageScale(.large)
        } else {
            Image(systemName: "plus.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.accentColor, Color.secondary.opacity(0.3))
                .imageScale(.large)
        }
    }
    
    @ViewBuilder
    func priceChangeView(text: String) -> some View {
        if case .main = data.type {
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(text.hasPrefix("-") ? .red : .green)
                    .frame(height: 24)
                
                Text(text)
                    .foregroundColor(.white)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
            }
            .fixedSize()
        } else {
            Text(text)
                .foregroundColor(text.hasPrefix("-") ? .red : .green)
        }
        
    }
    
}

struct TickerListRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(alignment: .leading) {
            Text("Main List").font(.largeTitle.bold()).padding()
            VStack {
                TickerListRowView(data: appleTikcerListRowData(rowType: .main))
                Divider()
                TickerListRowView(data: teslaTikcerListRowData(rowType: .main))
            }.padding()
            
            Text("Search List").font(.largeTitle.bold()).padding()
            VStack {
                TickerListRowView(data: appleTikcerListRowData(rowType: .search(isSaved: true, onButtonTapped: {})))
                Divider()
                TickerListRowView(data: teslaTikcerListRowData(rowType: .search(isSaved: false, onButtonTapped: {})))
            }.padding()
        }.previewLayout(.sizeThatFits)
    }
    
    static func appleTikcerListRowData(rowType: TickerListRowData.RowType) -> TickerListRowData {
        .init(symbol: "AAPL", name: "Apple Inc.", price: ("100.0", "+0.7"), type: rowType)
    }
    
    static func teslaTikcerListRowData(rowType: TickerListRowData.RowType) -> TickerListRowData {
        .init(symbol: "TSLA", name: "Tesla", price: ("250.9", "-18.5"), type: rowType)
    }
}
