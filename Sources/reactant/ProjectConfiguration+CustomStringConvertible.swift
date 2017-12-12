//
//  ProjectConfiguration+CustomStringConvertible.swift
//  reactant
//
//  Created by Tadeas Kriz on 12/12/17.
//

import SwiftyTextTable
import ProjectGeneratorFramework

extension ProjectConfiguration: CustomStringConvertible {
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
