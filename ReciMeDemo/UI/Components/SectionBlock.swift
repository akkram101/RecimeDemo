//
//  SectionBlock.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct SectionBlock<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .poppinsSemiBold(size: 18)
                .foregroundStyle(.black)
            
            content
        }
    }
}

#Preview {
    SectionBlock(title: "Test block") {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<8, id: \.self) { _ in
                    Color.blue
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}
