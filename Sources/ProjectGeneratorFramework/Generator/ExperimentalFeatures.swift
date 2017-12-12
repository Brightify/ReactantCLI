//
//  ExperimentalFeatures.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public enum ExperimentalFeatures: String {
    case torch
    case cuckoo
    case xmlUI
    case liveUI

    public var name: String {
        return rawValue
    }

    public static let allFeatures: [ExperimentalFeatures] = [.torch, .cuckoo, .xmlUI, .liveUI]
}
