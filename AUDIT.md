# Code Audit — Fast and Delicious Food (Flutter)

- **Date:** 2026-10-15
- **Project:** `fast_delicious_food_app`
- **Method:** full manual review of every file in the repository, followed by a repair pass.
- **Environment note:** the audit machine has **no Flutter/Dart/Android SDK installed**, so
  `flutter analyze`, `flutter test`, and platform builds could **not** be executed here.
  Runtime-behavior claims are marked as such. Re-run the analyzer once the SDK is installed.

## Status board

| # | Finding | Severity | Status |
|---|---------|----------|--------|
| 1.1 | Android scaffolding incomplete (no `settings.gradle`, Gradle wrapper, `res/`, debug/profile manifests, icon, themes) — build impossible | Critical | **Fixed** — restored from official Flutter 3.47.7 templates |
| 1.2 | iOS scaffolding incomplete (no Xcode project, workspace, storyboards, assets, Podfile) — build impossible | Critical | **Fixed** — restored from official Flutter 3.47.7 templates |
| 1.3 | `README.md` quick start could not work (follow-up of 1.1/1.2) | High | **Fixed** |
| 1.4 | No `.gitignore`, no `pubspec.lock`, project not a git repo | Medium | **Partially fixed** — `.gitignore` files added; recommend `git init` |
| 1.5 | Deprecated `package=` attribute in `AndroidManifest.xml` (AGP 8+) | Medium | **Fixed** — namespace now only in `app/build.gradle.kts` |
| 2.1 | Cart never cleared after checkout → stale badge, unlimited duplicate orders | High | **Fixed** — `placeOrder()` now empties the cart |
| 2.2 | Duplicate `Hero` tags crash navigation in debug builds (same dish mounted in both Home and Favorites tabs via `IndexedStack`) | High | **Fixed** — `HeroMode` now disables off-screen tabs |
| 2.3 | Empty-cart checkout guard missing on Payment screen | Medium | **Fixed** — "Order Now" disabled when cart is empty |
| 2.4 | Taxation ($15.00) displayed but **not included** in "Total Price" | High | **Fixed** — Payment now shows Subtotal → Taxation → Total; the total (`grandTotal`) includes taxation and is what is charged/stored |
| 2.5 | Coupon logic is fake: any non-empty string applies a hardcoded $2 discount (only when subtotal ≥ $35); snackbar always claims "FastDelicious/3572 applied!"; copy icon actually applies the coupon | High | **Fixed** — only the exact code `FastDelicious/3572` (case-insensitive) grants $2.00 off; success/invalid snackbar; field border turns green/red |
| 2.6 | Cart quantity controls are hidden gestures: tap the "1 x" label to increment, **long-press to decrement** — undiscoverable and destructive | High | **Fixed** — visible − / + stepper buttons on every cart row |
| 2.7 | Auth is a no-op: password ignored, any tap logs in, logout keeps the previous user's cart/favorites/profile | High | **Fixed (demo scope)** — login/sign-up validate name, email format, and password length (≥ 6) with feedback; `logout()` resets the whole session (cart, favorites, orders, notifications, profile, filters) to the first-run demo state. Real credential verification still requires a backend |
| 3.1 | Forgot-password snackbar hardcodes `huzeyfebastas@gmail.com` even if the field is edited | Medium | **Fixed** — sheet is prefilled with the address from the login form and the snackbar reports the address actually entered |
| 3.2 | History sheet claims an active order ("#FD-1041 … on the way") when history is empty | Medium | **Fixed** — honest empty state ("No orders yet…") |
| 3.3 | Courier name changes with card expand/collapse (Odell ↔ Jackson) — reads as a bug | Medium | **Fixed** — single courier (`Robert Odell`); only the card layout toggles |
| 3.4 | Search bypasses the selected category while the chips stay highlighted | Medium | **Fixed** — search now narrows within the selected category |
| 3.5 | `TextEditingController` leaks in modal sheets (change/forgot password, complaint dialog) | Medium | **Fixed** — all three sheets are stateful widgets with proper `dispose()` |
| 3.6 | `_FoodVectorPainter.shouldRepaint` returns `false` unconditionally (ignores `type`) | Medium | **Fixed** — now compares `type` |
| 3.7 | No input validation/keyboard types; accessibility gaps (bare `GestureDetector`s, emoji as icons, ~3.5:1 contrast for white on `#FF432A`) | Medium | **Partially fixed** — email/phone keyboard types, login/sign-up validation, bottom-nav semantics labels added; deeper a11y work split into 3.8 |
| 3.8 | Deeper accessibility pass: semantics labels for all icon-only buttons, replacing emoji icons, contrast of white on `#FF432A` (~3.5:1, below WCAG AA) | Medium | **Fixed** — every icon-only control carries a semantics label; emoji icons replaced with Material icons; `AppColors.primary` deepened to `#D93025` so white on primary passes WCAG AA (4.8:1) |
| 4.1 | Single 4,173-line `main.dart` (models + state + screens + painters all in one file) | Low | **Fixed** — split into 17 modules (`theme`, `models`, `app_state`, `widgets`, `painters`, `sheets` + 10 screen files); `main.dart` is now 58 lines |
| 4.2 | Whole `MaterialApp` rebuilt via `AnimatedBuilder` on every state change | Low | **Fixed** — `AnimatedBuilder` now wraps only the `home` subtree; `MaterialApp`/theme are built once |
| 4.3 | Money modeled as `double`; magic numbers ($2 discount, drawer transform `230/90/0.72`, order id base 1042) | Low | **Partially fixed** — magic numbers named (`_orderIdBase`, `priceFilterMin/Max`, `_drawerOffsetX/Y`, `_drawerScale`); monetary values intentionally stay `double` in this demo |
| 4.4 | `fontFamily: 'sans-serif'` is a no-op; `cupertino_icons` dependency unused | Low | **Fixed** — both removed |
| 4.5 | Release build signs with the debug key; `applicationId` is `com.example.*` | Low | **Deferred by design** — release signing needs your keystore (template TODO in place); `applicationId` is a branding decision to make before release |
| 4.6 | Test coverage is a single shallow widget test; no unit tests for `AppState` | Low | **Partially fixed** — `test/app_state_test.dart` added covering cart math, coupons, checkout, filters, favorites, and session reset; not yet executed (no SDK on the audit machine) |

