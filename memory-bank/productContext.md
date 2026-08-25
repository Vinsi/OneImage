# Product Context: OneImage

## Why this exists
Consumers typically need to show images from several different sources — a local asset, an SF Symbol, a bundled resource, or a remote URL — and the SwiftUI API for each is different (`Image(name:), Image(systemName:), Image(resource:), and a network loader`). OneImage unifies all of these behind one `ImageReference` value and one `ImageView` renderer, so callers describe *what* they want and not *how* to load and configure it.

## Problem it solves
1. **Single mental model** — one enum describing any image source: `.remote(.url(...))`, `.local(.system(...))`, `.local(.asset(...))`, `.local(.resource(...))`.
2. **Consistent configuration** — `.resizable()`, `.renderingMode()`, `.interpolation()`, `.antialiased()` behave identically whether the underlying image is a SwiftUI `Image` or a network-loaded `KFImage`.
3. **First-class placeholder handling** — loading and failure placeholders are part of the type system, so states are explicit and cannot be forgotten at compile time.
4. **Platform-independent core** — the model (`OneImageCore`) carries no SwiftUI dependency, keeping the domain vocabulary reusable and testable.

## User experience (API surface)
```swift
ImageView(.local(.system("star.fill")))
    .resizable()
    .frame(width: 64, height: 64)

ImageView(.remote(.urlString("https://picsum.photos/200")))
    .placeholderLoading { ProgressView() }
    .placeholderFailure { Image(systemName: "exclamationmark.triangle") }
    .resizable()
    .frame(width: 200, height: 200)
```

## Sample app
`OneImageSample`/`OneImageSampleUI` demonstrate local and remote cases, including invalid-URL failure fallback. Previews in `OneImageSampleUI/Previews.swift` cover each modifier.
