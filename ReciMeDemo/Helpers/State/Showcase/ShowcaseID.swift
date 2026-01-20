//
//  ShowcaseID.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

/// A registered showcase item containing the highlight view and its guide.
///
/// Both `view` and `guide` should be pre-positioned before being passed in.
/// This means any layout logic—such as `.position(...)`
/// must be applied externally. The showcase system will render these views as-is,
/// without modifying their placement.
///
/// This design allows full flexibility for custom layouts, animations, and transitions.

enum ShowcaseID: String, Hashable {
    case importRecipe
    case searchRecipe
    case cookingOverlay
    case filterRecipe
    // Add more as needed
}

struct ShowcaseItem {
    let id: ShowcaseID
    let view: AnyView
    let guide: AnyView
    let onDismiss: () -> Void
}

@Observable
final class ShowcaseManager {
    static let shared = ShowcaseManager()

    private var items: [ShowcaseID: ShowcaseItem] = [:]
    ///If the showcase has been shown or not
    ///can be user defaults but for demo purposes use a set
    private var shownFlags: Set<ShowcaseID> = []
    
     func register(item: ShowcaseItem) {
        items[item.id] = item
    }
    
     func showCase(forId id: ShowcaseID) -> ShowcaseItem? {
        items[id]
    }
    
    @MainActor
    func showIfNeed(_ id: ShowcaseID) {
        guard !shownFlags.contains(id),
              let _ = showCase(forId: id) else {
            return
        }
        
        let overlay = ShowcaseOverlay(id: id)
        AlertManager.shared.showCustomAlert {
            overlay
        }
        
        shownFlags.insert(id)
    }
}


struct ShowcaseOverlay: View {
    @State private var isAnimating = false
    
    let id: ShowcaseID
    
     init(id: ShowcaseID) {
        self.id = id
    }

     var body: some View {
        ZStack {
            if isAnimating {
                if let showcase = ShowcaseManager.shared.showCase(forId: id) {
                    showcase.view
                        .zIndex(1)

                    showcase.guide
                        .zIndex(2)
                }
            } else {
                EmptyView()
               
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.snappy(duration: 0.3)) { isAnimating = true }
        }
    }
}

extension View {
    /// This is a convenience helper for positioning the highlight and guide views relative to the target view.
    /// It automatically measures the target's frame and centers the highlight using `.position(...)`.
    func addShowCase(
        id: ShowcaseID,
        highlightView: @escaping () -> some View,
        guide: @escaping () -> some View,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .global)) { _, frame in
                            let positionedHighlightView = AnyView(
                                highlightView()
                                    .position(x: frame.midX, y: frame.midY)
                            )
                            
                            let item = ShowcaseItem(
                                id: id,
                                view: positionedHighlightView,
                                guide: AnyView(guide()),
                                onDismiss: onDismiss
                            )
                            ShowcaseManager.shared.register(item: item)
                        }
                }
            )

    }
}