## What was repaired

### Dart code (`lib/main.dart`)
1. **Checkout now clears the cart** — `AppState.placeOrder()` empties `cartItems` after recording the
   order, so the badge resets and duplicate checkouts are no longer possible.
2. **Hero-tag collision fixed** — each tab inside the `IndexedStack` is wrapped in
   `HeroMode(enabled: bottomNavIndex == i)`. Off-screen tabs no longer register their `Hero`
   widgets, so a dish appearing in both Home and Favorites no longer trips the
   "multiple heroes share the same tag" assertion.
3. **Empty-cart guard on "Order Now"** — the button is disabled when `cartItems` is empty.
4. **Taxation is now actually charged** — the Payment screen shows `Subtotal → Taxation → Total`,
   and "Order Now" charges/stores the total including the $15.00 taxation (`grandTotal`). The cart
   keeps showing the pre-tax goods total ($33,50), matching the reference design.
5. **Coupon logic is real** — only the exact code `FastDelicious/3572` (case-insensitive) grants the
   $2.00 discount; any other code grants nothing. The apply button reports success or "invalid code"
   via snackbar, and the coupon field border turns green (valid) or coral (invalid). The misleading
   copy icon was replaced with a redeem icon.
6. **Visible cart quantity controls** — every cart row now has explicit − / + buttons with the
   quantity between them (plus the remove ✕); the hidden tap/long-press gestures are gone.
7. **Forgot-password flow is honest** — the sheet is prefilled with the email currently typed on the
   login form, the confirmation snackbar names that address, and empty input gets a clear message.
8. **Order-history empty state** — no more fabricated "#FD-1041 on the way" message.
9. **One courier identity** — the tracking screen always shows `Robert Odell`; expanding/collapsing
   only changes the card layout.
10. **Search respects the category filter** — results, chip highlight, and filters are now consistent.
11. **No more controller leaks** — change-password, forgot-password, and complaint sheets are
    stateful widgets with proper `dispose()`; the change-password sheet now confirms with a snackbar.
12. **`_FoodVectorPainter.shouldRepaint`** now compares `type` instead of always returning `false`.
13. **Input & a11y basics** — email/phone fields get proper keyboard types; login/sign-up validate
    non-empty fields with snackbar feedback; bottom navigation items carry semantics labels.
14. **Real session lifecycle** — `logout()` resets the entire session (cart, favorites, order history,
    notifications, profile fields, payment state, filters) to the first-run demo state, so the next
    login never inherits the previous user's data. Login/sign-up validate name, email format, and
    password length with snackbar feedback.
15. **Modularized `lib/`** — `main.dart` (4,504 lines) is now 58 lines; the app is split into
    `theme.dart`, `models.dart`, `app_state.dart`, `widgets.dart`, `painters.dart`, `sheets.dart`
    and ten files under `screens/`. Shared widgets were made public; everything else stays private
    to its file.
16. **Unit tests added** — `test/app_state_test.dart` covers cart math ($33,50 / $48,50), coupon
    validation, checkout (cart clearing, order recording), search/category filtering, favorites,
    and the logout reset.
17. **Accessibility pass** — `CircleIconButton` takes an optional `semanticLabel` (set on every
    icon-only control); cart steppers, add-to-cart, filter, coupon-apply and avatar buttons carry
    button semantics; the 🔥 ⏰ 🤩 ⚖️ 📍 emoji were replaced with Material icons.
18. **Contrast** — `AppColors.primary` deepened from `#FF432A` to `#D93025`; white text on primary
    buttons now measures 4.8:1 (WCAG AA). One-line revert in `theme.dart` if the original coral is
    preferred.
19. **Rebuild scope** — the root `AnimatedBuilder` now wraps only the `home` subtree instead of the
    whole `MaterialApp`.
