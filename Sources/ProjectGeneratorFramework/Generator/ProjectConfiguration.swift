//
//  ProjectConfiguration.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import SwiftyTextTable

public struct ProjectConfiguration: CustomStringConvertible {
    public let platform: Platform
    public let productName: String
    // let team: String
    public let developmentTeam: String
    public let organizationIdentifier: String
    public let dependencyManager: DependencyManager
    public let projectDir: AbsolutePath
    public let targets: [ResolvedTarget]
    public let experimentalFeatures: Set<ExperimentalFeatures>
    public let versionControl: VersionControl

    public var bundleIdentifier: String {
        return "\(organizationIdentifier).\(productName)"
    }

    public var description: String {
        let property = TextTableColumn(header: "Property")
        let value = TextTableColumn(header: "Value")

        var table = TextTable(columns: [property, value])
        table.header = "Project Configuration"
        table.addRow(values: ["platform", platform.name])
        table.addRow(values: ["product name", productName])
        table.addRow(values: ["development team", developmentTeam])
        table.addRow(values: ["bundle identifier", bundleIdentifier])
        table.addRow(values: ["output dir", projectDir.asString])
        table.addRow(values: ["experimental features", experimentalFeatures.map { $0.name }])
        table.addRow(values: ["version control", versionControl.rawValue])

        return table.render()
    }
}
