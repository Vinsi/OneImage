# OneImageDemo

A ready-to-run iOS sample app that uses OneImage for local and remote images.

## What it shows

- **Local images from the app's own asset catalog** — `ImageView(.local(.asset("sample")))` renders the bundled `sample.png` (see `Assets.xcassets`). Drop your own images into the catalog and reference them by name.
- **Local SF Symbols** — `ImageView(.local(.system("star.fill")))`.
- **Remote via the built-in renderer** — `ImageView(.remote(...))` uses the package's `AsyncRemoteImage` (SwiftUI `AsyncImage`), with loading/failure placeholders.
- **Remote via Kingfisher** — `KingfisherRenderer` (a `RemoteImageRenderer` returning `KFImage`) injected at init: `ImageView(.remote(...), renderer: KingfisherRenderer())`.

## Requirements

- Xcode 16+ (Swift 6.1+)
- iOS 17+ simulator or device

## Open and run

The `.xcodeproj` is committed, so just open it:

```sh
open OneImageDemo.xcodeproj
```

Then select the **OneImageDemo** scheme and an iOS Simulator destination, and Run.

## Regenerate (optional)

The project was generated with [XcodeGen](https://github.com/yonaskolb/XcodeGen). If you edit `project.yml`, regenerate:

```sh
xcodegen generate
```

The OneImage package is referenced by local path (`../..`), so changes to the library are picked up immediately.

## How the dependency is wired

`project.yml` adds the OneImage package (products `Core` and `View`) plus `Kingfisher` directly, so the demo can define its own `KingfisherRenderer` without the library depending on any SDK.
