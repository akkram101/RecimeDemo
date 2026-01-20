//
//  ToggleToolbarOnScroll.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct ToggleToolbarOnScroll: ViewModifier {
    @State private var lastOffset: CGFloat = 0.0
    let onStatusChange: (Bool) -> Void

    func body(content: Content) -> some View {
        content
            .onScrollPhaseChange { oldPhase, newPhase, context in
                let currentOffset = context.geometry.contentOffset
                let scrollingDown = currentOffset.y > lastOffset
                var shouldShow: Bool? = nil

                switch newPhase {
                case .interacting, .tracking:
                    break
                case .animating, .decelerating:
                    if oldPhase == .interacting || oldPhase == .tracking {
                        shouldShow = scrollingDown ? false : true
                    }
                case .idle:
                    if oldPhase != .idle && abs(currentOffset.y - lastOffset) > 20 {
                        shouldShow = scrollingDown ? false : true
                    }
                @unknown default:
                    break
                }

                if let shouldShow = shouldShow {
                    onStatusChange(shouldShow)
                }

                lastOffset = currentOffset.y
            }
    }
}

extension View {
    func toggleToolbarOnScroll(onStatusChange: @escaping (Bool) -> Void) -> some View {
        self.modifier(ToggleToolbarOnScroll(onStatusChange: onStatusChange))
    }
}
