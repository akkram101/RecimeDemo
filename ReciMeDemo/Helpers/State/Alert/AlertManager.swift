//
//  AlertManager.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

@MainActor
@Observable
class AlertManager {
    typealias AlertClosure = (() -> Void)
    
    static let shared = AlertManager()
    
    ///Current Alert
    var alert: Alert?
    
    func showCustomAlert(
        alignment: Alignment = .center,
        duration: TimeInterval? = nil,
        dimBackground: Bool = true,
        @ViewBuilder content: () -> some View) {
            
        var alert = Alert {
            content()
        }
        
        alert.alignment = alignment
        alert.dimBackground = dimBackground
        showAlert(alert)
         
        ///remove if have duration
        if let duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                self.dismissAlert()
            })
        }
    }
    
    func dismissAlert() {
        alert = nil
    }
    
    func dismissAlert(perform: AlertClosure?) {
        withAnimation(.bouncy) {
            alert = nil
        } completion: {
            perform?()
        }
    }
    
    private func showAlert(_ alert: Alert?) {
        withAnimation(.snappy(duration: 0.5)) {
            self.alert = alert
        }
    }
}
