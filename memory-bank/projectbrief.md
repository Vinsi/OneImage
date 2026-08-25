# Project Brief: ImageIO

## What
A SwiftUI image loading library for local and remote images, distributed as a Swift Package.

## Goals
- Provide a single declarative `ImageView` that renders both local images (assets, system symbols, resources) and remote images (URLs) through one API.
- Keep the image *model* (`Core`) platform-independent and UI-free so it can be reused outside SwiftUI.
- Abstract remote loading behind a rendering protocol so the library is not hard-coupled to a single network image loader.
- Ship as reusable SPM products (`Core`, `View`) plus a sample app (`ImageIOSample`, `ImageIOSampleUI`).

## Requirements
- Swift 6.2+
- iOS 17+ / macOS 14+
- Kingfisher (dependency for remote image loading)

## Out of scope (current)
- Video / animated image handling
- Thumbnail generation or image processing
- Platform-specific (non-Apple) backends

## Source of truth
- Repo: `https://github.com/Vinsi/ImageIO.git`
- Package root: `<repo>/ImageIO` (contains `Package.swift`)
- License: MIT
