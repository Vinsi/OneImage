<div align="center">

# OneImage

### One API for every image — local or remote.

A dependency-free SwiftUI image library that lets you describe *any* image with a single value and render it with consistent placeholders, failure handling, and styling — no matter where it comes from.

[![Swift](https://img.shields.io/badge/Swift-6.2-FA7343?logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17+-000000?logo=apple&logoColor=white)]()
[![macOS](https://img.shields.io/badge/macOS-14+-000000?logo=apple&logoColor=white)]()
[![SPM](https://img.shields.io/badge/SPM-Compatible-CB3837?logo=swift&logoColor=white)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

</div>

---

## Why OneImage?

SwiftUI gives you one way to show local images, another for system symbols, and yet another for remote ones — and they all behave differently. OneImage unifies them into **one enum, one view, one set of modifiers**:

```swift
ImageView(.local(.system("star.fill")))                    // SF Symbol
ImageView(.local(.asset("logo")))                          // Asset catalog
ImageView(.remote(.urlString("https://picsum.photos/200")))// Remote URL
```

Swap a local asset for a remote URL (feature flag, A/B test, CDN migration) by changing **one word** — nothing else in your view changes.

## Features

| | |
| --- | --- |
| **Unified source model** | `ImageReference` describes local, system, asset, and remote images in one `Equatable`/`Hashable`/`Sendable` value |
| **Zero dependencies** | Remote loading is injectable; ships with a built-in `AsyncImage` renderer, no third-party code |
| **Plug your own loader** | Bring Kingfisher, Nuke, or anything else via the `RemoteImageRenderer` protocol |
| **First-class placeholders** | Loading and failure states are enforced at compile time through type-state generics |
| **Consistent styling** | `.resizable()`, `.renderingMode()`, `.interpolation()`, `.antialiased()` behave identically for local and remote |
| **Platform-independent core** | The `Core` module carries no SwiftUI dependency |

## Installation

Add it via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/Vinsi/OneImage.git", from: "1.0.0")
]
```

Then add the products you need:

```swift
.product(name: "Core", package: "OneImage"),
.product(name: "View", package: "OneImage"),
```

| Product | Description |
| --- | --- |
| `Core` | Platform-independent image reference model |
| `View` | SwiftUI `ImageView` with placeholders, styling, and renderer injection |
| `OneImageSampleUI` / `OneImageSample` | Sample app with canvas previews |

## Quick Start

```swift
import View

// Local — SF Symbol
ImageView(.local(.system("star.fill")))
    .resizable()
    .frame(width: 64, height: 64)

// Remote — with loading + failure states
ImageView(.remote(.urlString("https://picsum.photos/200")))
    .placeholderLoading { ProgressView() }
    .placeholderFailure { Image(systemName: "exclamationmark.triangle") }
    .resizable()
    .frame(width: 200, height: 200)
```

## Describing an image

`ImageReference` is the single value you pass around — it carries no rendering knowledge, only *what* to show:

```swift
ImageReference.remote(.url(URL(string: "https://example.com/a.png")!))
ImageReference.remote(.urlString("https://example.com/a.png"))
ImageReference.local(.system("star.fill"))
ImageReference.local(.asset("logo"))                     // bundle defaults to .main
ImageReference.local(.asset("logo", bundle: someBundle))
```

## Rendering

`ImageView` renders whichever source you give it. Remote images get an invalid-URL fallback to the failure placeholder automatically:

```swift
ImageView(.remote(.urlString("")))                       // -> failure placeholder
```

### Modifiers

- `.resizable(capInsets:resizingMode:)`
- `.renderingMode(_:)`
- `.interpolation(_:)`
- `.antialiased(_:)`
- `.setCornerRadius(_:)`
- `.placeholderLoading { ... }` / `.placeholderFailure { ... }`

## Remote rendering — inject your own loader

`View` has **no third-party dependencies**. Remote images are rendered by an injectable `RemoteImageRenderer`, which defaults to `AsyncImageRenderer` (SwiftUI's `AsyncImage`).

Want Kingfisher instead? It's a ~10-line conformance:

```swift
import Kingfisher

struct KingfisherRenderer: RemoteImageRenderer {
    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> any View {
        KFImage(url)
            .placeholder { loading }
            .onFailureView { failure }
            .fade(duration: 0.25)
            .cacheOriginalImage(true)
            .cancelOnDisappear(true)
    }
}

ContentView()
    .environment(\.remoteImageRenderer, KingfisherRenderer())
```

### Per-view override

Need a different renderer for one specific image? Override it directly on the `ImageView` — it takes precedence over the environment:

```swift
ImageView(.remote(.urlString("https://example.com/hero.png")))
    .remoteImageRenderer(MyLightweightRenderer())
```

The renderer receives the applied `ImageStyle` so it can forward `.resizable()`, `.renderingMode()`, etc. to its own view type. For loaders that expose an inner `Image` (like `AsyncImage`), just use `image.applying(style)`.

## Under the hood

- **`ImageStyle`** — styling is a plain value type (`resizable`, `renderingMode`, `interpolation`, `antialiased`), applied by `Image.applying(_:)`. Adding a new modifier touches three small places and is picked up automatically by local images and the default renderer.
- **Type-state placeholders** — `.placeholderLoading {}` changes the generic type of `ImageView`, so placeholder presence is a compile-time guarantee, not a runtime convention.
- **`Core` vs `View`** — the model is deliberately kept free of SwiftUI so it can be reused and tested independently.

## Sample app

```sh
swift run OneImageSample
```

For live previews, open the package in Xcode, select the `OneImageSampleUI` scheme, and open `Previews.swift` or `ContentView.swift` in the canvas.

## Requirements

- Swift 6.2+
- iOS 17+ / macOS 14+

## License

OneImage is available under the MIT license. See [LICENSE](LICENSE).
