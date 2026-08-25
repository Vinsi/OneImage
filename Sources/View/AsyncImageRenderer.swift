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
    ) -> any View {
        AsyncRemoteImage(
            url: url,
            loading: loading,
            failure: failure,
            style: style
        )
    }
}

private struct AsyncRemoteImage<Loading: View, Failure: View>: View {
    let url: URL
    let loading: ImagePlaceholder<Loading>
    let failure: ImagePlaceholder<Failure>
    let style: ImageStyle

    var body: some View {
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
