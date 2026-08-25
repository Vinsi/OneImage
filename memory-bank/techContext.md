# Tech Context: ImageIO

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
| `ImageIOSampleUI` | library | `ImageIOSampleUI` (depends on `View`) |
| `ImageIOSample` | executable | `ImageIOSample` (depends on `ImageIOSampleUI`; embeds `Info.plist` via linker sectcreate flags) |

## Source layout
- `Sources/Core/ImageReference.swift` — model enum
- `Sources/View/` — `ImageView.swift`, `ImageConfiguration.swift`, `ImageStyle.swift`, `Image+Style.swift`, `RemoteImageRenderer.swift`, `AsyncImageRenderer.swift`, `ImagePlaceholder.swift`, `ImageReference+SwiftUI.swift`, `ImageView+Modifiers.swift`, `ImageView+Placeholder.swift`
- `Sources/ImageIOSampleUI/` — `ContentView.swift`, `Previews.swift`
- `Sources/ImageIOSample/` — `ImageIOSampleApp.swift`, `Info.plist`

## Tests
- Framework: **Swift Testing** (`import Testing`), not XCTest
- `Tests/CoreTests/CoreTests.swift` — 2 tests (asset bundle default, remote equality)
- `Tests/ViewUITests/ImageViewRenderingTests.swift` — 12 tests: render assertions use SwiftUI `ImageRenderer` (local render, resizable sizing, invalid-URL failure fallback, config/style mutation, placeholder/style preservation, default renderer is `AsyncImageRenderer`, injected renderer receives url/style, `AsyncImageRenderer` smoke test)
- Tests are `@MainActor` where they touch SwiftUI.

## Commands
```sh
swift build                 # build all targets
swift test                  # run CoreTests + ViewUITests
swift run ImageIOSample     # run the sample app
```
Previews: open package in Xcode, scheme `ImageIOSampleUI`, open `ContentView.swift` or `Previews.swift` in canvas.

## Git state (at last memory-bank update)
- Remote: `https://github.com/Vinsi/ImageIO.git` (`origin`)
- Branch: `main` (tracks `origin/main`)
- Latest commit: `4022a59` "Initial release: ImageIO SwiftUI image library"
- Uncommitted: the Kingfisher-decoupling refactor (renderer injection) in the working tree
