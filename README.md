# ImageIO

A SwiftUI image loading library for local and remote images, built as a Swift Package.

## Requirements

- Swift 6.2+
- iOS 17+ / macOS 14+

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Vinsi/ImageIO.git", from: "1.0.0")
]
```

Then add the products you need to your target:

```swift
.product(name: "Core", package: "ImageIO"),
.product(name: "View", package: "ImageIO"),
```

## Products

| Product | Description |
| --- | --- |
| `Core` | Platform-independent image reference model. |
| `View` | SwiftUI `ImageView` with loading/failure placeholders and modifiers. |
| `ImageIOSampleUI` | Sample app UI with previews (macOS canvas). |

## Usage

### Describing an image

`ImageReference` supports remote URLs and local sources:

```swift
ImageReference.remote(.url(URL(string: "https://example.com/a.png")!))
ImageReference.remote(.urlString("https://example.com/a.png"))
ImageReference.local(.system("star.fill"))
ImageReference.local(.asset("logo"))          // bundle defaults to .main
ImageReference.local(.asset("logo", bundle: .someBundle))
```

### Rendering

```swift
import View

ImageView(.local(.system("star.fill")))
    .resizable()
    .frame(width: 64, height: 64)

ImageView(.remote(.urlString("https://picsum.photos/200")))
    .placeholderLoading { ProgressView() }
    .placeholderFailure { Image(systemName: "exclamationmark.triangle") }
    .resizable()
    .frame(width: 200, height: 200)
```

### Modifiers

- `.resizable(capInsets:resizingMode:)`
- `.renderingMode(_:)`
- `.interpolation(_:)`
- `.antialiased(_:)`
- `.setCornerRadius(_:)`
- `.placeholderLoading { ... }` / `.placeholderFailure { ... }`

## Running the sample

```sh
swift run ImageIOSample
```

For previews: open the package in Xcode, select the `ImageIOSampleUI` scheme, and open `Previews.swift` or `ContentView.swift` in the canvas.

## License

ImageIO is available under the MIT license. See [LICENSE](LICENSE).
