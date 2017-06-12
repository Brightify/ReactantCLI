import SwiftCLI

CLI.setup(name: "reactant", version: "0.1", description: "Reactant CLI - Initialize Reactant projects in seconds!")

let initCommand = InitCommand()
let createComponentCommand = CreateComponentCommand()

CLI.register(command: initCommand)
CLI.register(command: createComponentCommand)

let _ = CLI.go()
