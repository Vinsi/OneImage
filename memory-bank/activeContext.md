# Active Context: OneImage

## Current focus
Initial release is committed (`4022a59`). The working tree now contains the **Kingfisher-decoupling refactor** (renderer injection), implemented and passing tests but **not yet committed**:

- `Package.swift` — `Kingfisher` dependency removed; `View` depends only on `Core`.
- Deleted `RenderConfigurable.swift`, `Image+Modifiers.swift`, `KFImage+Modifiers.swift`.
- Added `ImageStyle` (+ `Image.applying`), `RemoteImageRenderer` protocol + `\.remoteImageRenderer` environment key (default `AsyncImageRenderer` via SwiftUI `AsyncImage`), and an injection demo preview.
- `ImageView.remote` now goes through the injected renderer; local path applies `ImageStyle`.
- Fixed a latent bug: `replacing` (placeholders) now preserves `style`/`cornerRadius`.
- Tests updated + added: default renderer, injection, style preservation (14 passing).

## Open questions / decisions pending
1. **`cornerRadius` dead code** — `setCornerRadius` populates `ImageConfiguration.cornerRadius` but nothing applies it in the view body. Decide: apply it (e.g. `.clipShape(RoundedRectangle(...))` or `.cornerRadius`), or remove the modifier/config field.
2. **`Core` ↔ `DeveloperToolsSupport` coupling** — `ImageReference.LocalSource.resource(ImageResource)` requires importing `DeveloperToolsSupport` in `Core` (`ImageReference.swift:8`), which weakens Core's platform-independence. Options: accept it, extract `ImageResource` handling, or gate the `resource` case.
3. **Remote renderer ergonomics** — the injected renderer must mirror new `ImageStyle` fields for foreign view types; consider whether a helper/default should be provided for common cases.
4. **Release** — README references `from: "1.0.0"` but no tag/version exists yet.

## What changed since the last session
- Completed the Kingfischer-decoupling refactor (details above).
- Before this session: an earlier working-tree edit switched `configuredImage` to `some RenderConfigurable` — that file and approach were removed in this refactor.

## Next steps (suggested)
1. Commit the refactor.
2. Resolve the `cornerRadius` no-op (apply or remove).
3. Decide on the `DeveloperToolsSupport` coupling in `Core`.
4. Tag a `1.0.0` release.
5. Re-generate this file's "What changed" section after any of the above lands.
