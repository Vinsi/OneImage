//
//  ImageView.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import OneImageCore
import SwiftUI

public struct ImageView<Loading: View, Failure: View, Renderer: RemoteImageRenderer>: View {
    let configuration: ImageConfiguration<Loading, Failure>
    let renderer: Renderer?

    init(
        configuration: ImageConfiguration<Loading, Failure>,
        renderer: Renderer?
    ) {
        self.configuration = configuration
        self.renderer = renderer
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

    private func local(_ resource: ImageReference.LocalSource) -> some View {
        resource.imageView.applying(configuration.style)
    }

    @ViewBuilder
    private func remote(_ url: URL) -> some View {
        if let renderer {
            renderer.makeRemoteImage(
                url: url,
                loading: configuration.loadingPlaceHolder,
                failure: configuration.failurePlaceHolder,
                style: configuration.style
            )
        } else {
            AsyncRemoteImage(
                url: url,
                loading: configuration.loadingPlaceHolder,
                failure: configuration.failurePlaceHolder,
                style: configuration.style
            )
        }
    }

    func with(
        _ update: (inout ImageConfiguration<Loading, Failure>) -> Void
    ) -> ImageView<Loading, Failure, Renderer> {
        var configuration = self.configuration
        update(&configuration)
        return ImageView(configuration: configuration, renderer: renderer)
    }
}

extension ImageView where Loading == EmptyView, Failure == EmptyView {
    public init(_ ref: ImageReference, renderer: Renderer) {
        self.init(
            configuration: .init(
                loadingPlaceHolder: .none,
                failurePlaceHolder: .none,
                imageReference: ref
            ),
            renderer: renderer
        )
    }
}

extension ImageView
where Renderer == DefaultImageRenderer, Loading == EmptyView, Failure == EmptyView {
    public init(_ ref: ImageReference) {
        self.init(
            configuration: .init(
                loadingPlaceHolder: .none,
                failurePlaceHolder: .none,
                imageReference: ref
            ),
            renderer: nil
        )
    }
}
