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

enum ExperimentalFeatures {
    case torch
    case cuckoo
    case xmlUI
    case liveUI

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

enum Platform {
    case iOS
    case macOS

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

struct ProjectConfiguration {
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
}

func readString(title: String) -> String {
    print(title)
    guard let string = readLine() else {
        return readString(title: title)
    }
    return string
}

func readBool(title: String) -> Bool {
    let string = readString(title: title + " [y/n]").lowercased()
    let trueValues = ["y", "yes", "true"] as Set<String>
    let falseValues = ["n", "no", "false"] as Set<String>
    if trueValues.contains(string) {
        return true
    } else if falseValues.contains(string) {
        return false
    } else {
        return readBool(title: title)
    }
}

import Foundation

func askForConfiguration() -> ProjectConfiguration {
    let productName = readString(title: "Product Name:")
    let developmentTeam = readString(title: "Team ID (from developer.apple.com):")
    let organizationIdentifier = readString(title: "Organization Identifier:")

    print("Bundle identifier will be: \(organizationIdentifier).\(productName)")

    var experimentalFeatures = [] as Set<ExperimentalFeatures>
    if readBool(title: "Enable Reactant UI - Declare UI in XML?") {
        experimentalFeatures.insert(.xmlUI)
        if readBool(title: "Enable Reactant Live UI Reload?") {
            experimentalFeatures.insert(.liveUI)
        }
    }

    let workingDir = AbsolutePath(FileManager.default.currentDirectoryPath)
    let outputDir = RelativePath(productName)
    let applicationDir = workingDir.appending(outputDir).appending(components: "Application")

    var mainSources = [] as [Source]

    if experimentalFeatures.contains(.xmlUI) {
        mainSources.append(Source(path: "Generated", type: .directory))
        mainSources.append(Source(path: "Generated/GeneratedUI.swift", type: .sourceRef))
        mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source(mainRootViewXml)))
        mainSources.append(Source(path: "Sources/Components/Main/MainRootView.ui.xml", type: .file(mainRootViewXmlUI)))
    } else {
        mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source(mainRootView)))
    }

    mainSources.append(contentsOf: [
        Source(path: "Sources/Components/Main/MainController.swift", type: .source(mainController)),
        Source(path: "Sources/Models", type: .directory),
        Source(path: "Sources/Services", type: .directory),
        Source(path: "Sources/Styles/General.styles.xml", type: .file(generalStyles)),
        Source(path: "Sources/Wireframes/MainWireframe.swift", type: .source(mainWireframe)),
        Source(path: "Sources/AppDelegate.swift", type: .source(appDelegate(experimentalFeatures: experimentalFeatures))),
        Source(path: "Sources/DependencyModule.swift", type: .source(dependencyModule)),
        Source(path: "Sources/ApplicationModule.swift", type: .source(applicationModule)),
        Source(path: "Resources/Assets.xcassets/AppIcon.appiconset/Contents.json", type: .file(assetsJson), ignoreXcode: true),
        Source(path: "Resources/Assets.xcassets/Contents.json", type: .file(assetsJson), ignoreXcode: true),
        Source(path: "Resources/Assets.xcassets", type: .resourceRef),
        Source(path: "Resources/LaunchScreen.storyboard", type: .resource(launchScreen)),
        Source(path: "Resources/Localizable.strings", type: .resource(gitKeep)),
        Source(path: "Resources/Info.plist", type: .fileRef),
    ])

    var targets = [
        ResolvedTarget(
            name: productName,
            sources: Sources(items: mainSources, root: applicationDir),
            type: .main)
    ]
    if false && readBool(title: "Enable Unit Tests?") {
        let unitTestDir = workingDir.appending(outputDir).appending(components: "UnitTests")
        targets.append(
            ResolvedTarget(
                name: "\(productName)UnitTests",
                sources: Sources(items: [], root: unitTestDir),
                type: .unitTest)
        )
    }
    if false && readBool(title: "Enable UI Tests?") {
        let uiTestDir = workingDir.appending(outputDir).appending(components: "UITests")
        targets.append(
            ResolvedTarget(
                name: "\(productName)UITests",
                sources: Sources(items: [], root: uiTestDir),
                type: .uiTest)
        )
    }

    let setup = ProjectConfiguration(
        platform: .iOS,
        productName: productName,
        developmentTeam: developmentTeam,
        organizationIdentifier: organizationIdentifier,
        dependencyManager: .cocoaPods,
        workingDir: workingDir,
        outputDir: outputDir,
        targets: targets,
        experimentalFeatures: experimentalFeatures)
    print("---------- Project Setup ----------")
    dump(setup)
    guard readBool(title: "Is the current setup OK?") else { return askForConfiguration() }

    return setup
}

@discardableResult
func shell(workingDir: String? = nil, _ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    if let workingDir = workingDir {
        task.currentDirectoryPath = workingDir
    }
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let config = askForConfiguration()

try! generate(config: config, options: XcodeprojOptions())
switch config.dependencyManager {
case .cocoaPods:
    shell(workingDir: config.projectDir.asString, "pod", "install")
    shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcworkspace")
default:
    shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcodeproj")
}

