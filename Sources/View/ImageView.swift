//
//  ImageView.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import Core
import SwiftUI

public struct ImageView<Loading: View, Failure: View>: View {
    let configuration: ImageConfiguration<Loading, Failure>
    @Environment(\.remoteImageRenderer) private var remoteImageRenderer

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

    private func local(_ resource: ImageReference.LocalSource) -> some View {
        resource.imageView.applying(configuration.style)
    }

    private func remote(_ url: URL) -> AnyView {
        let renderer = configuration.remoteImageRenderer ?? remoteImageRenderer
        return AnyView(
            renderer.makeRemoteImage(
                url: url,
                loading: configuration.loadingPlaceHolder,
                failure: configuration.failurePlaceHolder,
                style: configuration.style
            )
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
