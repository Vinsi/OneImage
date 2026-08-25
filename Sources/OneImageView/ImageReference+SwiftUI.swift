//
//  ImageReference+SwiftUI.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import OneImageCore
import SwiftUI

extension ImageReference.LocalSource {
    var imageView: Image {
        switch self {
        case .asset(let name, let bundle):
            Image(name, bundle: bundle)
        case .resource(let resource):
            Image(resource)
        case .system(let name):
            Image(systemName: name)
        }
    }
}
