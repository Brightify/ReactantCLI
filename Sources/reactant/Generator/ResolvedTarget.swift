//
//  ResolvedTarget.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

class ResolvedTarget: ObjectIdentifierProtocol {
    enum Kind {
        case main
        case unitTest
        case uiTest(target: String)
    }


    var name: String
    var sources: Sources
    var type: Kind

    init(name: String, sources: Sources, type: Kind) {
        self.name = name
        self.type = type
        self.sources = sources
    }

    var c99name: String {
        return name.mangledToC99ExtendedIdentifier()
    }
    var productName: String {
        return name
    }
    var isTest: Bool {
        switch type {
        case .main:
            return false
        case .unitTest, .uiTest:
            return true
        }
    }

    var infoPlistPath: RelativePath {
        if isTest {
            return RelativePath("Info.plist")
        } else {
            return RelativePath("Resources/Info.plist")
        }
    }

    var productPath: RelativePath {
        switch type {
        case .main:
            return RelativePath(name)
        case .uiTest, .unitTest:
            return RelativePath("\(c99name).xctest")
        }
    }
}
