//
//  PrimaryButton.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .poppinsMedium(size: 12)
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            )
                        )
                }
        }
        .buttonStyle(AnimatedButtonStyle())
    }
}
