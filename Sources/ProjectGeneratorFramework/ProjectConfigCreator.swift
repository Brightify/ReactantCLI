//
//  ProjectConfigurationCreator.swift
//  ReactantCLI
//
//  Created by Matouš Hýbl on 09/08/2017.
//
//

import Foundation

public class ProjectConfigCreator {

    public static func getConfig(productName: String,
                          developmentTeam: String,
                          organizationIdentifier: String,
                          projectPath: String,
                          experimentalFeatures: Set<ExperimentalFeatures>,
                          enableUnitTests: Bool,
                          enableUITests: Bool,
                          createProjectFolder: Bool) -> ProjectConfiguration {

        let workingDir = AbsolutePath(projectPath)
        let outputDir = RelativePath(productName)
        let projectDir: AbsolutePath
        if createProjectFolder {
            projectDir = workingDir.appending(outputDir)
        } else {
            projectDir = workingDir
        }

        let applicationDir = projectDir.appending(components: "Application")

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
            mainSources.append(Source(path: "Generated/GeneratedUI.swift", type: .source { [""] })) // this way the user doesn't have to add it manually later
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source({ component(componentName:"MainRootView") })))
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.ui.xml", type: .file(mainRootViewXmlUI)))
            mainSources.append(Source(path: "Sources/Styles/General.styles.xml", type: .file(generalStyles)))
            mainSources.append(Source(path: "Resources/\(productName).hyperdrive.xml", type: .source(hyperdriveConfig)))
        } else {
            mainSources.append(Source(path: "Sources/Components/Main/MainRootView.swift", type: .source(mainRootView)))
        }

        mainSources.append(contentsOf: [
            Source(path: "Sources/Components/Main/MainController.swift", type: .source(mainController)),
            Source(path: "Sources/Services/SampleService.swift", type: .source(sampleService)),
            Source(path: "Sources/Wireframes/MainWireframe.swift", type: .source(mainWireframe)),
            Source(path: "Sources/Wireframes/ApplicationWireframe.swift", type: .source(applicationWireframe)),
            Source(path: "Sources/AppDelegate.swift", type: .source(appDelegate(experimentalFeatures: experimentalFeatures))),
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
        if enableUnitTests {
            let unitTestDir = projectDir.appending(components: "UnitTests")
            let unitTestSources = [
                Source(path: "Info.plist", type: .fileRef),
                Source(path: "FirstTest.swift", type: .source(exampleUnitTest)),
                ]
            targets.append(
                ResolvedTarget(
                    name: "\(productName)UnitTests",
                    sources: Sources(items: unitTestSources, root: unitTestDir),
                    type: .unitTest)
            )
        }
        if enableUITests {
            let uiTestDir = projectDir.appending(components: "UITests")

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

        let setup = ProjectConfiguration(
            platform: .iOS,
            productName: productName,
            developmentTeam: developmentTeam,
            organizationIdentifier: organizationIdentifier,
            dependencyManager: .cocoaPods,
            projectDir: projectDir,
            targets: targets,
            experimentalFeatures: experimentalFeatures,
            versionControl: .git)

        return setup
    }
}
