# Product Manager - Flutter E-Commerce App 🛍️

A beautiful, pastel-themed Flutter mobile app demonstrating navigation, routing, and state management for a tiny e-commerce product manager with modern UI/UX design.

## Features

- 🎨 **Pastel Aesthetic UI**: Beautiful soft colors (lavender, mint, peach, cream)
- 🛒 **Grid Product Display**: 2-column grid with stunning product cards
- ✨ **Smooth Animations**: Slide + fade transitions and Hero animations
- 📦 **CRUD Operations**: Create, Read, Update, and Delete products
- 🗺️ **Named Routes**: Centralized routing configuration with custom transitions
- 🎭 **Hero Animations**: Smooth image transitions between screens
- 🔄 **State Management**: Provider pattern for managing product state
- ✅ **Form Validation**: Input validation on product creation/editing
- ⚠️ **Unsaved Changes Dialog**: Warns users before discarding changes
- 🎯 **Material Design 3**: Modern, rounded corners and soft shadows
- 🔤 **Google Fonts**: Poppins font family throughout

## Tech Stack

- **Flutter**: 3.x+ (stable channel)
- **State Management**: Provider (^6.0.0)
- **UI/Fonts**: Google Fonts (^6.1.0) - Poppins
- **Navigation**: Named routes with custom slide + fade transitions
- **Design**: Material Design 3 with pastel color palette
- **Architecture**: Clean separation of concerns (models, screens, providers, routes, theme, widgets)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── routes.dart              # Central route configuration with transitions
├── models/
│   └── product.dart         # Product model
├── providers/
│   └── product_provider.dart # State management for products
├── screens/
│   ├── home_screen.dart     # Product grid screen (pastel cards)
│   ├── product_view_screen.dart # Product details screen (hero card)
│   └── product_edit_screen.dart # Add/Edit form (pastel inputs)
├── theme/
│   └── app_theme.dart       # Pastel color palette and theme
└── widgets/
    ├── product_card.dart    # Pastel product card for grid
    ├── pastel_button.dart   # Gradient pastel button
    └── pastel_placeholder_image.dart # Large gradient image placeholder
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository** (if applicable):
   ```bash
   cd task_7
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Verify Flutter Installation

```bash
flutter doctor
```

Ensure all required components are installed.

## Routing Architecture

### Route Definitions

All routes are defined centrally in `lib/routes.dart`:

- `/` - HomeScreen (product list)
- `/product` - ProductViewScreen (product details)
- `/edit` - ProductEditScreen (add/edit product)

### Custom Transitions

- **Slide Transition**: Implemented via `PageRouteBuilder` in `onGenerateRoute`
- **Hero Animation**: Product avatar transitions smoothly from list to detail view
- **Duration**: 300ms with easeInOut curve

### Data Passing

- **To ProductViewScreen**: Pass `ProductViewArguments` with `productId`
- **To ProductEditScreen**: Pass `ProductEditArguments` with optional `productId` (null for add mode)
- **Return from Edit**: Use `Navigator.pop(context, product)` to return created/updated product

## Acceptance Test Steps

Follow these steps to verify the app functionality:

### 1. Launch App
- ✅ App launches successfully
- ✅ HomeScreen displays with 3 sample products
- ✅ FloatingActionButton (+) is visible

### 2. Add Product
- ✅ Tap the FloatingActionButton (+)
- ✅ ProductEditScreen opens with "Add Product" title
- ✅ Enter title: "Tablet"
- ✅ Enter description: "High-resolution tablet for reading and browsing"
- ✅ Tap "Add Product" button
- ✅ Screen slides back to HomeScreen
- ✅ New product "Tablet" appears in the list

### 3. View Product
- ✅ Tap on "Tablet" product from the list
- ✅ ProductViewScreen opens with slide transition
- ✅ Hero animation plays (avatar transitions smoothly)
- ✅ Product details are displayed (Title, Description, ID)

### 4. Edit Product
- ✅ From ProductViewScreen, tap the Edit icon (top right) or "Edit Product" button
- ✅ ProductEditScreen opens with "Edit Product" title
- ✅ Title and description are pre-filled
- ✅ Change title to "Gaming Tablet"
- ✅ Change description to "High-performance gaming tablet with amazing graphics"
- ✅ Tap "Save Changes"
- ✅ Screen returns to ProductViewScreen
- ✅ Updated details are displayed

### 5. Verify Update on Home
- ✅ Tap back to return to HomeScreen
- ✅ "Gaming Tablet" appears in the list with updated title

### 6. Delete Product
- ✅ Tap on "Gaming Tablet" to open ProductViewScreen
- ✅ Tap the Delete icon (top right)
- ✅ Confirmation dialog appears
- ✅ Tap "Delete"
- ✅ Screen returns to HomeScreen
- ✅ "Gaming Tablet" is removed from the list

### 7. Test Validation
- ✅ Tap FloatingActionButton (+) to add product
- ✅ Leave title empty and tap "Add Product"
- ✅ Validation error appears: "Title is required"
- ✅ Enter title "AB" (less than 3 characters)
- ✅ Validation error appears: "Title must be at least 3 characters"
- ✅ Enter valid title but leave description empty
- ✅ Validation error appears: "Description is required"

### 8. Test Unsaved Changes Dialog
- ✅ Tap FloatingActionButton (+) to add product
- ✅ Enter some text in title field
- ✅ Tap back button or close icon
- ✅ "Discard Changes?" dialog appears
- ✅ Tap "Continue Editing" - stays on edit screen
- ✅ Tap back again, then tap "Discard" - returns to HomeScreen

### 9. Test Edit/Delete from List
- ✅ From HomeScreen, tap Edit icon on any product
- ✅ ProductEditScreen opens in edit mode
- ✅ Make changes and save - list updates
- ✅ From HomeScreen, tap Delete icon on any product
- ✅ Confirmation dialog appears
- ✅ Confirm delete - product is removed

## Acceptance Criteria Checklist

- ✅ **Named routes** are defined in a central file (`routes.dart`)
- ✅ **Navigation uses named routes** (`Navigator.pushNamed`)
- ✅ **Data passed between screens** using `RouteSettings.arguments` and `Navigator.pop` return values
- ✅ **Home → View → Edit flow** works and updates list on return
- ✅ **Slide transitions** implemented via `onGenerateRoute` and `PageRouteBuilder`
- ✅ **Hero animation** present between Home and View screens
- ✅ **Back button behaves correctly** on edit screen (with unsaved changes dialog)
- ✅ **README included** with run instructions and routing explanation

## Key Implementation Details

### State Management
- Uses `ChangeNotifierProvider` from the `provider` package
- `ProductProvider` manages in-memory product list
- All CRUD operations notify listeners for reactive UI updates

### Navigation Flow
```
HomeScreen (/)
    ├─→ ProductViewScreen (/product) [with productId]
    │       └─→ ProductEditScreen (/edit) [with productId]
    │               └─→ Returns Product → Updates provider
    └─→ ProductEditScreen (/edit) [without productId]
            └─→ Returns Product → Adds to provider
```

### Form Validation
- Title: Required, minimum 3 characters
- Description: Required, minimum 10 characters
- Real-time validation on form submission

### Back Button Handling
- Uses `WillPopScope` to intercept back button
- Shows confirmation dialog if unsaved changes exist
- Properly returns `null` when cancelled

## Sample Git Commit Messages

```bash
feat: add project structure and dependencies
feat: add Product model and ProductProvider
feat: add named routes with slide transitions
feat: implement HomeScreen with product list
feat: implement ProductViewScreen with Hero animation
feat: implement ProductEditScreen with validation
feat: add unsaved changes dialog
feat: add delete confirmation dialog
docs: add comprehensive README with acceptance tests
```

## Future Enhancements

- Add product images
- Implement search and filter
- Add persistent storage (SQLite/Hive)
- Add unit and widget tests
- Implement categories and tags
- Add sorting options

## License

This project is for educational purposes.

## Author

Created as a demonstration of Flutter navigation and routing patterns.

