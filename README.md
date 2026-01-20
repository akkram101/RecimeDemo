## 🍳 ReciMeDemo

ReciMeDemo is a small SwiftUI demo app that showcases a recipe discovery and search experience with filters, mock networking, and guided onboarding (showcases).

This project was built in roughly **2 days** as a demo. Some choices are intentionally optimized for speed and clarity rather than full production hardening.  
Also note: **I’m not a dedicated UI designer**, so the visuals are intentionally simple and focused on interaction and architecture rather than pixel-perfect design.

---

## 🎯 Original Assignment (Context)

The original objective was to build a **native iOS app using Swift + SwiftUI** that allows users to browse and search a collection of cooking recipes loaded from a **mock API response (local JSON)**.

Each recipe contains:

- Title
- Description
- Number of servings
- Ingredients
- Cooking instructions
- Dietary attributes (e.g. vegetarian)

Technical requirements (as given):

- Use **Swift**
- Use **SwiftUI**
- Target **iOS 26+**
- Use Previews
- Use Packages (if needed)
- Mock API response using `.json` file

This demo intentionally goes beyond the baseline requirements with additional UX features (see **Key Features** below).

---

## 🚀 Setup Instructions

### Requirements

- Xcode 16+ (or the latest stable Xcode that supports Swift 5.10 and SwiftUI previews)
- iOS 18.1+ simulator or device

### Getting Started

1. **Clone the repo**

   ```bash
   git clone https://github.com/akkram101/RecimeDemo.git
   cd ReciMeDemo
   ```

2. **Open the project**

   - Open `ReciMeDemo.xcodeproj` in Xcode.

3. **Run**

   - Select the `ReciMeDemo` scheme.
   - Choose an iOS simulator (e.g. iPhone 15).
   - Hit **Run**.

The project includes bundled mock JSON and assets, so it runs entirely offline with no external services.

---

## ✨ Key Features (Beyond the Baseline)

- **Search**
  - Text search with debouncing
  - Recent searches (most recent first)
- **Smart Search Suggestions**
  - Suggestions for **text**
  - Suggestions for **ingredients** and **diets** (loaded from mock endpoints)
  - Selecting a suggestion can auto-apply filters and trigger search
- **Filters**
  - Diet filters, include/exclude ingredient filters, and servings filter
  - Filter sheet uses a **temporary working copy** so changes only apply on “Apply”
- **Guided Walkthrough / Onboarding**
  - Mascot-driven showcases (feature cards) to guide the user
  - Animated overlay-based walkthrough using `ShowcaseManager`
- **Cooking Overlay**
  - A cooking overlay concept so users can keep using the app while cooking (instead of being stuck on a cooking-only screen)
- **UX Animations**
  - Animated tab bar visibility behavior and transitions throughout the UI

### Note on rerenders / images

Some views intentionally use **random images** (e.g. mock recipe images). This can cause extra rerenders/visual changes when lists refresh or state updates, especially in the simulator. A production version would typically use stable image URLs/IDs and caching.

---

## 🧱 High-Level Architecture

### Layers & Structure

- **App entry**
  - `ReciMeDemoApp` sets up the root view:
    - Wraps the app in `RootView` (for a global overlay window).
    - Hosts `MainTabView` for tab navigation.

- **Screens**
  - Located under `Screens/`:
    - `HomeView`, `DiscoverView`, `MealPlanView`, `ActivityView`, `ProfileView`.
    - `SearchRecipeView` (+ filter subviews) for search & filtering.
  - Each screen has a **view model** where needed (e.g. `HomeVM`, `SearchRecipeVM`, `TabBarViewModel`).

- **View Models**
  - Use **SwiftUI’s `@Observable`** and are marked **`@MainActor`** when they own UI state:
    - `SearchRecipeVM`
    - `TabBarViewModel`
  - View models:
    - Hold UI state as `Loadable<T>` (`idle / loading / success / failure`).
    - Coordinate with services (e.g. `RecipeService`) for data loading.
    - Expose simple methods like `submitSearch(_:)`, `searchRecipes()`, `requestData()`.

