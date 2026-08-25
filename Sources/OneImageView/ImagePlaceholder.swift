//
//  ImagePlaceholder.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import OneImageCore
import SwiftUI

public struct ImagePlaceholder<Content: View>: View {
    let holder: Content

    public var body: some View {
        holder
    }
}

extension ImagePlaceholder where Content == EmptyView {
    public init() {
        holder = EmptyView()
    }

    @MainActor
    public static var none: Self {
        .init()
    }
}

extension ImagePlaceholder where Content == Image {
    public init(image: ImageReference.LocalSource) {
        holder = image.imageView
    }
}

extension ImagePlaceholder {
    public init(@ViewBuilder content: () -> Content) {
        holder = content()
    }
}
