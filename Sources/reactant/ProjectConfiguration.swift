//
//  ProjectConfiguration.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

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
    let versionControl: VersionControl

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
        table.addRow(values: ["version control", versionControl.rawValue])

        return table.render()
    }
}
