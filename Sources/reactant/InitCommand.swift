import SwiftCLI
import Rainbow
import Foundation
import ProjectGeneratorFramework

class InitCommand: Command {

    let argumentedInit = Flag("-a", "--arguments", description: "Create project using arguments only")
//    let iosFlag = Flag("--ios", usage: "Create ios project")
    let productName = Key<String>("--name", description: "Input name of the project")
    let developmentTeam = Key<String>("--team", description: "Development team")
    let organizationIdentifier = Key<String>("--identifier", description: "Input organization identifier")
    let outputDir = Key<String>("--outputDir", description: "Input where to create project")
    let useCurrentPathAsProjectRoot = Flag("--currentPathAsProjectRoot", description: "Use current path as project root", defaultValue: false)
    let rui = Flag("--rui", description: "Enable LiveUI")
    let torch = Flag("--torch", description: "Enable Torch")
    let cuckoo = Flag("--cuckoo", description: "Enable Cuckoo")
    let xui = Flag("--xmlui", description: "Enable XML UI definition")
    let uiTests = Flag("--uiTests", description: "Enable UI testing")
    let unitTests = Flag("--unitTests", description: "Enable unit tests")

    let name = "init"
    let shortDescription = "Initializes a Reactant project"

    func execute() throws {

        let config: ProjectConfiguration

        if(argumentedInit.value) {

            guard let productName = productName.value else {
                print("You must supply --name")
                return
            }

            guard let developmentTeam = developmentTeam.value else {
                print("You must supply --team")
                return
            }

            guard let organizationIdentifier = organizationIdentifier.value else {
                print("You must supply --identifier")
                return
            }

            guard let outputDir = outputDir.value else {
                print("You must supply --outputDir")
                return
            }
            var experimentalFeatures = Set<ExperimentalFeatures>()
            if xui.value {
                experimentalFeatures.insert(.xmlUI)
            }

            if rui.value {
                experimentalFeatures.insert(.xmlUI)
                experimentalFeatures.insert(.liveUI)
            }

            if torch.value {
                experimentalFeatures.insert(.torch)
            }

            if cuckoo.value {
                experimentalFeatures.insert(.cuckoo)
            }

            config = ProjectConfigCreator.getConfig(productName: productName,
                                      developmentTeam: developmentTeam,
                                      organizationIdentifier: organizationIdentifier,
                                      projectPath: outputDir,
                                      experimentalFeatures: experimentalFeatures,
                                      enableUnitTests: unitTests.value,
                                      enableUITests: uiTests.value,
                                      createProjectFolder: useCurrentPathAsProjectRoot.value == false)
        } else {
            config = askForConfiguration()
        }

        try! ProjectGenerator.generateProject(config: config)

        switch config.dependencyManager {
        case .cocoaPods:
            if argumentedInit.value == false {
                shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcworkspace")
            }
        default:
            if argumentedInit.value == false {
                shell(workingDir: config.projectDir.asString, "open", "\(config.productName).xcodeproj")
            }
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

        let enableUnitTests = readBool(title: "Enable Unit Tests?")

        let enableUITests = readBool(title: "Enable UI Tests?")
        
        let useCurrentPathAsProjectRoot = readBool(title: "Use current path as project root?")

        let setup = ProjectConfigCreator.getConfig(productName: productName,
                                     developmentTeam: developmentTeam,
                                     organizationIdentifier: organizationIdentifier,
                                     projectPath: FileManager.default.currentDirectoryPath,
                                     experimentalFeatures: experimentalFeatures,
                                     enableUnitTests: enableUnitTests,
                                     enableUITests: enableUITests,
                                     createProjectFolder: useCurrentPathAsProjectRoot == false)
        
        print(setup.description)
        
        guard readBool(title: "Is the current configuration OK?") else { return askForConfiguration() }

        return setup
    }

}


public func readString(title: String) -> String {
    print(title.yellow)
    guard let string = readLine() else {
        return readString(title: title)
    }
    return string
}

public func readBool(title: String) -> Bool {
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
