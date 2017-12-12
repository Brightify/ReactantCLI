//
//  ProjectConfiguration.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public struct ProjectConfiguration {
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
}
