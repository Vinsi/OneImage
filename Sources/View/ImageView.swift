//
//  ImageView.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import Core
import Kingfisher
import SwiftUI

public struct ImageView<Loading: View, Failure: View>: View {
    let configuration: ImageConfiguration<Loading, Failure>

    init(configuration: ImageConfiguration<Loading, Failure>) {
        self.configuration = configuration
    }

    public var body: some View {
        resolvedImage()
    }

    @ViewBuilder
    private func resolvedImage() -> some View {
        switch configuration.imageReference {
        case .remote(.url(let url)):
            remote(url)
        case .remote(.urlString(let urlString)):
            if let url = URL(string: urlString) {
                remote(url)
            } else {
                configuration.failurePlaceHolder
            }
        case .local(let resource):
            local(resource)
        }
    }

    @ViewBuilder
    private func local(
        _ resource: ImageReference.LocalSource
    ) -> some View {
        configuredImage(resource.imageView)
    }

    @ViewBuilder
    private func configuredImage<R: RenderConfigurable>(
        _ image: R
    ) -> some View {
        let rendered =
            image
            .optionalRenderingMode(configuration.renderingMode)
            .optionalInterpolation(configuration.interpolation)
            .optionalAntialiased(configuration.isAntialiased)
        if let resize = configuration.resizeConfiguration {
            rendered.resizable(
                capInsets: resize.capInsets,
                resizingMode: resize.resizingMode
            )
        } else {
            rendered
        }
    }

    private func remote(_ url: URL) -> some View {
        configuredImage(
            KFImage(url)
                .placeholder { configuration.loadingPlaceHolder }
                .onFailureView { configuration.failurePlaceHolder }
                .fade(duration: 0.25)
                .cacheOriginalImage(true)
                .cancelOnDisappear(true)
        )
    }

    func with(
        _ update: (inout ImageConfiguration<Loading, Failure>) -> Void
    ) -> ImageView<Loading, Failure> {
        var configuration = self.configuration
        update(&configuration)
        return ImageView(configuration: configuration)
    }
}

extension ImageView where Loading == EmptyView, Failure == EmptyView {
    public init(_ ref: ImageReference) {
        self.init(
            configuration: .init(
                loadingPlaceHolder: .none,
                failurePlaceHolder: .none,
                imageReference: ref
            )
        )
    }
}
