//
//  FilterSheetView.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/19/26.
//

import SwiftUI

struct FilterRecipeView: View {
    @Environment(SearchRecipeVM.self) var viewModel
    @Environment(\.dismiss) var dismiss

    /// Working copy of the filter used only inside this sheet.
    /// Changes are applied back to the main view model only when the user taps "Apply".
    @State private var tempFilter: RecipeFilter = .init()

    @State private var scrollPhase: ScrollPhase?
    @State private var scrollPosition: String?
    @State private var activeOption: RecipeFilterOption = .diet

    @Namespace private var animation

    var body: some View {
        VStack {
            SheetTitleView(title: "Filter")
            
            HStack(spacing: 0) {
                // LEFT MENU
                ScrollView {
                    filterOptions()
                }
                .containerRelativeFrame(.horizontal, { length, _ in
                    return length * 0.3
                })
                .background(Color(hex: "e5e5e5"))

                // RIGHT CONTENT
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            dietSelect {
                                activeOption = .diet
                            }
                            .id(RecipeFilterOption.diet.rawValue)
                            
                            ingredientsSelect {
                                activeOption = .ingredients
                            }
                            .id(RecipeFilterOption.ingredients.rawValue)

                            servingsSelect {
                                activeOption = .servings
                            }
                            .id(RecipeFilterOption.servings.rawValue)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollDismissesKeyboard(.automatic)
                    .scrollPosition(id: $scrollPosition)
                    .safeAreaPadding(.horizontal, 12)
                    .onScrollPhaseChange { _, phase in
                        scrollPhase = phase
                    }
                    .onChange(of: activeOption) { _, newValue in
                        guard scrollPhase != .interacting else { return }
                        scroll(newValue, using: proxy)
                    }
                }
            }
        
            buttonStack
        }
        .background(.white)
        .onAppear {
            // Sync the working copy from the current committed filter
            tempFilter = viewModel.filter
            scrollPosition = activeOption.rawValue
        }
        .onChange(of: scrollPosition ?? "") { _, newValue in
            guard let option = RecipeFilterOption(rawValue: newValue) else { return }
            activeOption = option
        }
    }

    
    private func scroll(_ option: RecipeFilterOption, using proxy: ScrollViewProxy) {
        withAnimation(.snappy(duration: 0.3)) {
            proxy.scrollTo(option.rawValue, anchor: .top)
        }
    }
    
    @ViewBuilder
    private func filterOptions() -> some View {
        let filterOptions = RecipeFilterOption.allCases
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<filterOptions.count, id: \.self) { index in
                let option = filterOptions[index]
                let isActive = activeOption == option
                createFilterOption(option, isActive: isActive)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3)) {
                            activeOption = option
                        }
                    }
                
            }
        }
    }
    
    private func createFilterOption(_ option: RecipeFilterOption,
                                    isActive: Bool) -> some View {
        Text(option.title)
            .poppinsRegular(size: 12)
            .foregroundStyle(isActive ? AppColors.primary : Color.init(hex: "111111"))
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if isActive {
                    Rectangle()
                        .fill(.white)
                        .overlay(alignment: .leading) {
                            AppColors.primary
                                .frame(width: 6)
                        }
                        .matchedGeometryEffect(id: "transition", in: animation)
                }
            }
            .contentShape(Rectangle())
    }

    private var selectedDiets: [DietaryAttribute] {
        tempFilter.dietaryAttributes ?? []
    }
    
    func dietSelect(onExpand: @escaping () -> Void) -> some View {
        CollapsibleView(
            isExpanded: true,
            onExpansionChange: { if $0 { onExpand() } }
        ) { isExpanded in
            collapsibleHeader(
                title: "Selected Diet",
                description: selectedDiets.isEmpty ? "All diets" : "\(selectedDiets.count) selected",
                isExpanded: isExpanded
            )
        } content: {
            DietFilterView(filter: $tempFilter)
        }
    }
    
    private func ingredientsSelect(onExpand: @escaping () -> Void) -> some View {
        CollapsibleView(
            isExpanded: true,
            onExpansionChange: { if $0 { onExpand() } }
        ) { isExpanded in
            collapsibleHeader(
                title: "Ingredients",
                description: "Include or exclude ingredients",
                isExpanded: isExpanded
            )
        } content: {
            IngredientFilterView(filter: $tempFilter)
        }
    }

    private func servingsSelect(onExpand: @escaping () -> Void) -> some View {
        CollapsibleView(
            isExpanded: true,
            onExpansionChange: { if $0 { onExpand() } }
        ) { isExpanded in
            collapsibleHeader(
                title: "Servings",
                description: tempFilter.servings == nil ? "All servings" : "\(tempFilter.servings!) servings",
                isExpanded: isExpanded
            )
        } content: {
            ServingsFilterView(filter: $tempFilter)
                .padding(.bottom, 16)
        }
    }
    

    @ViewBuilder
    func collapsibleHeader(
        title: String,
        description: String,
        isExpanded: Bool
    ) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .poppinsRegular(size: 14)
                    .foregroundStyle(.black)
                
                Text(description)
                    .poppinsRegular(size: 10)
                    .foregroundStyle(Color.init(hex: "111111"))
            }

            Spacer()

            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.easeInOut(duration: 0.25), value: isExpanded)
        }
        .padding(.vertical)
        .background(.white)
        .contentShape(Rectangle())
    }
    
    private var buttonStack: some View {
        HStack {
            resetFiltersBtn
            applyFiltersBtn
        }
        .padding(12)
    }
    private var resetFiltersBtn: some View {
        Button{
            tempFilter.reset()
        } label: {
            Text("Reset")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(AppColors.primary)
                .poppinsMedium(size: 12)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.primary, lineWidth: 1)
                }
        }
        .buttonStyle(AnimatedButtonStyle())
    }
    
    private var applyFiltersBtn: some View {
        PrimaryButton(title: "Apply") {
            dismiss()
        
            ///Check first if any changes happened
            ///If no changes happened just dimiss the sheet
            guard !tempFilter.isEquivalent(to: viewModel.filter) else { return }
            viewModel.filter = tempFilter
            Task { await viewModel.searchRecipes() }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = SearchRecipeVM()
    FilterRecipeView()
        .environment(viewModel)
        .task {
            await viewModel.requestData()
        }
}
