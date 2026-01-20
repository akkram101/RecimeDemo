//
//  SearchRecipeView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct SearchRecipeView: View {
    @Binding var isSearching: Bool
    @State private var viewModel = SearchRecipeVM()
    
    @State private var isShowingFilterSheet: Bool = false
    @FocusState private var isTyping: Bool

    @State private var selectedRecipe: Recipe?
    
    private var shouldShowSuggestions: Bool {
        return isTyping && !viewModel.searchText.isEmpty
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                searchHeader
                
                if shouldShowSuggestions {
                    SearchSuggestionsView(searchText: viewModel.searchText) { handleSearchSuggestion($0)
                    }
                } else {
                    VStack(spacing: 0) {
                        switch viewModel.searchResults {
                        case .idle:
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 12) {
                                    recentSearches
                                    recommendedRecipes
                                }
                            }
                        case .loading:
                            LoadingRecipeListView()
                        case .success(let value):
                            SearchRecipeResultView(recipes: value) {
                                selectedRecipe = $0
                            }
                        case .failure(let error):
                            ErrorMascotView(error: error)
                        }
                    }
                    .safeAreaPadding(12)
                }
            }
            .background(.white)
            .navigationDestination(item: $selectedRecipe) {
                RecipeDescription(recipe: $0)
            }
            .task {
                await viewModel.requestData()
            }
            .task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                ShowcaseManager.shared.showIfNeed(.filterRecipe)
            }
        }
        .sheet(isPresented: $isShowingFilterSheet) {
            FilterRecipeView()
                .presentationDetents([.fraction(0.7)])
                .interactiveDismissDisabled()
        }
        .environment(viewModel)
    }
    
    private var searchHeader: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                backBtn
                SearchTextField(enableAutoSearch: true) { typedString in
                    viewModel.searchText = typedString
                } onSearch: { searchedString in
                    Task {
                        await viewModel.submitSearch(searchedString)
                    }
                } onClear: {
                    viewModel.resetSearchResults()
                }
                .focused($isTyping)
                filterBtn
                    .addShowCase(id: .filterRecipe) {
                        filterBtn
                    } guide: {
                        filterGuide
                    } onDismiss: {}

            }

        }
        .padding(.bottom, 12)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(height: 1)
                .offset(y: 2),
            alignment: .bottom
        )
        .padding(.horizontal, 12)
    }
    
        
    private var backBtn: some View {
        Image(systemName: "chevron.left")
            .resizable()
            .scaledToFit()
            .frame(width: 10)
            .foregroundStyle(Color.black)
            .onTapGesture {
                isSearching = false
            }
    }
    
    private var filterBtn: some View {
        Image(systemName: "slider.horizontal.3")
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundStyle(Color.black)
            .onTapGesture {
                isShowingFilterSheet = true
                viewModel.resetSearchResults()
            }
            .overlay(alignment: .topTrailing) {
                if viewModel.filter.filterCount > 0 {
                    Text("\(viewModel.filter.filterCount)")
                        .poppinsRegular(size: 10)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background {
                            Circle()
                                .fill(AppColors.primary)
                        }
                        .offset(x: 8, y:-14)
                }
            }
            .padding(24)
            .background {
                Circle().fill(.white)
            }
    }
    
    private var filterGuide: some View {
        MascotFeatureCard(
            message: "Customize your dish: include or exclude ingredients, set portions, and let’s start cooking!",
            buttonTitle: "Let's Go!",
            buttonAction: {
                AlertManager.shared.dismissAlert()
                isShowingFilterSheet = true
            },
            mascot: .teaching,
            alignment: .leading
            )
        .transition(
            .move(edge: .leading)
            .combined(with: .scale(0.9, anchor: .bottomLeading))
            .combined(with: .opacity)
            )
        .offset(y: -150)
    }
    
    private var recommendedRecipes: some View {
        Group {
            switch viewModel.recommendedRecipes {
            case .success(let value):
                SectionBlock(title: "Recommended") {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 0),
                            GridItem(.flexible(), spacing: 0),
                            GridItem(.flexible(), spacing: 0)
                        ],
                        spacing: 12
                    ) {
                        ForEach(0..<value.count, id: \.self) { index in
                            let recipe = value[index]
                            VStack(spacing: 4) {
                                Image(recipe.randomImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text(recipe.title.split(separator: " ").first ?? "")
                                    .poppinsRegular(size: 12)
                                    .foregroundStyle(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectedRecipe = recipe
                            }
                        }
                    }
                }
                
            default:
                EmptyView()
            }
        }
    }

    
    private var recentSearches: some View {
        Group {
            switch viewModel.recentSearches {
            case .success(let value):
                SectionBlock(title: "Recent Searches") {
                    VStack(alignment: .leading) {
                        ForEach(0..<value.count, id:\.self) { index in
                            let searchString = value[index]
                            searchCell(searchString)
                                .onTapGesture {
                                    Task {
                                        await viewModel.submitSearch(searchString)
                                    }
                                }
                        }
                    }
                }

            default: EmptyView()
            }
        }
    }
    
    private func searchCell(_ text: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "timer")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundStyle(Color(hex: "#393939"))
            Text(text)
                .poppinsRegular(size: 14)
                .foregroundStyle(Color(hex: "#393939"))
            Spacer()
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 8)
                .foregroundStyle(Color(hex: "#393939"))
                .onTapGesture {
                    Task {
                        await viewModel.removeSearch(text)
                    }
                }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
    
    private func handleSearchSuggestion(_ suggestion: Suggestion) {
        switch suggestion.category {
        case .ingredient:
            guard let ingredients = viewModel.ingredients.value else {
                return
            }
            if let ingredient = ingredients.first(where: { $0.name == suggestion.title }) {
                viewModel.filter.addIncludeIngredient(ingredient)
                isTyping = false
                Task {
                    await viewModel.searchRecipes()
                }
            }

        case .diet:
            guard let diets = viewModel.diets.value else {
                return
            }
            if let diet = diets.first(where: { $0.name == suggestion.title }) {
                viewModel.filter.addDietaryAttribute(diet)
                isTyping = false
                Task {
                    await viewModel.searchRecipes()
                }
            }
        case .text:
            Task {
                await viewModel.submitSearch(suggestion.title)
            }
        case .custom: break
        }

    }
}

#Preview {
    SearchRecipeView(isSearching: .constant(false))
}
