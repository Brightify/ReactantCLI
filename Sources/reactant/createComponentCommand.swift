//
//  createComponentCommand.swift
//  SwiftCLI
//
//  Created by Matouš Hýbl on 12/06/2017.
//

import SwiftCLI
import Foundation

class CreateComponentCommand: Command {

    let name = "add"
    let shortDescription = "Adds component"

    func execute() throws {
        print("Enter component type")
        print("(1) Controller")
        print("(2) View")
        let output = readString(title: "")
        switch output {
        case "1":
            try generateControllerComponent()
        case "2":
            try generateViewComponent()
        default:
            print("Poor choice of commands")
        }
    }

    private func generateControllerComponent() throws {
        let baseName = readString(title: "Enter controller name:").replacingOccurrences(of: "Controller", with: "")
        let controllerName = "\(baseName)Controller"
        let rootViewName = "\(baseName)RootView"
        let useReactantUI = readBool(title: "Are you using ReactantUI?")
        let workingDir = AbsolutePath(FileManager.default.currentDirectoryPath)

        shell(workingDir: workingDir.asString, "mkdir", baseName)

        try open(workingDir.appending(component: baseName).appending(component: "\(controllerName).swift")) { print in
            controller(controllerName: controllerName, rootViewName: rootViewName).forEach(print)
        }

        try open(workingDir.appending(component: baseName).appending(component: "\(rootViewName).swift")) { print in
            (useReactantUI ? component(componentName: rootViewName) : rootView(rootViewName: rootViewName)).forEach(print)
        }

        if useReactantUI {
            try open(workingDir.appending(component: baseName).appending(component: "\(rootViewName).ui.xml")) { print in
                mainRootViewXmlUI().forEach(print)
            }
        }
    }

    private func generateViewComponent() throws {
        let componentName = readString(title: "Enter view name:")
        let useReactantUI = readBool(title: "Are you using ReactantUI?")
        let workingDir = AbsolutePath(FileManager.default.currentDirectoryPath)

        shell(workingDir: workingDir.asString, "mkdir", componentName)

        try open(workingDir.appending(component: componentName).appending(component: "\(componentName).swift")) { print in
            component(componentName: componentName).forEach(print)
        }

        if useReactantUI {
            try open(workingDir.appending(component: componentName).appending(component: "\(componentName).ui.xml")) { print in
                componentXML().forEach(print)
            }
        }
    }
    
}
