import SwiftCLI

let cli = CLI(
    name: "reactant",
    version: "0.1",
    description: "Reactant CLI - Initialize Reactant projects in seconds!",
    commands: [
        InitCommand(),
        CreateComponentCommand()
    ])

cli.goAndExit()
