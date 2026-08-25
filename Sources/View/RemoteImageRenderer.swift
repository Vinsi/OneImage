//
//  RemoteImageRenderer.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI

@MainActor
public protocol RemoteImageRenderer: Sendable {
    associatedtype RemoteView: View

    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> RemoteView
}
