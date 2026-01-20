//
//  HomeView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(TabBarViewModel.self) var tabVM
    @Environment(CookingManager.self) var cookingManager
    
    @State private var viewModel = HomeVM()
    @State private var isSearching: Bool = false
    
    //for demo navigation ignore variable
    @Binding var selectedRecipe: Recipe?
    
    var body: some View {
        VStack(spacing: 0) {
            if tabVM.isShowTabbar {
                HomeHeaderView(isSearching: $isSearching)
                    .transition(
                        .move(edge: .top)
                        .combined(with: .opacity)
                    )
                    .addShowCase(id: .searchRecipe, highlightView: {
                        HomeHeaderView(isSearching: .constant(false))
                            .safeAreaPadding(.horizontal, 12)
                    }, guide: {
                        searchGuide
                    }, onDismiss: {})
            }
            
            switch viewModel.recipes {
            case .idle:
                Spacer()
            case .loading:
                LoadingRecipeListView()
                    .safeAreaPadding(.top, 12)

            case .success(let value):
                RecipeListView(recipes: value) {
                    tabVM.showTabbar(true)
                    selectedRecipe = $0
                }
                .safeAreaPadding(.top, 12)
                .toggleToolbarOnScroll { tabVM.showTabbar($0) }
            case .failure( let error):
                ErrorMascotView(error: error)
            }
            
        }
        .safeAreaPadding(.horizontal, 12)
        .background(.white)
        .task {
            await viewModel.fetchData()
        }
        .fullScreenCover(isPresented: $isSearching) {
            SearchRecipeView(isSearching: $isSearching)
        }
        .environment(viewModel)
        .task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            ShowcaseManager.shared.showIfNeed(.searchRecipe)
            showCookingOverlayGuideIfNeed()
        }
        .onChange(of: isSearching) { oldValue, newValue in
            showCookingOverlayGuideIfNeed()
        }
    }
    
    private func showCookingOverlayGuideIfNeed() {
        Task {
            if cookingManager.isCooking {
                ShowcaseManager.shared.showIfNeed(.cookingOverlay)
            }
        }
    }
    
    
    private var searchGuide: some View {
        MascotFeatureCard(
            message: "Hey there friend! The search bar is your magic wand \nType an ingredient and watch the recipes appear!",
            buttonTitle: "Let's Go!",
            buttonAction: {
                AlertManager.shared.dismissAlert()
                isSearching = true
            },
            mascot: .thankful,
            alignment: .trailing
            )
        .offset(y: -150)
        .transition(.move(edge: .leading).combined(with: .scale(0.9, anchor: .bottomTrailing)).combined(with: .opacity))
    }
}

#Preview {
    HomeView(selectedRecipe: .constant(nil))
}
