//
//  LoadingRecipeListView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct LoadingRecipeListView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(0..<10, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        ShimmerView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 3) {
                            ShimmerView()
                                .frame(width: CGFloat.random(in: 100...150))
                                .frame(height: 10)
                            
                            ShimmerView()
                                .frame(width: CGFloat.random(in: 100...300))
                                .frame(height: 10)
                            
                            ShimmerView()
                                .frame(width: CGFloat.random(in: 100...100))
                                .frame(height: 10)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
            .scrollTargetLayout()
        }
        .scrollDismissesKeyboard(.immediately)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingRecipeListView()
}
