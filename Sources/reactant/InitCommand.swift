import SwiftCLI
import Rainbow
import Foundation

class InitCommand: Command {

    let name = "init"
    let shortDescription = "Initializes a Reactant project"

    func execute() throws {

        let config = askForConfiguration()

        try! generate(config: config, options: XcodeprojOptions())

        if config.versionControl == .git {
            shell(workingDir: config.projectDir.asString, "git", "init")
            try open(config.projectDir.appending(component: ".gitignore")) { print in
                gitignore().forEach(print)
            }
            shell(workingDir: config.projectDir.asString, "git", "add", "Application")
            shell(workingDir: config.projectDir.asString, "git", "add", ".gitignore")
            shell(workingDir: config.projectDir.asString, "git", "add", "\(config.productName).xcodeproj")
        }

        switch config.dependencyManager {
        case .cocoaPods:
            shell(workingDir: config.projectDir.asString, "pod", "install")
            if config.versionControl == .git {
                shell(workingDir: config.projectDir.asString, "git", "add", "Podfile")
                shell(workingDir: config.projectDir.asString, "git", "add", "Podfile.lock")
            }
            shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcworkspace")
        default:
            shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcodeproj")
        }

        if config.versionControl == .git  {
            shell(workingDir: config.projectDir.asString, "git", "commit", "-m Initial commit.")
        }
    }

    func askForConfiguration() -> ProjectConfiguration {
        let productName = readString(title: "Product Name:")
        let developmentTeam = readString(title: "Team ID (from developer.apple.com):")
        let organizationIdentifier = readString(title: "Organization Identifier:")

        var experimentalFeatures = [] as Set<ExperimentalFeatures>
        if readBool(title: "Enable Reactant UI - Declare UI in XML?") {
            experimentalFeatures.insert(.xmlUI)
            if readBool(title: "Enable Reactant Live UI Reload?") {
                experimentalFeatures.insert(.liveUI)
            }
        }

        if readBool(title: "Enable Torch ORM?") {
            experimentalFeatures.insert(.torch)
        }

        if false && readBool(title: "Enable Cuckoo - boilerplate free mocking framework?") {
            experimentalFeatures.insert(.cuckoo)
        }

        let workingDir = AbsolutePath(FileManager.default.currentDirectoryPath)
        let outputDir = RelativePath(productName)
        let applicationDir = workingDir.appending(outputDir).appending(components: "Application")

        var mainSources = [] as [Source]

        if experimentalFeatures.contains(.torch) || experimentalFeatures.contains(.xmlUI) {
            mainSources.append(Source(path: "Generated", type: .directory))
        }

        if experimentalFeatures.contains(.torch) {
            mainSources.append(Source(path: "Sources/Models/SampleModel.swift", type: .source(sampleTorchModel)))
            mainSources.append(Source(path: "Generated/ModelExtensions.generated.swift", type: .sourceRef))
        } else {
            mainSources.append(Source(path: "Sources/Models/SampleModel.swift", type: .source(sampleModel)))
        }

        if experimentalFeatures.contains(.xmlUI) {
            mainSources.append(Source(path: "Generated/GeneratedUI.swift", type: .sourceRef))
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source(mainRootViewXml)))
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.ui.xml", type: .file(mainRootViewXmlUI)))
            mainSources.append(Source(path: "Sources/Styles/General.styles.xml", type: .file(generalStyles)))
        } else {
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source(mainRootView)))
        }

        mainSources.append(contentsOf: [
            Source(path: "Sources/Components/Main/MainController.swift", type: .source(mainController)),
            Source(path: "Sources/Services/SampleService.swift", type: .source(sampleService)),
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
        if readBool(title: "Enable UI Tests?") {
            let uiTestDir = workingDir.appending(outputDir).appending(components: "UITests")
            let uiTestSources = [
                Source(path: "Info.plist", type: .fileRef),
                Source(path: "FirstUITest.swift", type: .source(exampleTest)),
            ]
            targets.append(
                ResolvedTarget(
                    name: "\(productName)UITests",
                    sources: Sources(items: uiTestSources, root: uiTestDir),
                    type: .uiTest(target: productName))
            )
        }

        let versionControl: VersionControl = readBool(title: "Enable git?") ? .git : .none

        let setup = ProjectConfiguration(
            platform: .iOS,
            productName: productName,
            developmentTeam: developmentTeam,
            organizationIdentifier: organizationIdentifier,
            dependencyManager: .cocoaPods,
            workingDir: workingDir,
            outputDir: outputDir,
            targets: targets,
            experimentalFeatures: experimentalFeatures,
            versionControl: versionControl)
        print(setup)
        guard readBool(title: "Is the current configuration OK?") else { return askForConfiguration() }

        return setup
    }
}
