//
//  LoadingStateView.swift
//  StocksApp
//
//  Created by Alfian Losari on 01/10/22.
//

import SwiftUI

struct LoadingStateView: View {
    
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct LoadingStateView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStateView()
    }
}
