//
//  SDK.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

enum SDK: String {
    case macosx
    case iphoneos
    case iphonesimulator
    case appletvos
    case appletvsimulator
    case watchos
    case watchsimulator

    var name: String {
        return rawValue
    }
}
