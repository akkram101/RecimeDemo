//
//  RALength.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI
import UIKit

enum RALength {
    /// Standard iOS tab bar height (49 on iPhone, 50 on iPad)
    static var tabbarHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 50 : 49
    }

    /// Standard navigation bar height
    static var navigationBarHeight: CGFloat {
        44
    }

    /// Safe area insets for the current key window
    static var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow?.safeAreaInsets ?? .zero
    }

    /// Bottom safe area inset (e.g. home indicator area)
    static var safeAreaBottom: CGFloat {
        safeAreaInsets.bottom
    }

    /// Top safe area inset (e.g. notch area)
    static var safeAreaTop: CGFloat {
        safeAreaInsets.top
    }
}
