//
//  SearchTextField.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI
import Combine

/// A reusable search text field with optional auto-search support.
/// - Features:
///   - Can trigger search manually (via keyboard "Search") or automatically (debounced).
struct SearchTextField: View {
    let onType: (String) -> Void
    let onSearch: (String) -> Void
    var onClear: (() -> Void)?
    private let autoSearch: Bool
    
    @FocusState private var isSearching: Bool
    
    @StateObject private var searchVM: SearchDebouncer
    @State private var text: String = ""
    
    /// Initializes a search text field.
    /// - Parameters:
    ///   - enableAutoSearch: If true, search is triggered automatically with debounce.
    ///   - onType: Callback when user is typing only triggered if enableAutoSearch is true
    ///   - onSearch: Callback when search is triggered.
    init(enableAutoSearch: Bool = false,
         onType: @escaping (String) -> Void,
         onSearch: @escaping (String) -> Void,
         onClear: (() -> Void)? = nil) {
        self.onType = onType
        self.onSearch = onSearch
        self.onClear = onClear
        self.autoSearch = enableAutoSearch
        
        _searchVM = StateObject(wrappedValue: SearchDebouncer { typedString in
            if enableAutoSearch {
                onType(typedString)
            }
        })
    }

    
    var body: some View {
        HStack(spacing: 12) {
            magnifyingGlassImg
            searchTextField
                .onSubmit {
                    submitSearch()
                }
            
            Spacer()
            if !text.isEmpty {
                clearIcon
            }
        }
        .padding(12)
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#f8f8f8"))
        }
        .contentShape(Rectangle())
        .onChange(of: text) { oldValue, newValue in
            searchVM.searchText = newValue
            if autoSearch {
                onType(newValue)
            }
        }
    }
    
    /// Manually trigger search when user presses "Search".
    private func submitSearch() {
        guard !text.isEmpty else { return }
        onSearch(text)
    }
    
    private var magnifyingGlassImg: some View {
        Image(systemName: "magnifyingglass")
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .foregroundStyle(Color(hex: "#393939"))
    }
    
    private var searchTextField: some View {
        TextField("", text: $text)
            .poppinsRegular(size: 14)
            .foregroundStyle(.black)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .focused($isSearching)
            .overlay(alignment: .leading) {
                if !isSearching {
                    Text("Search recipes")
                        .poppinsRegular(size: 14)
                        .foregroundStyle(Color(hex: "#9f9f9f"))
                        .opacity(text.isEmpty ? 1 : 0)
                        .allowsHitTesting(false)
                }
            }
            .submitLabel(.search)
    }
    
    private var clearIcon: some View {
        Image(systemName: "xmark")
            .resizable()
            .scaledToFit()
            .frame(width: 12)
            .padding(4)
            .foregroundStyle(.black)
            .overlay {
                Circle()
                    .stroke(Color.black, lineWidth: 1)
            }
            .onTapGesture {
                text = ""
                if let onClear {
                    onClear()
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Manual search (press "Search" on keyboard)
        SearchTextField { typedString in
            print("Manual typed: \(typedString)")
        } onSearch: { searchedString in
            print("Manual search triggered: \(searchedString)")
        }
        
        // Auto search (debounced as user types)
        SearchTextField(enableAutoSearch: true) { typedString in
            print("Auto typed: \(typedString)")
        } onSearch: { searchedString in
            print("Auto search triggered: \(searchedString)")
        }
    }
    .padding()

}
