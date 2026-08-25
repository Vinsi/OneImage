# Tech Context: OneImage

## Stack
- **Language**: Swift 6.2 (`swift-tools-version: 6.2` in `Package.swift`)
- **Platforms**: iOS 17+, macOS 14+
- **Package manager**: Swift Package Manager
- **Dependencies**: none (remote rendering is injectable; default uses SwiftUI `AsyncImage`)
- **Formatting**: `.swift-format` config present at package root
- **License**: MIT

## Products (Package.swift)
| Product | Type | Targets |
| --- | --- | --- |
| `Core` | library | `Core` |
| `View` | library | `View` (depends on `Core`) |
| `OneImageSampleUI` | library | `OneImageSampleUI` (depends on `View`) |
| `OneImageSample` | executable | `OneImageSample` (depends on `OneImageSampleUI`; embeds `Info.plist` via linker sectcreate flags) |

## Source layout
- `Sources/Core/ImageReference.swift` — model enum
- `Sources/View/` — `ImageView.swift`, `ImageConfiguration.swift`, `ImageStyle.swift`, `Image+Style.swift`, `RemoteImageRenderer.swift`, `AsyncImageRenderer.swift`, `ImagePlaceholder.swift`, `ImageReference+SwiftUI.swift`, `ImageView+Modifiers.swift`, `ImageView+Placeholder.swift`
- `Sources/OneImageSampleUI/` — `ContentView.swift`, `Previews.swift`
- `Sources/OneImageSample/` — `OneImageSampleApp.swift`, `Info.plist`

## Tests
- Framework: **Swift Testing** (`import Testing`), not XCTest
- `Tests/CoreTests/CoreTests.swift` — 2 tests (asset bundle default, remote equality)
- `Tests/ViewUITests/ImageViewRenderingTests.swift` — 13 tests: render assertions use SwiftUI `ImageRenderer` (local render, resizable sizing, invalid-URL failure fallback, config/style mutation, placeholder/style preservation, default renderer is `AsyncImageRenderer`, injected renderer receives url/style, per-view renderer overrides environment, `AsyncImageRenderer` smoke test)
- Tests are `@MainActor` where they touch SwiftUI.

## Commands
```sh
swift build                 # build all targets
swift test                  # run CoreTests + ViewUITests
swift run OneImageSample     # run the sample app
```
Previews: open package in Xcode, scheme `OneImageSampleUI`, open `ContentView.swift` or `Previews.swift` in canvas.

## CI (GitHub Actions)
`.github/workflows/ci.yml` runs on push/PR to `main`:
- `macos-15` job: `swift format lint --recursive Sources Tests`, `swift build`, `swift test`
- `macos-15` job: `xcodebuild build -scheme OneImage-Package -destination 'generic/platform=iOS Simulator'` (validates iOS compilation)

## Git state (at last memory-bank update)
- Remote: `https://github.com/Vinsi/OneImage.git` (`origin`)
- Branch: `main` (tracks `origin/main`)
- Latest commit: `4022a59` "Initial release: OneImage SwiftUI image library"
- Uncommitted: the Kingfisher-decoupling refactor (renderer injection) in the working tree
