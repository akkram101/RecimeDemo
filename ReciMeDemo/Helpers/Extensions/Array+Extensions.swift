//
//  Array+Extensions.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation

extension Array where Element: Identifiable {
    func first(whereID id: Element.ID) -> Element? {
        first { $0.id == id }
    }
}
