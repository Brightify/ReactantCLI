//
//  DependencyModule.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

func dependencyModule() -> [String] {
    return [
        "protocol DependencyModule {",
        "}",
    ]
}

func applicationModule() -> [String] {
    return [
        "final class ApplicationModule: DependencyModule {",
        "}",
    ]
}
