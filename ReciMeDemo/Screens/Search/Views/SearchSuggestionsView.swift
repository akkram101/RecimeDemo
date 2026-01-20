//
//  SearchSuggestionsView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/20/26.
//

import SwiftUI

struct SearchSuggestionsView: View {
    let searchText: String
    let onSuggestionSelect: (Suggestion) -> Void
    let suggestions: [Suggestion] = SearchDataStore.suggestions

    private var filteredSuggestions: [Suggestion] {
        guard !searchText.isEmpty else { return suggestions }
        return suggestions.filter { suggestion in
            suggestion.title.lowercased().hasPrefix(searchText.lowercased())
        }
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filteredSuggestions.suffix(10).reversed()) { suggestion in
                    suggestionRow(for: suggestion)
                        .poppinsRegular(size: 12)
                        .foregroundStyle(Color(hex: "#393939"))
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSuggestionSelect(suggestion)
                        }
                }
            }
        }
        .safeAreaPadding(12)
        .background(.white)
        .scrollDismissesKeyboard(.immediately)
    }

    @ViewBuilder
    private func suggestionRow(for suggestion: Suggestion) -> some View {
        switch suggestion.category {
        case .text:
            EmptyView()

        case .ingredient:
            HStack(spacing: 12) {
                Image(systemName: "leaf")
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.title)
                    Text("in ingredients")
                }
                Spacer()
                arrowIcon
            }

        case .diet:
            HStack(spacing: 12) {
                Image(systemName: "heart")
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.title)
                    Text("in diets")
                }
                Spacer()
                arrowIcon
            }

        case .custom:
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.title)
                    if let description = suggestion.description {
                        Text(description)
                    }
                }
                Spacer()
                arrowIcon
            }
        }
    }

    
    @ViewBuilder
    private func buildIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 13)
    }
    
    private var arrowIcon: some View {
        Image(systemName: "arrow.up.left")
            .resizable()
            .scaledToFit()
            .frame(width: 12)
            .foregroundStyle(Color(hex: "#393939"))
    }
}

#Preview {
    SearchSuggestionsView(
        searchText: "Bu",
        onSuggestionSelect: { _ in }
    )
}
