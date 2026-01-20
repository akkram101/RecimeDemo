//
//  CustomFontModifier.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    var fontName: String
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: size))
    }
}

extension View {
    func customFont(name: String, size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(fontName: name, size: size))
    }
    
    func poppinsRegular(size: CGFloat) -> some View {
        self.customFont(name: "Poppins-Regular", size: size)
    }
    
    func poppinsMedium(size: CGFloat) -> some View {
        self.customFont(name: "Poppins-Medium", size: size)
    }
    
    func poppinsBold(size: CGFloat) -> some View {
        self.customFont(name: "Poppins-Bold", size: size)
    }
    
    func poppinsSemiBold(size: CGFloat) -> some View {
        self.customFont(name: "Poppins-SemiBold", size: size)
    }
    
    func poppinsExtraBold(size: CGFloat) -> some View {
        self.customFont(name: "Poppins-ExtraBold", size: size)
    }
}

#Preview {
    VStack(spacing: 10) {
        Text("Test String")
            .poppinsRegular(size: 36)
        Text("Test String")
            .poppinsMedium(size: 36)
        Text("Test String")
        .poppinsSemiBold(size: 36)
        Text("Test String")
            .poppinsBold(size: 36)
        Text("Test String")
            .poppinsExtraBold(size: 36)
    }
}
