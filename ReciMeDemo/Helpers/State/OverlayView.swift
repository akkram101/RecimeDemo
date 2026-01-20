//
//  OverlayView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct OverlayView: View {
    
    @State private var alertManager = AlertManager.shared
    //Add more overlays here if needed
    //eg. Toasts, Popups, Loading Wrappers,
    
    var body: some View {
        ZStack {}
            .alertSheet($alertManager.alert)
    }
}
