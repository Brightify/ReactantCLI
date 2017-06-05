import SwiftCLI

CLI.setup(name: "reactant", version: "0.1", description: "Reactant CLI - Initialize Reactant projects in seconds!")

let initCommand = InitCommand()

CLI.register(command: initCommand)

let _ = CLI.go()
