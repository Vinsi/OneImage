//
//  ImageView+Placeholder.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import Core
import SwiftUI

extension ImageView {
    private func replacing<NewLoading: View, NewFailure: View>(
        loadingPlaceHolder: ImagePlaceholder<NewLoading>,
        failurePlaceHolder: ImagePlaceholder<NewFailure>
    ) -> ImageView<NewLoading, NewFailure, Renderer> {
        ImageView<NewLoading, NewFailure, Renderer>(
            configuration: .init(
                cornerRadius: configuration.cornerRadius,
                loadingPlaceHolder: loadingPlaceHolder,
                failurePlaceHolder: failurePlaceHolder,
                imageReference: configuration.imageReference,
                style: configuration.style
            ),
            renderer: renderer
        )
    }

    public func placeholderLoading<NewLoading: View>(
        @ViewBuilder _ content: () -> NewLoading
    ) -> ImageView<NewLoading, Failure, Renderer> {
        replacing(
            loadingPlaceHolder: ImagePlaceholder(content: content),
            failurePlaceHolder: configuration.failurePlaceHolder
        )
    }

    public func placeholderFailure<NewFailure: View>(
        @ViewBuilder _ content: () -> NewFailure
    ) -> ImageView<Loading, NewFailure, Renderer> {
        replacing(
            loadingPlaceHolder: configuration.loadingPlaceHolder,
            failurePlaceHolder: ImagePlaceholder(content: content)
        )
    }

    public func placeholderLoading(
        image: ImageReference.LocalSource
    ) -> ImageView<Image, Failure, Renderer> {
        replacing(
            loadingPlaceHolder: ImagePlaceholder(image: image),
            failurePlaceHolder: configuration.failurePlaceHolder
        )
    }

    public func placeholderFailure(
        image: ImageReference.LocalSource
    ) -> ImageView<Loading, Image, Renderer> {
        replacing(
            loadingPlaceHolder: configuration.loadingPlaceHolder,
            failurePlaceHolder: ImagePlaceholder(image: image)
        )
    }
}