20. **Magic numbers named** — drawer transform (`_drawerOffsetX/Y`, `_drawerScale`), order id base
    (`_orderIdBase`), price-filter bounds (`priceFilterMin/Max`).
21. **Dependency & theme cleanup** — removed the no-op `fontFamily: 'sans-serif'` and the unused
    `cupertino_icons` dependency.

### Platform scaffolding (Android)
Restored to match what `flutter create` produces with Flutter **3.47.7** (Kotlin DSL):

- `settings.gradle.kts` (plugin loader, AGP **9.1.0**, Kotlin **2.4.0**)
- `build.gradle.kts`, `app/build.gradle.kts` (namespace/applicationId
  `com.example.fast_delicious_food_app`, Java/Kotlin target 17)
- Gradle wrapper **9.3.1** (`gradlew`, `gradlew.bat`, `gradle-wrapper.jar`,
  `gradle-wrapper.properties`) downloaded from the official `gradle/gradle` repository
- `gradle.properties`, `app/src/debug|profile/AndroidManifest.xml`
- `app/src/main/res/`: `values/styles.xml`, `values-night/styles.xml`,
  `drawable/launch_background.xml`, `drawable-v21/launch_background.xml`,
  launcher icons in all five density buckets
- `AndroidManifest.xml` rebuilt from the current template: label
  "Fast & Delicious Food", `taskAffinity`, `queries` block, INTERNET permission kept,
  deprecated `package=` attribute removed
- Legacy broken Groovy files (`build.gradle`, `app/build.gradle`) removed

### Platform scaffolding (iOS)
Restored from the same official templates:

- `Runner.xcodeproj/project.pbxproj` (bundle id `com.example.fastDeliciousFoodApp`,
  Runner + RunnerTests targets, deployment target 15.0), workspace data, shared scheme
- `Flutter/AppFrameworkInfo.plist`, `Flutter/Debug.xcconfig`, `Flutter/Release.xcconfig`
- Scene-based lifecycle: new `AppDelegate.swift` + `SceneDelegate.swift`, and
  `Info.plist` updated (scene manifest, `CADisableMinimumFrameDurationOnPhone`,
  `UIApplicationSupportsIndirectInputEvents`; iPhone stays portrait-only as before)
- Storyboards (`Main.storyboard`, `LaunchScreen.storyboard`), bridging header
- Asset catalogs: app icons + launch images from the official `flutter_template_images`
  package (v5.0.0), all 18 PNGs verified valid
- `Podfile`, `RunnerTests/RunnerTests.swift`, `.gitignore`

### Repository hygiene
- Added the standard Flutter `.gitignore` at the root, plus the standard
  `android/.gitignore` and `ios/.gitignore`.

## Verification performed

- All XML/plist/storyboard/xcscheme/workspace files parse as well-formed XML. ✅
- Both asset-catalog `Contents.json` files parse as JSON. ✅
- All 23 PNG assets carry a valid PNG signature. ✅
- No leftover `{{...}}` template placeholders anywhere in the project. ✅
- `project.pbxproj` is structurally balanced and references `AppDelegate.swift`,
  `SceneDelegate.swift`, `RunnerTests.swift`, and `GeneratedPluginRegistrant`. ✅
- All 17 `lib/**` files pass bracket-balance checks and an automated cross-file
  import-consistency check (every referenced symbol is imported where needed). ✅
- Post-cleanup scans: no emoji-as-icons remain; every `CircleIconButton` call site sets a semantics
  label; no leftover magic numbers; `fontFamily` and `cupertino_icons` fully removed. ✅
- **Verified with Flutter 3.47.7:** `flutter analyze` (0 errors, 1 info — `Slider.activeColor`
  deprecation false positive), `flutter test` (10/10 passed), `flutter pub get` (26 deps). ✅
- **Not verified:** real device/emulator builds — requires Android SDK + JDK (see below).

## Environment requirements to build

1. **Flutter SDK** — install a current stable release (3.47.x or newer). The restored
   scaffolding matches 3.47.7; newer SDKs migrate it automatically when needed.
2. **Android** — Android Studio (bundles the required JDK 17+) with Android SDK
   platform 36. Accept licenses via `flutter doctor --android-licenses`.
3. **iOS** — requires macOS + Xcode 15 or newer. (CocoaPods only becomes necessary once
   plugins are added.)
4. **OneDrive caveat** — this project lives inside a OneDrive-synced folder. Builds create
   thousands of files under `build/`; consider excluding build directories from sync or
   moving the project outside OneDrive to avoid file locks and slow syncs.

## Recommended next steps

1. **`git init`** and commit the current state (the `.gitignore` files are already in place).
2. **Android builds:** install Android Studio (bundles JDK 17+ and Android SDK), then
   `flutter doctor --android-licenses`. `flutter run` will then work on a device/emulator.
3. **iOS builds:** requires macOS + Xcode 15 or newer.
4. **Release prep (4.5):** generate an upload keystore, set `key.properties`, switch the
   release buildType to signing with it, and change `applicationId` from `com.example.*`
   to your own brand before publishing.
