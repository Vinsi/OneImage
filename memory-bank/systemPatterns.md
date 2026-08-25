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
│  View (SwiftUI + Kingfisher)                             │
│    ImageView<Loading, Failure>                           │
│    ImageConfiguration (config bag)                       │
│    RenderConfigurable protocol                           │
│    Image / KFImage conformances                          │
│    ImagePlaceholder                                      │
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
- `.remote(.url)` → `remoteImageRenderer.makeRemoteImage(url:loading:failure:style:)`
- `.remote(.urlString)` → parse to `URL`, else failure placeholder
- `.local` → plain SwiftUI `Image` with `.applying(style)`

The remote result is type-erased to `AnyView` at the boundary (`any View` can't be returned as `some View`).

### 3. `ImageStyle` value type (replaces the old `RenderConfigurable` protocol)
Styling (resizable/renderingMode/interpolation/antialiased) is a plain value (`ImageStyle`), applied by `Image.applying(_:)` (`Image+Style.swift`). Adding a new modifier = 1 field in `ImageStyle` + 1 case in `Image.applying` + 1 public modifier on `ImageView`. Local images and the default renderer pick it up automatically; a custom renderer owning a foreign view type (e.g. `KFImage`) mirrors the field once.

### 4. Injectable remote rendering (`RemoteImageRenderer.swift`)
`RemoteImageRenderer` is a `Sendable` protocol with a `@MainActor` generic method returning `any View`. It is injected either via the environment (`\.remoteImageRenderer`, default `AsyncImageRenderer`) or per-view via `.remoteImageRenderer(_:)` (stored in `ImageConfiguration`, takes precedence over the environment). This is why `View` has **no third-party dependency** — Kingfisher (or Nuke, etc.) is provided from outside.

### 5. Type-state placeholder design
`ImageView<Loading: View, Failure: View>` encodes placeholder presence in the generic parameters. `.placeholderLoading { }` returns `ImageView<NewLoading, Failure>`; `.placeholderFailure { }` returns `ImageView<Loading, NewFailure>` (see `ImageView+Placeholder.swift`). State transitions happen at compile time. A plain init exists only when `Loading == EmptyView, Failure == EmptyView` (`ImageView.swift:85`).

### 6. Value-type configuration + builder `with(_:)`
All modifiers in `ImageView+Modifiers.swift` mutate a copy of `ImageConfiguration` via `with(_:)` and return a new `ImageView`. `ImageConfiguration` is a `@MainActor` struct (`ImageConfiguration.swift:12`) holding the reference, placeholders, `cornerRadius`, and `ImageStyle`.

### 7. Placeholder wrapper
`ImagePlaceholder<Content>` (`ImagePlaceholder.swift`) is a thin wrapper with convenience inits: `.none` (EmptyView), from a `LocalSource` image, or a `@ViewBuilder` closure. It is passed (still typed) into the renderer, which wires it to its own loading/failure hooks.

## Notable observations / risks
- `cornerRadius` is stored in `ImageConfiguration` (`setCornerRadius`) but **not applied anywhere in `ImageView.body`** — currently a no-op configuration (only asserted in tests).
- `Core` imports `DeveloperToolsSupport` to reference `ImageResource` (`ImageReference.swift:8`), which couples the "platform-independent" core to a non-Apple-platform-support framework. Candidate to revisit.
- `ImageReference+SwiftUI.swift` maps `LocalSource` → `Image` inside the `View` module — the SwiftUI mapping is deliberately kept out of `Core`.
- `ImageView+Placeholder.swift` `replacing` preserves `style` and `cornerRadius` (this preservation was missing before the refactor — a latent config-dropping bug, now fixed).
