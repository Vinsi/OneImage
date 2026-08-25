# Active Context: OneImage

## Current focus
The working tree contains the **generic renderer redesign** (in progress, uncommitted): `ImageView` is now `ImageView<Loading, Failure, Renderer>` where `RemoteImageRenderer` has an `associatedtype RemoteView: View`. This removes all `AnyView`/existential usage — the SDK's concrete view type (KFImage, WebImage, LazyImage, `AsyncRemoteImage`) flows through the tree. Trade-off chosen deliberately: renderer is fixed at init (default pinned to `AsyncImageRenderer`); runtime environment injection was removed.

- `RemoteImageRenderer.swift` — protocol with `associatedtype RemoteView` + generic `makeRemoteImage`, no env key.
- `AsyncImageRenderer.swift` — default; `RemoteView = AsyncRemoteImage` (erases placeholders to `AnyView` internally to keep a fixed type).
- `ImageView.swift` — `Renderer` generic param, stored on the struct; default init pins `Renderer == AsyncImageRenderer`.
- Removed: `\.remoteImageRenderer` environment key, `.remoteImageRenderer(_:)` modifier, `remoteImageRenderer` config field.
- Placeholder modifiers now return `ImageView<NewLoading, NewFailure, Renderer>` (renderer threaded through).
- Tests updated: renderer invoked synchronously (no async), default pins AsyncImageRenderer, renderer survives placeholder replacement.

## Open questions / decisions pending
1. **`cornerRadius` dead code** — `setCornerRadius` populates `ImageConfiguration.cornerRadius` but nothing applies it in the view body. Decide: apply it (e.g. `.clipShape(RoundedRectangle(...))` or `.cornerRadius`), or remove the modifier/config field.
2. **`Core` ↔ `DeveloperToolsSupport` coupling** — `ImageReference.LocalSource.resource(ImageResource)` requires importing `DeveloperToolsSupport` in `Core` (`ImageReference.swift:8`), which weakens Core's platform-independence. Options: accept it, extract `ImageResource` handling, or gate the `resource` case.
3. **Generic API ergonomics** — `ImageView<Loading, Failure, Renderer>` is verbose when named explicitly; consider a `typealias`/helper for the common `AsyncImageRenderer` case. Custom renderers still mirror new `ImageStyle` fields.
4. **Release** — README references `from: "1.0.0"` but no tag/version exists yet.

## What changed since the last session
- Replaced the `any View` + `AnyView` renderer contract with the generic `<Loading, Failure, Renderer>` design (per decision: renderer must return arbitrary SDK views, and AnyView/erasure was rejected).
- Earlier in this session: Kingfisher decoupling (renderer injection), repo rename to OneImage, CI, per-view override (that mechanism was superseded by the generic design).

## Next steps (suggested)
1. Commit the generic renderer redesign.
2. Resolve the `cornerRadius` no-op (apply or remove).
3. Decide on the `DeveloperToolsSupport` coupling in `Core`.
4. Tag a `1.0.0` release.
5. Re-generate this file's "What changed" section after any of the above lands.