- **Networking**
  - Located under `Networking/`:
    - `Core/` – `BaseService`, `NetworkProvider`, `NetworkError`, `MockableTarget`.
    - `Endpoints/` – `RecipeAPI`, `AuthAPI`, `UserAPI`, etc.
    - `Models/` – `Recipe`, `Ingredient`, `DietaryAttribute`, `RecipeFilter`, etc.
    - `Service/` – `RecipeService`, `AuthService`, etc.
  - Uses **Moya** for API targets plus a **`BaseService`** that:
    - Supports **mock JSON loading** for demo.
    - Decodes into a generic `BaseResponse<T>` using `SmartCodable`.
    - Maps status codes to `NetworkError`.

- **UI Components & Theme**
  - Under `UI/`:
    - Reusable components (`SearchTextField`, `SectionBlock`, `ShimmerView`, `ErrorMascotView`, etc.).
    - `PrimaryButton` & `AnimatedButtonStyle`.
    - `AppColors` and font modifiers (`poppinsRegular`, etc.).
  - `RootView` sets up a **pass-through overlay window** for things like global showcases/alerts.

- **State Helpers**
  - `Loadable<Value>`: wraps async loading state.
  - `SearchDebouncer`: debounces search text using Combine.
  - `SearchDataStore`: in-memory “mock DB” for recent searches, suggestions, and lookup dictionaries.

- **Showcase & Alerts**
  - `ShowcaseManager` and `AlertManager` are **singleton-style managers** used across the app to:
    - Show guided feature overlays (e.g. filter button, search bar).
    - Present global alerts using a shared overlay.

---

## 🧠 Key Design Decisions

### 1. `@MainActor` View Models

- **What**: UI-facing view models like `SearchRecipeVM` and `TabBarViewModel` are marked `@MainActor`.
- **Why**:
  - They own **UI state** and are used only from SwiftUI views.
  - This avoids subtle threading bugs and makes the compiler enforce main-thread access.
  - Allows direct assignments like `self.searchResults = .success(...)` without extra `MainActor.run`.

**Effect**:

- Async methods do:
  1. Start on the main actor,
  2. `await` network calls (off-main),
  3. Resume on the main actor and update SwiftUI state.

### 2. `Loadable<T>` for UX & State Handling

- **What**: `Loadable<Value>` (`idle / loading / success / failure`) wraps async state for:
  - `recentSearches`, `recommendedRecipes`, `ingredients`, `diets`, `searchResults`, etc.
- **Why**:
  - Forces every feature to think about **all states**, not just the happy path:
    - **Idle** – nothing loaded yet.
    - **Loading** – show skeletons/spinners.
    - **Success** – render data.
    - **Failure** – show an error mascot and retry options.
  - Makes the UX more robust by design:
    - Slow internet is handled by showing a loading state.
    - Bad responses / errors are handled by the failure state.
    - Developers don’t “forget” edge cases because the enum is exhaustive.

This pattern helps ensure the app automatically handles **happy path, slow network, and error paths** consistently.

### 3. Networking via `BaseService` + Moya

- **What**:
  - `BaseService` provides a generic `request<T: Decodable>` with:
    - Optional mock JSON loading (`MockableTarget` + `mockFileName`).
    - Standard response parsing and error mapping.
  - `RecipeService` is a thin wrapper over `RecipeAPI` endpoints.

- **Why**:
  - Keeps demo code clean while resembling a real production layering.
  - Makes it easy to switch between real and mocked data.
  
### 3. Networking via BaseService + Moya

- **What**:
- `BaseService` is the core networking layer that wraps a shared MoyaProvider<MultiTarget>.
    - Provides a generic request<T: Decodable> method that:
     - Loads mock JSON files when useMockData is enabled (MockableTarget + mockFileName).
     - Parses responses into BaseResponse<T> and unwraps the body payload.
    - Maps status codes into NetworkError cases.
    - Feature-specific services (RecipeService, AuthService, UserService, CommunityService) inherit from BaseService and delegate to their respective API enums.
    - API.Environment defines development, staging, and production base URLs for easy switching.

