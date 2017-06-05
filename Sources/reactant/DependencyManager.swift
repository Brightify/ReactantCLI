//
//  DependencyManager.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

enum DependencyManager {
    case cocoaPods
    case carthage
    case swiftPM

    static let allManagers: [DependencyManager] = [.cocoaPods, .carthage, .swiftPM]

    var name: String {
        switch self {
        case .cocoaPods:
            return "CocoaPods"
        case .carthage:
            return "Carthage (not available)"
        case .swiftPM:
            return "Swift Package Manager (not available)"
        }
    }
}
