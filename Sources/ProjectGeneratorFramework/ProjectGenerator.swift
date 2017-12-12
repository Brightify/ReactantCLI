//
//  ProjectGenerator.swift
//  ReactantCLI
//
//  Created by Matouš Hýbl on 11/08/2017.
//
//

import Foundation

public class ProjectGenerator {

    public static func generateProject(config: ProjectConfiguration) throws {
        _ = try generate(config: config, options: XcodeprojOptions())

        shell(workingDir: config.projectDir.asString, "git", "init")
        try open(config.projectDir.appending(component: ".gitignore")) { print in
            gitignore().forEach(print)
        }
        shell(workingDir: config.projectDir.asString, "git", "add", "Application")
        shell(workingDir: config.projectDir.asString, "git", "add", ".gitignore")
        shell(workingDir: config.projectDir.asString, "git", "add", "\(config.productName).xcodeproj")

        switch config.dependencyManager {
        case .cocoaPods:
            shell(workingDir: config.projectDir.asString, "pod", "install")
            shell(workingDir: config.projectDir.asString, "git", "add", "Podfile")
            shell(workingDir: config.projectDir.asString, "git", "add", "Podfile.lock")
        default:
            break
        }
        shell(workingDir: config.projectDir.asString, "git", "commit", "-m Initial commit.")
    }
}