- **Why**:
    - Separation of concerns: each service handles only its domain logic.
     - Environment flexibility: switch between dev/staging/prod with a single enum value.
      - Mock-friendly: toggle useMockData to simulate responses for demos or tests.
    - Extensible layering: individual services can override BaseService behavior if needed.
    - Production resemblance: mirrors real-world architecture with clean layering.


### 4. Search, Debouncing & Suggestions

- **What**:
  - `SearchRecipeVM` orchestrates:
    - Text input (`searchText`),
    - `submitSearch(_:)`,
    - `searchRecipes()` with mock filtering.
  - `SearchTextField` + `SearchDebouncer`:
    - Debounce typing by 300ms.
    - Fire `onSearch` only when text is non-empty.
  - `SearchDataStore`:
    - Keeps recent searches, ingredient and diet lookups, and suggestions.

- **Why**:
  - Avoids hammering the service while typing.
  - Keeps the search UX responsive and predictable.

### 5. Filter Sheet with Temporary Filter

- **What**:
  - `FilterRecipeView` holds a **temporary `tempFilter: RecipeFilter`**.
  - Child views (`DietFilterView`, `IngredientFilterView`, `ServingsFilterView`) receive `@Binding var filter: RecipeFilter` to mutate this working copy.
  - On **Apply**:
    - If `tempFilter` is **equivalent** to `viewModel.filter` → just dismiss.
    - Otherwise, assign `viewModel.filter = tempFilter` and trigger a search.

- **Why**:
  - Changes inside the sheet do **not** affect the main filter until the user confirms.
  - Avoids unnecessary re-searching and keeps the UX intuitive.

### 6. Showcase & Alert Managers as Singletons

- **What**:
  - `ShowcaseManager.shared` and `AlertManager.shared` are singleton-like, accessed directly from views and view models.
- **Why (demo tradeoff)**:
  - Very quick to integrate across multiple screens.
  - Avoids plumbing these dependencies through every initializer for a short-lived prototype.

**Future direction** (for production):

- Extract protocols and inject them via environment / DI while keeping a `shared` default.

---

## ⚖️ Assumptions & Tradeoffs

### Timebox / Scope

- Built in about **2 days** as a demo:
  - Some shortcuts are taken intentionally (globals, statics, simple error surfaces).
  - Certain UI code is reused directly instead of being refactored into modifiers or reusable components, due to limited time.

### Assets & Resource Management

- Current state:
  - Assets are organized by folders (Global, MockImages, Mascot, etc.) but not yet fully normalized.
  - Image names are hard-coded (`Image(recipe.randomImage)` etc).
- Intended improvements:
  - Integrate **R.swift** for:
    - Compile-time safe asset, color, and font references.
    - Consistent naming and prevention of missing-asset runtime bugs.
  - Introduce a small **Design System** layer:
    - `AppColors`, typography, spacing tokens used everywhere.
    - No raw hex strings spread across the UI.

### Strings & Localization

- Current state:
  - User-facing strings are inlined in the views (e.g. section titles, guide messages).
- Intended improvements:
  - Move to a `Localizable.strings`-based system and/or a `Strings`/`L10n` wrapper.
  - Organize strings by feature to prepare for **future localization**.
  - Potentially integrate R.swift for typed string keys.

### Global State

- **SearchDataStore**:
  - Static, in-memory storage for:
    - `recentSearches`,
    - Suggestion lists,
    - Ingredient & diet lookups.
  - Works well for **demo/mock** behavior but is essentially global mutable state.

### Data Structures, Pagination & Scaling

- Current state:
  - Many collections (e.g. lists of recipes) are simple **arrays**.

- Future improvements for larger datasets (e.g. 1,000+ recipes):
  - Introduce **pagination / infinite scrolling**:
    - Load recipes in pages from the API.
    - Append as the user scrolls instead of loading everything at once.
  - Use **dictionaries / maps** where lookups are frequent:
    - E.g. `Dictionary<RecipeID, Recipe>` for O(1) access.
    - Dictionary-based indexes for tags/ingredients when data grows.
  - Combine array order for UI with dictionary-backed indexing for performance.

