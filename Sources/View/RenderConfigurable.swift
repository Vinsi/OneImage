//
//  RenderConfigurable.swift
//  ImageIO
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

protocol RenderConfigurable: View {
    func optionalRenderingMode(_ mode: Image.TemplateRenderingMode?) -> Self
    func optionalInterpolation(_ interpolation: Image.Interpolation?) -> Self
    func optionalAntialiased(_ isAntialiased: Bool?) -> Self
    func resizable(
        capInsets: EdgeInsets,
        resizingMode: Image.ResizingMode
    ) -> Self
}
