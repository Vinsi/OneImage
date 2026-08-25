//
//  ImageReference.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import DeveloperToolsSupport.DeveloperToolsSupport
import Foundation

public enum ImageReference: Equatable, Sendable, Hashable {
    case remote(RemoteSource)
    case local(LocalSource)

    public enum RemoteSource: Equatable, Sendable, Hashable {
        case url(URL)
        case urlString(String)
    }

    public enum LocalSource: Equatable, Sendable, Hashable {
        case asset(String, bundle: Bundle = .main)
        case resource(ImageResource)
        case system(String)
    }
}
