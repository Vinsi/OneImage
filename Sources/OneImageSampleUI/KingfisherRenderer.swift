//
//  KingfisherRenderer.swift
//  OneImageSampleUI
//
//  Created by Vinsi on 23.8.26.
//

import Kingfisher
import SwiftUI
import View

struct KingfisherRenderer: RemoteImageRenderer {
    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> KFImage {
        KFImage(url)
            .placeholder { loading }
            .onFailureView { failure }
            .fade(duration: 0.25)
            .cacheOriginalImage(true)
            .cancelOnDisappear(true)
    }
}
