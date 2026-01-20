//
//  AlertWrapper.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct AlertWrapper: View {
    
    @Binding var alert: Alert?
    
    var body: some View {
        ZStack {
            if let alert {
                if alert.dimBackground {
                    Color.black.opacity(0.6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                }
                
                alert.content
                    .zIndex(10)
            }
        }
        .ignoresSafeArea()
    }
}

extension View {
    @ViewBuilder
    func alertSheet(_ alert: Binding<Alert?>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                AlertWrapper(alert: alert)
            }
    }
}
