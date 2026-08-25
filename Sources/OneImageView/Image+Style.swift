//
//  Image+Style.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

extension Image {
    public func applying(_ style: ImageStyle) -> Image {
        var image = self
        if let renderingMode = style.renderingMode {
            image = image.renderingMode(renderingMode)
        }
        if let interpolation = style.interpolation {
            image = image.interpolation(interpolation)
        }
        if let isAntialiased = style.isAntialiased {
            image = image.antialiased(isAntialiased)
        }
        if let resize = style.resize {
            image = image.resizable(
                capInsets: resize.capInsets,
                resizingMode: resize.resizingMode
            )
        }
        return image
    }
}
