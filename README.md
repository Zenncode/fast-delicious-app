# Fast and Delicious Food — Flutter Mobile Application

A complete, self-contained Flutter food delivery mobile app replicating the dark-mode UI/UX design from the reference screens.

## Included Screens & Features
1. **Home Catalog (`Fast and Delicious Food`)**: Category tabs (`Pizza`, `Burger`, `Sushi`, `Kebab`, `Soup`), real-time search & filter modal, horizontal dish cards (`Sake Roll` $14,50, `Maguro` $12,75, `Plain Soup` $8,25), and quick add-to-cart buttons.
2. **3D Zoom Side Drawer**: Smooth scale-and-translate drawer menu with links to `Favorites`, `Payment Methods`, `My Order`, `History`, `Complaint`, `Privacy Policy`, and `Log-out`.
3. **Food Detail Screen (`Sake Roll`)**: Custom vector sushi & food artwork, interactive quantity selector (`- 1 +`), 4 spec badges (`130 cal`, `15-20 min`, `4.9 vote`, `350g`), description, and `Add to Cart` action.
4. **My Cart (`My Cart`)**: Line items with custom vector thumbnails, quantity controls, item removal (`x`), and dynamic `Total Price` (`$33,50`).
5. **Payment Screen (`Payment`)**: Radio cards for `Credit Card` (Mastercard), `Paypal`, and `Google Play`, editable coupon field (`FastDelicious/3572`), `Taxation` (`$15.00`), and `Order Now` checkout.
6. **Live Delivery Map Tracking**: Custom-painted dark street map with golden delivery route between the restaurant sushi marker and destination pin (`3720 Filbert Dr, Danielsville, PA`), plus an expandable/collapsible bottom card with the `26 minutes` delivery timeline and courier details (`Robert Odell`).
7. **My Profile & Change Password**: Bokeh header backdrop, avatar with `+` badge, editable profile cards (`Emre Huzeyfe Baştaş`, `+90 410 245 22 15`, `huzeyfebastas@gmail.com`, `Credit Card, Apple Pay`, `3720 Filbert Dr, Danielsville`), and `Change Password` bottom sheet.
8. **Notifications (`Notifications`)**: Loyalty point reward feed (`+30`, `+50`, `+20`, `+70` points) with color-coded circular badges.
9. **Authentication (`Login` / `Sign up` / `Forgot Password`)**: Custom chef hat & floating ingredients vector header, tab switcher, and password recovery sheet.

## Quick Start
```bash
flutter pub get
flutter run
```

## Project Structure
```
lib/
  main.dart              # Entry point + root app widget
  theme.dart             # Design tokens (AppColors)
  models.dart            # Domain models + price formatting
  app_state.dart         # Central state: catalog, cart, orders, session
  widgets.dart           # Shared UI building blocks
  painters.dart          # Custom vector artwork & map painters
  sheets.dart            # Modal sheets & dialogs
  screens/               # One file per screen (home, detail, cart, payment, ...)
test/
  widget_test.dart       # Home-screen smoke test
  app_state_test.dart    # AppState unit tests
```
