//
//  TabBarViewModel.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

enum Tab: Hashable, CaseIterable {
    case home
    case discover
    case mealPlan
    case activity
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .discover: return "Discover"
        case .mealPlan: return "Meal Plan"
        case .activity: return "Activities"
        case .profile: return "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .discover: return "safari"
        case .mealPlan: return "calendar"
        case .activity: return "list.bullet.rectangle.portrait"
        case .profile: return "person.fill"
        }
    }
}

@MainActor
@Observable
final class TabBarViewModel {
    let tabs: [Tab] = Tab.allCases
    var selectedTab: Tab = .home
    
    var isShowTabbar: Bool = true
    
    func switchTo(_ tab: Tab) {
        selectedTab = tab
    }
    
    func showTabbar(_ isShow: Bool) {
        withAnimation(.bouncy(duration: 0.3)) {
            isShowTabbar = isShow
        }
    }
}
