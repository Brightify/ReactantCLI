//
//  Platform.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public enum Platform: String {
    case iOS
    case macOS

    public var name: String {
        return rawValue
    }

    public var sdks: Set<SDK> {
        switch self {
        case .iOS:
            return [.iphoneos, .iphonesimulator]
        case .macOS:
            return [.macosx]
        }
    }

    public var sdkRoot: String {
        switch self {
        case .iOS:
            return SDK.iphoneos.name
        case .macOS:
            return SDK.macosx.name
        }
    }

    public static let allPlatforms: [Platform] = [.iOS, .macOS]
}