For now, the demo sticks to arrays for **simplicity and readability**, with the understanding that structures would evolve as data volume grows.

### Concurrency & Data Races

- UI-bound view models (`SearchRecipeVM`, `TabBarViewModel`) are **`@MainActor`**:
  - All property mutations are main-actor-isolated.
  - This drastically reduces the chance of UI data races.

- Some global state (e.g. `SearchDataStore`) relies on:
  - Conventionally being accessed from the main actor (via the VM),
  - Not yet wrapped in an `actor` or explicit `@MainActor` annotation.

For a real production app, tightening this up (e.g. actor-based or explicit `@MainActor` on such types) would be a next step.

---

## 🧪 Known Limitations

- **Mock Data Only**
  - The app uses bundled JSON for network responses via Moya’s targets.
  - There’s no real backend hooked up.

- **iOS Version**
  - This demo is currently configured with an **iOS 18.1** deployment target.

- **UI / Visual Design**
  - The UI is intentionally simple and functional; it is **not** the work of a professional UI designer.
  - While the primary focus was on building a clean and maintainable architecture, attention was also given to UI/UX.
  - Some flows, overlays, and interactions were designed to feel intuitive and user-friendly, even if the visual polish is minimal.

- **Performance / UI Hitches**
  - Some state changes (e.g. loading many recipes + images at once) can cause brief UI lag, especially in the simulator.
  - This is acceptable for a demo; production versions would:
    - Use smaller thumbnails / lazy loading.
    - Possibly paginate or virtualize heavy lists.

- **Scaling**
  - For large datasets (e.g. 1,000+ recipes), a production approach should add:
    - Pagination/infinite scrolling
    - Dictionary-based indexes for frequent lookups (while still using arrays for ordered UI)

- **Limited Error Surface**
  - Errors surface as generic UI messages via `Loadable.failure` and `ErrorMascotView`.
  - No advanced retry/backoff or offline handling is implemented.

- **Testing**
  - No formal unit or snapshot tests yet.

---

## 🧭 Future Improvements

If this evolves beyond a demo, the next steps would likely be:

- **Resources & Design System**
  - Integrate **R.swift** for assets/colors/fonts/strings.
  - Centralize colors/typography/spacing into a small design system module.

- **Dependency Injection & Protocols**
  - Define protocols for services and managers (`RecipeServiceType`, `AlertManagerType`, `ShowcaseManagerType`, `SearchDataStoreType`).
  - Inject them into view models (with `@Environment` or a DI container) to improve testability and modularity.

- **Concurrency & Background Work**
  - Move heavy mock loading/decoding work off the main actor and only assign final results on main.
  - Consider actors for mutable global state like `SearchDataStore`.

- **Pagination & Large Data Handling**
  - Implement true pagination/infinite scroll for recipes.
  - Introduce dictionary-based indexes for fast lookups when recipe counts grow.

- **Localization & Accessibility**
  - Externalize user-facing strings and support multiple locales.
  - Improve dynamic type, VoiceOver labels, and general accessibility.

---

## 📌 Summary

This project is a **small, focused SwiftUI demo** showcasing:

- Modern async/await networking (with mock data).
- A clear `Loadable`-based async state model for robust UX across happy/slow/error paths.
- Search with debouncing and filtering using a temporary working filter.
- Simple but scalable patterns (services, VMs, managers) that can evolve into production-ready architecture.

It intentionally trades some structural purism (globals, missing DI, inline strings, non-pixel-perfect UI) for **speed and clarity** within a 2-day timebox.

---

## 🙏 Acknowledgements

- **UI & imagery**: Thanks to the UI inspiration and the image assets used throughout the app.
- **Design**: A lot of the images and design ideas were from `Free` Figma desings.
- **Mascots**: The mascot images were generated with the help of **AI** tooling, then integrated into the walkthrough and feature guidance experience.
