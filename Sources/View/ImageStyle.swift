//
//  ImageStyle.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

public struct ImageStyle: Sendable, Equatable {
    public var renderingMode: Image.TemplateRenderingMode?
    public var interpolation: Image.Interpolation?
    public var isAntialiased: Bool?
    public var resize: ResizeConfiguration?

    public init(
        renderingMode: Image.TemplateRenderingMode? = nil,
        interpolation: Image.Interpolation? = nil,
        isAntialiased: Bool? = nil,
        resize: ResizeConfiguration? = nil
    ) {
        self.renderingMode = renderingMode
        self.interpolation = interpolation
        self.isAntialiased = isAntialiased
        self.resize = resize
    }

    public struct ResizeConfiguration: Sendable, Equatable {
        public var capInsets: EdgeInsets
        public var resizingMode: Image.ResizingMode

        public init(
            capInsets: EdgeInsets,
            resizingMode: Image.ResizingMode
        ) {
            self.capInsets = capInsets
            self.resizingMode = resizingMode
        }
    }
}
