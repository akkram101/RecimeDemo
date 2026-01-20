//
//  HomeHeaderView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct HomeHeaderView: View {
    
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            appIcon
            searchBar
                .onTapGesture {
                    isSearching = true
                }
    
            Spacer()
            profileBtn
        }
        .padding(.vertical)
        .background(headerBg)
        .animation(.snappy(duration: 0.4), value: isSearching)
    }
    
     private var appIcon: some View {
         Image(systemName: "cooktop")
             .resizable()
             .scaledToFit()
             .frame(height: 36)
             .foregroundStyle(.white)
     }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity)
                .foregroundStyle(Color.init(hex: "#393939"))
            
            Text("Search recipes")
                .poppinsRegular(size: 14)
                .foregroundStyle(Color.init(hex: "#9f9f9f"))
            Spacer()
        }
        .padding(12)
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
        }
        .contentShape(Rectangle())
    }
    
    private var profileBtn: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundStyle(AppColors.primary)
            .padding(3)
            .overlay {
                Circle()
                    .stroke(.white.gradient, lineWidth: 4)
            }
            .padding(2)
            .background {
                Circle()
                    .fill(.white.gradient)
            }
    }
    
    @ViewBuilder
    private var headerBg: some View {
        if !isSearching {
            LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                startPoint: .bottomTrailing,
                endPoint: .topLeading)
            .ignoresSafeArea()
        } else {
            Color.white
        }
    }
}


#Preview {
    HomeHeaderView(isSearching: .constant(false))
}
