# System Patterns: OneImage

## Module architecture

```
┌──────────────────────────────────────────────────────────┐
│  OneImageSample (executable)                              │
│    @main App -> ContentView                              │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│  OneImageSampleUI (sample app UI + previews)              │
│    ContentView.swift, Previews.swift                     │
└──────────────────────┬───────────────────────────────────┘
                       │ depends on View
┌──────────────────────▼───────────────────────────────────┐
│  OneImageView (SwiftUI, no third-party deps)                      │
│    ImageView<Loading, Failure, Renderer>                  │
│    ImageConfiguration (config bag)                        │
│    RemoteImageRenderer protocol (associated RemoteView)   │
│    AsyncRemoteImage<Loading, Failure> (built-in default)  │
│    ImageStyle, ImagePlaceholder                           │
└──────────────────────┬───────────────────────────────────┘
                       │ depends on Core
┌──────────────────────▼───────────────────────────────────┐
│  OneImageCore (no SwiftUI)                                       │
│    ImageReference enum                                   │
└──────────────────────────────────────────────────────────┘
```

Dependency direction is strictly downward: `OneImageCore` <- `OneImageView` <- `OneImageSampleUI` <- `OneImageSample`. Tests: `OneImageCoreTests` (on `OneImageCore`), `OneImageViewUITests` (on `OneImageView`).

## Key patterns

### 1. Value-type image description (`OneImageCore`)
`ImageReference` is a plain `enum` (`remote`/`local` with nested source enums), `Equatable`, `Hashable`, `Sendable`. It carries no rendering knowledge — it is the "what to show".

### 2. Dispatch + single render path (`ImageView.swift`)
`ImageView.body` switches on `ImageReference`:
- `.remote(.url)` → `renderer.makeRemoteImage(url:loading:failure:style:)`
- `.remote(.urlString)` → parse to `URL`, else failure placeholder
- `.local` → plain SwiftUI `Image` with `.applying(style)`

The remote view is the renderer's concrete `RemoteView` type — **no `AnyView`, no existential**. `ImageView<Loading, Failure, Renderer>` carries the renderer as a generic parameter, so the SDK's actual view type flows through the whole tree.

### 3. `ImageStyle` value type (replaces the old `RenderConfigurable` protocol)
Styling (resizable/renderingMode/interpolation/antialiased) is a plain value (`ImageStyle`), applied by `Image.applying(_:)` (`Image+Style.swift`). Adding a new modifier = 1 field in `ImageStyle` + 1 case in `Image.applying` + 1 public modifier on `ImageView`. Local images and the default renderer pick it up automatically; a custom renderer owning a foreign view type (e.g. `KFImage`) mirrors the field once.

### 4. Generic remote rendering (`RemoteImageRenderer.swift`)
`RemoteImageRenderer` is a `Sendable` protocol with an `associatedtype RemoteView: View` and a `@MainActor` generic method. `ImageView<Loading, Failure, Renderer>` stores a concrete `Renderer` (optional value); the default init pins `Renderer == DefaultImageRenderer` (a marker with `RemoteView == Never`, never called) and `ImageView.remote` builds the built-in `AsyncRemoteImage<Loading, Failure>` directly. A custom renderer (Kingfisher, Nuke, SDWebImage) is passed at init: `ImageView(ref, renderer: KingfisherRenderer())`. The renderer is preserved through placeholder/style modifiers. This is why `OneImageView` has **no third-party dependency** and **zero type erasure** — literally no `AnyView` and no `any View` existential anywhere.

### 5. Type-state placeholder design
`ImageView<Loading: View, Failure: View, Renderer>` encodes placeholder presence in the generic parameters. `.placeholderLoading { }` returns `ImageView<NewLoading, Failure, Renderer>`; `.placeholderFailure { }` returns `ImageView<Loading, NewFailure, Renderer>` (see `ImageView+Placeholder.swift`). State transitions happen at compile time. Plain inits exist only when `Loading == EmptyView, Failure == EmptyView` (`ImageView.swift`).

### 6. Value-type configuration + builder `with(_:)`
All modifiers in `ImageView+Modifiers.swift` mutate a copy of `ImageConfiguration` via `with(_:)` and return a new `ImageView`. `ImageConfiguration` is a `@MainActor` struct (`ImageConfiguration.swift:12`) holding the reference, placeholders, `cornerRadius`, and `ImageStyle` (the renderer lives on `ImageView`, not the config).

### 7. Placeholder wrapper
`ImagePlaceholder<Content>` (`ImagePlaceholder.swift`) is a thin wrapper with convenience inits: `.none` (EmptyView), from a `LocalSource` image, or a `@ViewBuilder` closure. It is passed (still typed) into the renderer, which wires it to its own loading/failure hooks; the built-in `AsyncRemoteImage<Loading, Failure>` stores them typed (its type legitimately depends on the placeholder generics, so no erasure is needed).

## Notable observations / risks
- `cornerRadius` is stored in `ImageConfiguration` (`setCornerRadius`) but **not applied anywhere in `ImageView.body`** — currently a no-op configuration (only asserted in tests).
- `OneImageCore` imports `DeveloperToolsSupport` to reference `ImageResource` (`ImageReference.swift:8`), which couples the "platform-independent" core to a non-Apple-platform-support framework. Candidate to revisit.
- `ImageReference+SwiftUI.swift` maps `LocalSource` → `Image` inside the `OneImageView` module — the SwiftUI mapping is deliberately kept out of `OneImageCore`.
- `ImageView+Placeholder.swift` `replacing` preserves `style` and `cornerRadius` (this preservation was missing before the refactor — a latent config-dropping bug, now fixed).
