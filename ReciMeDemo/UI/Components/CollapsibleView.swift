//
//  CollapsibleView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct CollapsibleView<Header: View, Content: View>: View {
    @State private var isExpanded: Bool

    private let header: (_ isExpanded: Bool) -> Header
    private let content: Content
    private let onExpansionChange: ((Bool) -> Void)?

    init(isExpanded: Bool = false,
         onExpansionChange: ((Bool) -> Void)? = nil,
        @ViewBuilder header: @escaping (_ isExpanded: Bool) -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.isExpanded = isExpanded
        self.onExpansionChange = onExpansionChange
        self.header = header
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            header(isExpanded)
                .zIndex(2)
                .onTapGesture {
                    withAnimation(.snappy(duration: 0.3)) {
                        isExpanded.toggle()
                        onExpansionChange?(isExpanded)
                    }
                }

            if isExpanded {
                content
                    .zIndex(1)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
    }
}
