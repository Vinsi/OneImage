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
│  View (SwiftUI, no third-party deps)                      │
│    ImageView<Loading, Failure, Renderer>                  │
│    ImageConfiguration (config bag)                        │
│    RemoteImageRenderer protocol (associated RemoteView)   │
│    AsyncImageRenderer / AsyncRemoteImage (default)        │
│    ImageStyle, ImagePlaceholder                           │
└──────────────────────┬───────────────────────────────────┘
                       │ depends on Core
┌──────────────────────▼───────────────────────────────────┐
│  Core (no SwiftUI)                                       │
│    ImageReference enum                                   │
└──────────────────────────────────────────────────────────┘
```

Dependency direction is strictly downward: `Core` <- `View` <- `OneImageSampleUI` <- `OneImageSample`. Tests: `CoreTests` (on `Core`), `ViewUITests` (on `View`).

## Key patterns

### 1. Value-type image description (`Core`)
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
`RemoteImageRenderer` is a `Sendable` protocol with an `associatedtype RemoteView: View` and a `@MainActor` generic method. `ImageView<Loading, Failure, Renderer>` stores a concrete `Renderer`; the default init pins `Renderer == AsyncImageRenderer` (SwiftUI `AsyncImage`), and a custom renderer (Kingfisher, Nuke, SDWebImage) is passed at init: `ImageView(ref, renderer: KingfisherRenderer())`. The renderer is preserved through placeholder/style modifiers. This is why `View` has **no third-party dependency** and **no type erasure**.

### 5. Type-state placeholder design
`ImageView<Loading: View, Failure: View, Renderer>` encodes placeholder presence in the generic parameters. `.placeholderLoading { }` returns `ImageView<NewLoading, Failure, Renderer>`; `.placeholderFailure { }` returns `ImageView<Loading, NewFailure, Renderer>` (see `ImageView+Placeholder.swift`). State transitions happen at compile time. Plain inits exist only when `Loading == EmptyView, Failure == EmptyView` (`ImageView.swift`).

### 6. Value-type configuration + builder `with(_:)`
All modifiers in `ImageView+Modifiers.swift` mutate a copy of `ImageConfiguration` via `with(_:)` and return a new `ImageView`. `ImageConfiguration` is a `@MainActor` struct (`ImageConfiguration.swift:12`) holding the reference, placeholders, `cornerRadius`, and `ImageStyle` (the renderer lives on `ImageView`, not the config).

### 7. Placeholder wrapper
`ImagePlaceholder<Content>` (`ImagePlaceholder.swift`) is a thin wrapper with convenience inits: `.none` (EmptyView), from a `LocalSource` image, or a `@ViewBuilder` closure. It is passed (still typed) into the renderer, which wires it to its own loading/failure hooks. The default `AsyncRemoteImage` erases placeholders to `AnyView` internally (its type must stay fixed to satisfy `RemoteView`).

## Notable observations / risks
- `cornerRadius` is stored in `ImageConfiguration` (`setCornerRadius`) but **not applied anywhere in `ImageView.body`** — currently a no-op configuration (only asserted in tests).
- `Core` imports `DeveloperToolsSupport` to reference `ImageResource` (`ImageReference.swift:8`), which couples the "platform-independent" core to a non-Apple-platform-support framework. Candidate to revisit.
- `ImageReference+SwiftUI.swift` maps `LocalSource` → `Image` inside the `View` module — the SwiftUI mapping is deliberately kept out of `Core`.
- `ImageView+Placeholder.swift` `replacing` preserves `style` and `cornerRadius` (this preservation was missing before the refactor — a latent config-dropping bug, now fixed).
