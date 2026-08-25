# Active Context: OneImage

## Current focus
Working tree changes (uncommitted):
1. **CI fix** — GitHub `macos-15` runner ships Swift 6.1.0; `swift-tools-version` lowered 6.2 → 6.1 so the manifest resolves on CI (library targets still build on 6.1+; no 6.2-only features in use).
2. **Kingfisher in the sample** — `Kingfisher` (>= 8.0.0) added to the package manifest and wired into `OneImageSampleUI` only; `KingfisherRenderer` (a `RemoteImageRenderer` returning `KFImage`) demonstrated in `ContentView` "Kingfisher" section and a preview. `Core`/`View` stay dependency-free.

## Open questions / decisions pending
1. **`cornerRadius` dead code** — `setCornerRadius` populates `ImageConfiguration.cornerRadius` but nothing applies it in the view body. Decide: apply it (e.g. `.clipShape(RoundedRectangle(...))` or `.cornerRadius`), or remove the modifier/config field.
2. **`Core` ↔ `DeveloperToolsSupport` coupling** — `ImageReference.LocalSource.resource(ImageResource)` requires importing `DeveloperToolsSupport` in `Core` (`ImageReference.swift:8`), which weakens Core's platform-independence. Options: accept it, extract `ImageResource` handling, or gate the `resource` case.
3. **Generic API ergonomics** — `ImageView<Loading, Failure, Renderer>` is verbose when named explicitly; consider a `typealias`/helper for the common `AsyncImageRenderer` case. Custom renderers still mirror new `ImageStyle` fields.
4. **Release** — README references `from: "1.0.0"` but no tag/version exists yet.

## What changed since the last session
- Implemented the zero-type-erasure design: the built-in default is now generic `AsyncRemoteImage<Loading, Failure>` built directly by `ImageView` (no renderer needed for defaults); `DefaultImageRenderer` is a never-called marker filling the generic slot. This removed the last `AnyView` (previously inside the default renderer).
- Earlier this session: generic `ImageView<Loading, Failure, Renderer>` replaced the `any View` + `AnyView` contract (renderer returns arbitrary SDK views; chosen over runtime env injection), plus Kingfisher decoupling, repo rename to OneImage, and CI.

## Next steps (suggested)
1. Commit the generic renderer redesign.
2. Resolve the `cornerRadius` no-op (apply or remove).
3. Decide on the `DeveloperToolsSupport` coupling in `Core`.
4. Tag a `1.0.0` release.
5. Re-generate this file's "What changed" section after any of the above lands.
