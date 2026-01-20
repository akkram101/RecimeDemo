//
//  ProfileView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            navBar
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    private var navBar: some View {
        HStack {
            Text("Profile")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.black)
            Spacer()
            
        }
    }
}

#Preview {
    ProfileView()
}
