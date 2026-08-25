# Tech Context: OneImage

## Stack
- **Language**: Swift 6.1 (`swift-tools-version: 6.1` in `Package.swift`) — set to 6.1 so the GitHub Actions `macos-15` runner (Swift 6.1.0) can build it
- **Platforms**: iOS 17+, macOS 14+
- **Package manager**: Swift Package Manager
- **Dependencies (library)**: none (remote rendering is pluggable; default uses SwiftUI `AsyncImage`)
- **Dependencies (sample only)**: `Kingfisher` >= 8.0.0 — wired into `OneImageSampleUI` to demonstrate a real third-party renderer (`KingfisherRenderer`); the `OneImageCore`/`OneImageView` library products stay dependency-free
- **Formatting**: `.swift-format` config present at package root
- **License**: MIT

## Products (Package.swift)
| Product | Type | Targets |
| --- | --- | --- |
| `OneImageCore` | library | `OneImageCore` (no deps) |
| `OneImageView` | library | `OneImageView` (depends on `OneImageCore`) |
| `OneImageSampleUI` | library | `OneImageSampleUI` (depends on `OneImageView`, `Kingfisher`) |
| `OneImageSample` | executable | `OneImageSample` (depends on `OneImageSampleUI`; embeds `Info.plist` via linker sectcreate flags) |

## Source layout
- `Sources/Core/ImageReference.swift` — model enum
- `Sources/View/` — `ImageView.swift`, `ImageConfiguration.swift`, `ImageStyle.swift`, `Image+Style.swift`, `RemoteImageRenderer.swift`, `AsyncRemoteImage.swift`, `ImagePlaceholder.swift`, `ImageReference+SwiftUI.swift`, `ImageView+Modifiers.swift`, `ImageView+Placeholder.swift`
- `Sources/OneImageSampleUI/` — `ContentView.swift`, `Previews.swift`
- `Sources/OneImageSample/` — `OneImageSampleApp.swift`, `Info.plist`

## Tests
- Framework: **Swift Testing** (`import Testing`), not XCTest
- `Tests/OneImageCoreTests/CoreTests.swift` — 2 tests (asset bundle default, remote equality)
- `Tests/OneImageViewUITests/ImageViewRenderingTests.swift` — 13 tests: render assertions use SwiftUI `ImageRenderer` (local render, resizable sizing, invalid-URL failure fallback, config/style mutation, placeholder/style preservation, default renderer pinned to `DefaultImageRenderer` marker, fake renderer invoked with url/style, renderer survives placeholder replacement, built-in `AsyncRemoteImage` smoke test)
- Tests are `@MainActor` where they touch SwiftUI.

## Commands
```sh
swift build                 # build all targets
swift test                  # run OneImageCoreTests + OneImageViewUITests
swift run OneImageSample     # run the sample app
```
Previews: open package in Xcode, scheme `OneImageSampleUI`, open `ContentView.swift` or `Previews.swift` in canvas.

## CI (GitHub Actions)
`.github/workflows/ci.yml` runs on push/PR to `main`:
- `macos-15` job: `swift format lint --recursive Sources Tests`, `swift build`, `swift test`
- `macos-15` job: `xcodebuild build -scheme OneImage-Package -destination 'generic/platform=iOS Simulator'` (validates iOS compilation)
- `macos-15` job: builds `Examples/OneImageDemo` (`xcodebuild -project ... -scheme OneImageDemo`), the committed XcodeGen project

## Example app
`Examples/OneImageDemo/` is a full iOS app generated with XcodeGen (`project.yml`), referencing the OneImage package by local path (`../..`) plus Kingfisher. It demonstrates local assets from its own catalog, SF Symbols, the built-in `AsyncRemoteImage`, and a local `KingfisherRenderer`. The `.xcodeproj` is committed so it opens directly; regenerate with `xcodegen generate`.

## Git state (at last memory-bank update)
- Remote: `https://github.com/Vinsi/OneImage.git` (`origin`)
- Branch: `main` (tracks `origin/main`)
- Latest commit: `4022a59` "Initial release: OneImage SwiftUI image library"
- Uncommitted: CI tools-version fix (6.2 → 6.1) and Kingfisher wired into the sample target (working tree)
