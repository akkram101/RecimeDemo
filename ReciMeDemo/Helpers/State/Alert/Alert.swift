//
//  Alert.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import Foundation
import SwiftUI

struct Alert: Identifiable {
    private(set) var id: String = UUID().uuidString
    var content: AnyView
    
    init(@ViewBuilder content: () -> some View) {
        self.content = .init(content())
    }
    
    ///Default is bottom
    ///Figma alert has bottom sheet alert 
    var alignment: Alignment = .center
    var dimBackground: Bool = true
    
    var transition: AnyTransition {
        switch alignment {
        case .bottom, .bottomLeading, .bottomTrailing:
            return .move(edge: .bottom)
        case .top, .topTrailing, .topLeading:
            return .move(edge: .top)
        case .leading:
            return .move(edge: .leading)
        case .trailing:
            return .move(edge: .trailing)
        case .center:
            return .scale.combined(with: .opacity)
        default:
            return .move(edge: .bottom)
        }
    }
}
