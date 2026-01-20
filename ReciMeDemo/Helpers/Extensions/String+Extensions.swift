//
//  String+Extensions.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func containsCaseInsensitive(_ other: String) -> Bool {
        self.range(of: other, options: .caseInsensitive) != nil
    }
}
