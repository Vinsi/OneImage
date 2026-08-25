//
//  ImageConfiguration.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import Core
import SwiftUI

@MainActor
struct ImageConfiguration<Loading: View, Failure: View> {
    var cornerRadius: CGFloat = 0
    var loadingPlaceHolder: ImagePlaceholder<Loading>
    var failurePlaceHolder: ImagePlaceholder<Failure>
    var imageReference: ImageReference
    var style: ImageStyle = ImageStyle()
    var remoteImageRenderer: (any RemoteImageRenderer)?
}
