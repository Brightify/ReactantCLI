//
//  SDK.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public enum SDK: String {
    case macosx
    case iphoneos
    case iphonesimulator
    case appletvos
    case appletvsimulator
    case watchos
    case watchsimulator

    public var name: String {
        return rawValue
    }
}
