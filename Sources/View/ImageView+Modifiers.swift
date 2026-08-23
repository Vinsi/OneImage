//
//  ImageView+Modifiers.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

extension ImageView {
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        with {
            $0.cornerRadius = radius
        }
    }

    public func resizable(
        capInsets: EdgeInsets = EdgeInsets(),
        resizingMode: Image.ResizingMode = .stretch
    ) -> Self {
        with {
            $0.resizeConfiguration = .init(
                capInsets: capInsets,
                resizingMode: resizingMode
            )
        }
    }

    public func renderingMode(
        _ renderingMode: Image.TemplateRenderingMode?
    ) -> Self {
        with {
            $0.renderingMode = renderingMode
        }
    }

    public func interpolation(
        _ interpolation: Image.Interpolation
    ) -> Self {
        with {
            $0.interpolation = interpolation
        }
    }

    public func antialiased(
        _ isAntialiased: Bool
    ) -> Self {
        with {
            $0.isAntialiased = isAntialiased
        }
    }
}
