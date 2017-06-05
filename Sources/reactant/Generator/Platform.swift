//
//  Platform.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

enum Platform: String {
    case iOS
    case macOS

    var name: String {
        return rawValue
    }

    var sdks: Set<SDK> {
        switch self {
        case .iOS:
            return [.iphoneos, .iphonesimulator]
        case .macOS:
            return [.macosx]
        }
    }

    var sdkRoot: String {
        switch self {
        case .iOS:
            return SDK.iphoneos.name
        case .macOS:
            return SDK.macosx.name
        }
    }

    static let allPlatforms: [Platform] = [.iOS, .macOS]
}
