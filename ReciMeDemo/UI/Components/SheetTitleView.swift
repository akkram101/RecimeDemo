//
//  SheetTitleView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct SheetTitleView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    var body: some View {
        HStack(spacing: 24) {
            Text(title)
                .poppinsMedium(size: 16)
                .foregroundStyle(.black)

            Spacer()
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 14)
                .onTapGesture { dismiss() }
                .foregroundStyle(.black)
        }
        .padding(12)
        .padding(.vertical, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(height: 1)
                .offset(y: 2),
            alignment: .bottom
        )
        .zIndex(10)
    }
}
