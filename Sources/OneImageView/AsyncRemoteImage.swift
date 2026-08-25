//
//  AsyncRemoteImage.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

public struct AsyncRemoteImage<Loading: View, Failure: View>: View {
    let url: URL
    let loading: ImagePlaceholder<Loading>
    let failure: ImagePlaceholder<Failure>
    let style: ImageStyle

    public init(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
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
