//
//  DependencyModule.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public func dependencyModule() -> [String] {
    return [
        "protocol DependencyModule {",
        "}",
    ]
}

public func applicationModule() -> [String] {
    return [
        "final class ApplicationModule: DependencyModule {",
        "}",
    ]
}
