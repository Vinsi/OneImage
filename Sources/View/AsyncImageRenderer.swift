//
//  AsyncImageRenderer.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

public struct AsyncImageRenderer: RemoteImageRenderer {
    public init() {}

    @MainActor
    public func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> AsyncRemoteImage {
        AsyncRemoteImage(
            url: url,
            loading: AnyView(loading),
            failure: AnyView(failure),
            style: style
        )
    }
}

public struct AsyncRemoteImage: View {
    let url: URL
    let loading: AnyView
    let failure: AnyView
    let style: ImageStyle

    public init(
        url: URL,
        loading: AnyView,
        failure: AnyView,
        style: ImageStyle
    ) {
        self.url = url
        self.loading = loading
        self.failure = failure
        self.style = style
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                loading
            case .success(let image):
                image.applying(style)
            case .failure:
                failure
            @unknown default:
                failure
            }
        }
    }
}
