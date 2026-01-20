//
//  MainTabView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = TabBarViewModel()
    @State private var cookingManager = CookingManager()
     
    //for demo navigation ignore variable
    @State private var selectedRecipe: Recipe?
    
    private var shouldShowOverlay: Bool {
        selectedRecipe == nil
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                switch viewModel.selectedTab {
                case .home: HomeView(selectedRecipe: $selectedRecipe)
                case .discover: DiscoverView()
                case .mealPlan: MealPlanView()
                case .activity: ActivityView()
                case .profile: ProfileView()
                }
                
                //Import Button
                //Cooking Overlay
                //Custom Tabbar
                bottomContent
                    .animation(.bouncy(duration: 0.3), value: shouldShowOverlay)
                    .padding(.bottom, !viewModel.isShowTabbar ? 50 : 0)
                    .ignoresSafeArea()

            }
            .environment(viewModel)
            .navigationDestination(item: $selectedRecipe) {
                RecipeDescription(recipe: $0)
                    .environment(cookingManager)
            }
            .environment(cookingManager)
        }
    }
    
    private var importBtn: some View {
        HStack {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .scaledToFit()
                .frame(width: 18)
            if viewModel.isShowTabbar {
                Text("Recipe")
                    .poppinsRegular(size: 16)
            }
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .padding(.horizontal,12)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.primary)
        }
        .padding(12)
        .drawingGroup()
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var cookingOverlay: some View {
        HStack {
            Image("cooking_pan")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            
            VStack(alignment: .leading) {
                Text(cookingManager.currentRecipe?.title ?? "")
                    .poppinsMedium(size: 14)
                    .foregroundStyle(.black)
                
                Text(cookingManager.currentStep?.description ?? "")
                    .poppinsMedium(size: 12)
                    .foregroundStyle(Color.init(hex: "888888"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .containerRelativeFrame(.horizontal) { length, _ in
                return length * 0.5
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("By :6:47 PM")
                    .poppinsMedium(size: 14)
                    .foregroundStyle(.black)
                
                if let servings = cookingManager.currentRecipe?.servings {
                    Text("Servings: \(servings)")
                        .poppinsMedium(size: 12)
                        .foregroundStyle(Color.init(hex: "888888"))
                }
            }
        }
        .foregroundStyle(.white)
        .padding(12)
        .frame(height: 70)
        .drawingGroup()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal,12)
        .padding(.bottom, 12)
    }
    
    private var bottomContent: some View {
        VStack(spacing: 0) {
            Spacer()
            if shouldShowOverlay {
                importBtn
                    .transition(.move(edge: .trailing))
                
                if cookingManager.isCooking {
                    cookingOverlay
                        .addShowCase(id: .cookingOverlay, highlightView: {
                            cookingOverlay
                                .transition(.opacity)
                        }, guide: {
                            cookingOverlayGuideView
                        }, onDismiss: {
                            
                        })
                        .transition(.move(edge: .bottom))
                }
            }
            
            if viewModel.isShowTabbar {
                CustomTabbarView()
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private var cookingOverlayGuideView: some View {
        MascotFeatureCard(
            message: "We’ve added a new overlay feature that lets you explore the app while cooking.",
            buttonTitle: "Let's Go!",
            buttonAction: { AlertManager.shared.dismissAlert() },
            mascot: .idea,
            alignment: .trailing
            )
        .transition(.move(edge: .trailing).combined(with: .scale(0.9, anchor: .bottomTrailing)).combined(with: .opacity))
        .offset(y: 100)
    }
}

#Preview {
    @Previewable @State var viewModel = TabBarViewModel()
    MainTabView()
        .environment(viewModel)
}
