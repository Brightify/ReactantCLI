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

class ResolvedTarget: ObjectIdentifierProtocol {
    enum Kind {
        case main
        case unitTest
        case uiTest
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

struct Source {
    enum Kind {
        case source(() -> [String])
        case sourceRef
        case resource(() -> [String])
        case resourceRef
        case directory
        case fileRef
        case file(() -> [String])
    }

    let path: RelativePath
    let type: Kind
    let ignoreXcode: Bool

    init(path: String, type: Kind, ignoreXcode: Bool = false) {
        self.path = RelativePath(path)
        self.type = type
        self.ignoreXcode = ignoreXcode
    }

    func absolutePath(root: AbsolutePath) -> AbsolutePath {
        return root.appending(path)
    }
}

class Sources {
    let items: [Source]
    let root: AbsolutePath

    init(items: [Source], root: AbsolutePath) {
        // FIXME Do we want the sort? [Probably not]
        self.items = items //.sorted(by: { $0.path.asString < $1.path.asString })
        self.root = root
    }
}

import SwiftyTextTable

struct ProjectConfiguration: CustomStringConvertible {
    let platform: Platform
    let productName: String
    // let team: String
    let developmentTeam: String
    let organizationIdentifier: String
    let dependencyManager: DependencyManager
    let workingDir: AbsolutePath
    let outputDir: RelativePath
    let targets: [ResolvedTarget]
    let experimentalFeatures: Set<ExperimentalFeatures>

    var projectDir: AbsolutePath {
        return workingDir.appending(outputDir)
    }

    var bundleIdentifier: String {
        return "\(organizationIdentifier).\(productName)"
    }

    var description: String {
        let property = TextTableColumn(header: "Property")
        let value = TextTableColumn(header: "Value")

        var table = TextTable(columns: [property, value])
        table.header = "Project Configuration"
        table.addRow(values: ["platform", platform.name])
        table.addRow(values: ["product name", productName])
        table.addRow(values: ["development team", developmentTeam])
        table.addRow(values: ["bundle identifier", bundleIdentifier])
        table.addRow(values: ["output dir", outputDir.asString])
        table.addRow(values: ["experimental features", experimentalFeatures.map { $0.name }])

        return table.render()
    }
}

import SwiftCLI

CLI.setup(name: "reactant", version: "0.1", description: "Reactant CLI - Initialize Reactant projects in seconds!")

let initCommand = InitCommand()

CLI.register(command: initCommand)

CLI.go()
