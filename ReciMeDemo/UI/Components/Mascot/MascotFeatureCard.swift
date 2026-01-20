//
//  MascotFeatureCard.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

enum MascotFeatureAlignment {
    case leading
    case trailing
    case bottomLeading
    case bottomTrailing
}


struct MascotFeatureCard: View {
    let message: String
    let buttonTitle: String
    let buttonAction: () -> Void
    let mascot: MascotType
    let alignment: MascotFeatureAlignment
    
    var body: some View {
        Group {
            switch alignment {
            case .leading:
                HStack {
                    Mascot(mascot, flippedHorizontally: true)
                        .frame(width: 200)
                    content
                }
                
            case .trailing:
                HStack {
                    content
                    Mascot(mascot)
                        .frame(width: 200)
                }
                
            case .bottomLeading:
                VStack {
                    content
                        .containerRelativeFrame(.horizontal) { length, _ in
                            return length * 0.8
                        }
                    HStack {
                        Mascot(mascot, flippedHorizontally: true)
                            .frame(width: 200)
                        Spacer()
                    }
                }
                
            case .bottomTrailing:
                VStack {
                    content
                        .containerRelativeFrame(.horizontal) { length, _ in
                            return length * 0.8
                        }
                    HStack {
                        Spacer()
                        Mascot(mascot)
                            .frame(width: 200)
                    }
                }
            }
        }
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            Text(message)
                .poppinsMedium(size: 12)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            PrimaryButton(title: buttonTitle, action: buttonAction)
                .frame(height: 40)
                .frame(maxWidth: 120)
        }
        .padding(12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
        .padding(12)
    }
}
