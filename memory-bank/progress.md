# Progress: OneImage

## Working
- `Core` product: `ImageReference` with `remote`/`local` cases; `Equatable`, `Sendable`, `Hashable`.
- `View` product:
  - `ImageView` renders local (asset/resource/system) and remote (`url`/`urlString`) images.
  - **No third-party dependencies** — remote rendering via injectable `RemoteImageRenderer`, default `AsyncImageRenderer` (SwiftUI `AsyncImage`).
  - `ImageStyle` value type centralizes styling via `Image.applying(_:)` (local + default renderer auto-apply; no protocol conformance burden).
  - Modifiers: `resizable`, `renderingMode`, `interpolation`, `antialiased`, `setCornerRadius`, `remoteImageRenderer` (per-view override, wins over environment).
  - Placeholders: `placeholderLoading` / `placeholderFailure` (view-builder and image variants); type-state generics; placeholder replacement preserves style/cornerRadius.
- Sample app (`OneImageSample`/`OneImageSampleUI`) with local + remote sections, 9 canvas previews, plus an injected-renderer preview.
- Tests: 2 Core tests + 12 View UI/render tests (Swift Testing + `ImageRenderer`) — 14 total, all passing.
- CI: GitHub Actions (`.github/workflows/ci.yml`) — macOS build + tests + format lint, and iOS Simulator build.
- Git: initial release committed and pushed to `origin/main` (`4022a59`); repo renamed to `Vinsi/OneImage`.

## In progress
- Kingfisher-decoupling refactor is implemented and tested but **not committed** (working tree).

## Not yet addressed
- `cornerRadius` stored but never applied in the rendered view (dead config unless applied).
- `Core` imports `DeveloperToolsSupport` for `ImageResource` — coupling vs. platform-independence trade-off not resolved.
- No release/tag workflow yet; README references `from: "1.0.0"` but no tag/version exists yet.
- No bundled Kingfisher renderer sample inside the package (by design — it stays dependency-free); consumers own their renderer.

## Definition of done for a task
- `swift build` and `swift test` pass.
- Memory bank (`activeContext.md`, `progress.md`) updated to reflect the change.
- Public API documented in README for any new surface area.
