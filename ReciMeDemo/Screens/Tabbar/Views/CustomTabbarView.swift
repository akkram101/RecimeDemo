//
//  CustomTabbarView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct CustomTabbarView: View {
    @Environment(TabBarViewModel.self) var tabBarVM
    
    var body: some View {
        HStack {
            ForEach(tabBarVM.tabs, id: \.self) { tab in
                Button {
                    tabBarVM.switchTo(tab)
                } label: {
                    VStack(spacing: 4) {
                        createTabItem(tab: tab)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .frame(height: RALength.tabbarHeight)
        .padding(.bottom, DeviceInfo.isIphoneSE() ? 16 : 40)
        .background {
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 4, y: -2)
        }
    }
    
    @ViewBuilder
    private func createTabItem(tab: Tab) -> some View {
        Image(systemName: tab.systemImage)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(tabBarVM.selectedTab == tab ? AppColors.primary : AppColors.inactive)
        
        Text(tab.title)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(tabBarVM.selectedTab == tab ? AppColors.primary : AppColors.inactive)
    }
}

#Preview {
    CustomTabbarView()
        .environment(TabBarViewModel())
}
