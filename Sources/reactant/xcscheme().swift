/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

// import PackageGraph
// import PackageModel

func xcscheme(container: String, config: ProjectConfiguration, printer print: (String) -> Void) {
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    print("<Scheme LastUpgradeVersion = \"9999\" version = \"1.3\">")
    print("  <BuildAction parallelizeBuildables = \"YES\" buildImplicitDependencies = \"YES\">")
    print("    <BuildActionEntries>")

    // Create buildable references for non-test targets.
    for target in config.targets where !target.isTest {
        print("      <BuildActionEntry buildForTesting = \"YES\" buildForRunning = \"YES\" buildForProfiling = \"YES\" buildForArchiving = \"YES\" buildForAnalyzing = \"YES\">")
        print("        <BuildableReference")
        print("          BuildableIdentifier = \"primary\"")
        print("          BuildableName = \"\(target.buildableName)\"")
        print("          BlueprintName = \"\(target.blueprintName)\"")
        print("          ReferencedContainer = \"container:\(container)\">")
        print("        </BuildableReference>")
        print("      </BuildActionEntry>")
    }

    print("    </BuildActionEntries>")
    print("  </BuildAction>")
    print("  <TestAction")
    print("    buildConfiguration = \"Debug\"")
    print("    selectedDebuggerIdentifier = \"Xcode.DebuggerFoundation.Debugger.LLDB\"")
    print("    selectedLauncherIdentifier = \"Xcode.DebuggerFoundation.Launcher.LLDB\"")
    print("    shouldUseLaunchSchemeArgsEnv = \"YES\"")
    print("    codeCoverageEnabled = \"NO\">")
    print("    <Testables>")

    // Create testable references.
    for target in config.targets where target.isTest {
        print("    <TestableReference")
        print("      skipped = \"NO\">")
        print("      <BuildableReference")
        print("        BuildableIdentifier = \"primary\"")
        print("        BuildableName = \"\(target.buildableName)\"")
        print("        BlueprintName = \"\(target.blueprintName)\"")
        print("        ReferencedContainer = \"container:\(container)\">")
        print("      </BuildableReference>")
        print("    </TestableReference>")
    }

    print("    </Testables>")
    print("  </TestAction>")

    for target in config.targets where !target.isTest {
        print("<LaunchAction")
        print("   buildConfiguration = \"Debug\"")
        print("   selectedDebuggerIdentifier = \"Xcode.DebuggerFoundation.Debugger.LLDB\"")
        print("   selectedLauncherIdentifier = \"Xcode.DebuggerFoundation.Launcher.LLDB\"")
        print("   launchStyle = \"0\"")
        print("   useCustomWorkingDirectory = \"NO\"")
        print("   ignoresPersistentStateOnLaunch = \"NO\"")
        print("   debugDocumentVersioning = \"YES\"")
        print("   debugServiceExtension = \"internal\"")
        print("   allowLocationSimulation = \"YES\">")
        print("   <BuildableProductRunnable")
        print("      runnableDebuggingMode = \"0\">")
        print("      <BuildableReference")
        print("         BuildableIdentifier = \"primary\"")
        print("         BlueprintIdentifier = \"1870A4731D75BD5600B3E7EB\"")
        print("         BuildableName = \"\(target.buildableName)\"")
        print("         BlueprintName = \"\(target.blueprintName)\"")
        print("         ReferencedContainer = \"container:\(container)\">")
        print("      </BuildableReference>")
        print("   </BuildableProductRunnable>")
        print("   <EnvironmentVariables>")
        print("      <EnvironmentVariable")
        print("         key = \"animations\"")
        print("         value = \"0\"")
        print("         isEnabled = \"NO\">")
        print("      </EnvironmentVariable>")
        print("   </EnvironmentVariables>")
        print("   <AdditionalOptions>")
        print("   </AdditionalOptions>")
        print("</LaunchAction>")
        print("<ProfileAction")
        print("   buildConfiguration = \"Debug\"")
        print("   shouldUseLaunchSchemeArgsEnv = \"YES\"")
        print("   savedToolIdentifier = \"\"")
        print("   useCustomWorkingDirectory = \"NO\"")
        print("   debugDocumentVersioning = \"YES\">")
        print("   <BuildableProductRunnable")
        print("      runnableDebuggingMode = \"0\">")
        print("      <BuildableReference")
        print("         BuildableIdentifier = \"primary\"")
        print("         BlueprintIdentifier = \"1870A4731D75BD5600B3E7EB\"")
        print("         BuildableName = \"\(target.buildableName)\"")
        print("         BlueprintName = \"\(target.blueprintName)\"")
        print("         ReferencedContainer = \"container:\(container)\">")
        print("      </BuildableReference>")
        print("   </BuildableProductRunnable>")
        print("</ProfileAction>")
        print("<AnalyzeAction")
        print("   buildConfiguration = \"Debug\">")
        print("</AnalyzeAction>")
        print("<ArchiveAction")
        print("   buildConfiguration = \"Release\"")
        print("   revealArchiveInOrganizer = \"YES\">")
        print("</ArchiveAction>")
    }
    /*


 */
    print("</Scheme>")
}
