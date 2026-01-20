//
//  ErrorMascotView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct ErrorMascotView: View {
    let error: Error
    
    private var message: String {
        if let networkError = error as? NetworkError {
            return networkError.errorDescription ?? "Unknown network error"
        } else {
            return error.localizedDescription
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Mascot(.error)
                .frame(height: 240)
            
            VStack {
                Text("Oops Something Went Wrong! Try again later")
#if DEBUG
                Text(message)
#endif
            }
            .poppinsRegular(size: 14)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
        .background(Color.white)
    }
}


#Preview {
    ErrorMascotView(error: NetworkError.badResponse)
}

