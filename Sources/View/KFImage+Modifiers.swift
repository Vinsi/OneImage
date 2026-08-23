//
//  KFImage+Modifiers.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import Kingfisher
import SwiftUI

extension KFImage: RenderConfigurable {
    func optionalRenderingMode(
        _ mode: Image.TemplateRenderingMode?
    ) -> KFImage {
        renderingMode(mode)
    }

    func optionalInterpolation(
        _ interpolation: Image.Interpolation?
    ) -> KFImage {
        guard let interpolation else {
            return self
        }

        return self.interpolation(interpolation)
    }

    func optionalAntialiased(
        _ isAntialiased: Bool?
    ) -> KFImage {
        guard let isAntialiased else {
            return self
        }

        return self.antialiased(isAntialiased)
    }
}
