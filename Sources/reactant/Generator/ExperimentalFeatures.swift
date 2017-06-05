//
//  ExperimentalFeatures.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

enum ExperimentalFeatures: String {
    case torch
    case cuckoo
    case xmlUI
    case liveUI

    var name: String {
        return rawValue
    }

    static let allFeatures: [ExperimentalFeatures] = [.torch, .cuckoo, .xmlUI, .liveUI]
}
