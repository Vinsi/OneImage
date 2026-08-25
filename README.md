<div align="center">

# OneImage

### One API for every image — local or remote.

A dependency-free SwiftUI image library that lets you describe *any* image with a single value and render it with consistent placeholders, failure handling, and styling — no matter where it comes from.

[![Swift](https://img.shields.io/badge/Swift-6.1-FA7343?logo=swift&logoColor=white)](https://swift.org)
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
| **Platform-independent core** | The `OneImageCore` module carries no SwiftUI dependency |

## Installation

Add it via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/Vinsi/OneImage.git", from: "1.0.0")
]
```

Then add the products you need:

```swift
.product(name: "OneImageCore", package: "OneImage"),
.product(name: "OneImageView", package: "OneImage"),
```

| Product | Description |
| --- | --- |
| `OneImageCore` | Platform-independent image reference model |
| `OneImageView` | SwiftUI `ImageView` with placeholders, styling, and renderer injection |
| `OneImageSampleUI` / `OneImageSample` | Sample app with canvas previews |

## Quick Start

```swift
import OneImageView

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

## Remote rendering — plug in any SDK

The library (`OneImageCore`/`OneImageView`) has **no third-party dependencies** and **zero type erasure** — no `AnyView`, no existential anywhere. `ImageView` is generic over a `RemoteImageRenderer`, so whatever your SDK produces (KFImage, WebImage, LazyImage) flows through the tree with its concrete type intact. (The sample app adds Kingfisher to demonstrate the injection — see `Sources/OneImageSampleUI/KingfisherRenderer.swift`.)

Without a renderer, `ImageView` uses a built-in remote view (`AsyncRemoteImage<Loading, Failure>`, backed by SwiftUI's `AsyncImage`) that keeps your typed placeholders and style:

```swift
ImageView(.remote(.urlString("https://picsum.photos/200")))
    .placeholderLoading { ProgressView() }
    .placeholderFailure { Image(systemName: "exclamationmark.triangle") }
```

Want Kingfisher instead? A ~10-line conformance, passed at init:

```swift
import Kingfisher

struct KingfisherRenderer: RemoteImageRenderer {
    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> KFImage {
        KFImage(url)
            .placeholder { loading }
            .onFailureView { failure }
            .fade(duration: 0.25)
            .cacheOriginalImage(true)
            .cancelOnDisappear(true)
    }
}

ImageView(.remote(.urlString("https://example.com/hero.png")), renderer: KingfisherRenderer())
```

Each renderer gets the typed placeholders and the applied `ImageStyle` so it can forward `.resizable()`, `.renderingMode()`, etc. to its own view type. For loaders that expose an inner `Image` (like `AsyncImage`), use `image.applying(style)`.

Because `RemoteView` is a generic parameter, you can mix renderers freely — a Kingfisher image here, a Nuke image there — each with its concrete type preserved.

## Under the hood

- **`ImageStyle`** — styling is a plain value type (`resizable`, `renderingMode`, `interpolation`, `antialiased`), applied by `Image.applying(_:)`. Adding a new modifier touches three small places and is picked up automatically by local images and the default remote view.
- **Type-state placeholders** — `.placeholderLoading {}` changes the generic type of `ImageView`, so placeholder presence is a compile-time guarantee, not a runtime convention.
- **`ImageView<Loading, Failure, Renderer>`** — the renderer is a generic parameter whose `RemoteView` is a concrete type; `AsyncRemoteImage<Loading, Failure>` handles the built-in default with typed placeholders. No `AnyView`, no existential.
- **`OneImageCore` vs `OneImageView`** — the model is deliberately kept free of SwiftUI so it can be reused and tested independently.

## Sample app

Two ways to see it in action:

```sh
swift run OneImageSample      # macOS executable sample
```

Or open the full iOS demo project — a ready-to-run app with its own asset catalog, built-in remote loading, and a Kingfisher renderer:

```sh
open Examples/OneImageDemo/OneImageDemo.xcodeproj
```

For live previews, open the package in Xcode, select the `OneImageSampleUI` scheme, and open `Previews.swift` or `ContentView.swift` in the canvas.

## Requirements

- Swift 6.1+
- iOS 17+ / macOS 14+

## License

OneImage is available under the MIT license. See [LICENSE](LICENSE).
