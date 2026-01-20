//
//  SearchDebouncer.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Combine
import SwiftUI

/// A debouncer that triggers search after a delay when text changes.
/// Useful for auto-search functionality.
class SearchDebouncer: ObservableObject {
    @Published var searchText = ""
    let onSearch: (String) -> Void
    private var cancellables = Set<AnyCancellable>()
    
    init(onSearch: @escaping (String) -> Void) {
        self.onSearch = onSearch
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] text in
                // Only fire when there is meaningful input
                guard !text.isEmpty else { return }
                self?.performSearch(with: text)
            }
            .store(in: &cancellables)
    }
    
    func setSearch(text: String) {
        searchText = text
    }
    
    private func performSearch(with text: String) {
        onSearch(text)
    }
}
