//
//  Image+Modifiers.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

extension Image: RenderConfigurable {
    func optionalRenderingMode(
        _ mode: Image.TemplateRenderingMode?
    ) -> Image {
        renderingMode(mode)
    }

    func optionalInterpolation(
        _ interpolation: Image.Interpolation?
    ) -> Image {
        guard let interpolation else {
            return self
        }

        return self.interpolation(interpolation)
    }

    func optionalAntialiased(
        _ isAntialiased: Bool?
    ) -> Image {
        guard let isAntialiased else {
            return self
        }

        return self.antialiased(isAntialiased)
    }
}
