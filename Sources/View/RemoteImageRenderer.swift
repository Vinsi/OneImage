//
//  RemoteImageRenderer.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

public protocol RemoteImageRenderer: Sendable {
    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> any View
}

private struct RemoteImageRendererKey: EnvironmentKey {
    static let defaultValue: any RemoteImageRenderer = AsyncImageRenderer()
}

public extension EnvironmentValues {
    var remoteImageRenderer: any RemoteImageRenderer {
        get { self[RemoteImageRendererKey.self] }
        set { self[RemoteImageRendererKey.self] = newValue }
    }
}
