//
//  EmptySearchView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct EmptySearchView: View {
    let searchedString: String
    var body: some View {
        VStack(spacing: 16) {
            Mascot(.noRecipes)
                .frame(height: 240)
            
            VStack {
                Text("No results found for \(searchedString)")
                Text("Try adjusting your filters or search terms.")
            }
            .poppinsRegular(size: 14)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
        .background(Color.white)
    }
}


#Preview {
    EmptySearchView(searchedString: "Eggs")
}
