/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

// import Basic
// import POSIX
// import PackageGraph
// import PackageModel
// import PackageLoading
// import Utility

public struct XcodeprojOptions {
    /// The build flags.
    public let flags: BuildFlags

    /// If provided, a path to an xcconfig file to be included by the project.
    ///
    /// This allows the client to override settings defined in the project itself.
    public let xcconfigOverrides: AbsolutePath?

    /// Whether code coverage should be enabled in the generated scheme.
    public let isCodeCoverageEnabled: Bool

    public init(
        flags: BuildFlags = BuildFlags(),
        xcconfigOverrides: AbsolutePath? = nil,
        isCodeCoverageEnabled: Bool? = nil
    ) {
        self.flags = flags
        self.xcconfigOverrides = xcconfigOverrides
        self.isCodeCoverageEnabled = isCodeCoverageEnabled ?? false
    }
}

/// Generates an Xcode project and all needed support files.  The .xcodeproj
/// wrapper directory is created in the path specified by `outputDir`, basing
/// the file name on the project name `projectName`.  Returns the path of the
/// generated project.  All ancillary files will be generated inside of the
/// .xcodeproj wrapper directory.
func generate(
    config: ProjectConfiguration,
    options: XcodeprojOptions
) throws -> AbsolutePath {
    // Note that the output directory might be completely separate from the
    // path of the root package (which is where the sources live).

    // FIXME Escape the name
    let outputDir = config.workingDir.appending(config.outputDir)

    // Determine the path of the .xcodeproj wrapper directory.
    let xcodeprojName = "\(config.productName).xcodeproj"
    let xcodeprojPath = outputDir.appending(RelativePath(xcodeprojName))

    // Determine the path of the scheme directory (it's inside the .xcodeproj).
    let schemesDir = xcodeprojPath.appending(components: "xcshareddata", "xcschemes")

    // Create the .xcodeproj wrapper directory.
    try makeDirectories(outputDir)
    try makeDirectories(xcodeprojPath)
    try makeDirectories(schemesDir)

    let podfilePath = outputDir.appending(RelativePath("Podfile"))
    try open(podfilePath) { print in
        switch config.platform {
        case .iOS:
            print("platform :ios, '9.0'")
        case .macOS:
            print("platform :osx, '10.11'")
        }
        print("target '\(config.productName)' do")
        print("    use_frameworks!")
        switch config.platform {
        case .iOS:
            print("    pod 'Reactant', '~> 1.0'")
            if config.experimentalFeatures.contains(.xmlUI) {
                print("    pod 'ReactantUI'")
            }
            if config.experimentalFeatures.contains(.liveUI) {
                print("    pod 'ReactantLiveUI', :configuration => 'Debug'")
            }
            if config.experimentalFeatures.contains(.torch) {
                print("    pod 'TorchORM', :git => 'https://github.com/SwiftKit/Torch.git', :branch => 'swift-pm'")
            }
        case .macOS:
            print("    pod 'Reactant', :git => 'https://github.com/Brightify/Reactant.git', :branch => 'macos-new'")
        }

        print("end")
    }

//    let applicationDir = outputDir.appending(components: "Application")
//    let sourceDir = applicationDir.appending(component: "Source")
//    let generatedDir = applicationDir.appending(component: "Generated")
//    let resourceDir = applicationDir.appending(component: "Resource")
//
//    try makeDirectories(applicationDir)
//    try makeDirectories(sourceDir)
//    try makeDirectories(generatedDir)
//    try makeDirectories(resourceDir)

    for target in config.targets {
        for source in target.sources.items {
            let path = source.absolutePath(root: target.sources.root)
            try makeDirectories(path.parentDirectory)
            switch source.type {
            case .source(let content), .resource(let content), .file(let content):
                try open(path) { print in
                    print(content().joined(separator: "\n"))
                }
            case .sourceRef, .fileRef, .resourceRef:
                break
            case .directory:
                try open(path.parentDirectory.appending(component: ".gitkeep")) { print in
                    print("")
                }

            }
        }
    }

//    try open(generatedDir.appending(component: ".gitkeep")) { print in
//        print("")
//    }

//    if config.targets.contains(where: { $0.type == .unitTest }) {
//        try makeDirectories(outputDir.appending(component: "UnitTests"))
//    }
//    if config.targets.contains(where: { $0.type == .uiTest }) {
//        try makeDirectories(outputDir.appending(component: "UITests"))
//    }

    /// Generate the contents of project.xcodeproj (inside the .xcodeproj).
    try open(xcodeprojPath.appending(component: "project.pbxproj")) { stream in
        // FIXME: This could be more efficient by directly writing to a stream
        // instead of first creating a string.
        let str = try pbxproj(xcodeprojPath: xcodeprojPath,
                              config: config,
                              extraDirs: [],
                              options: options,
                              outputDir: outputDir)
        stream(str)
    }

    // The scheme acts like an aggregate target for all our targets it has all
    // tests associated so testing works.
    let schemeName = "\(config.productName).xcscheme"
    try open(schemesDir.appending(RelativePath(schemeName))) { stream in
        xcscheme(
            // FIXME relative(to: srcdir)
            container: xcodeprojPath.relative(to: outputDir).asString,
            config: config,
            printer: stream)
    }

    // We generate this file to ensure our main scheme is listed before any
    // inferred schemes Xcode may autocreate.
    try open(schemesDir.appending(component: "xcschememanagement.plist")) { print in
        print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
        print("<plist version=\"1.0\">")
        print("<dict>")
        print("  <key>SchemeUserState</key>")
        print("  <dict>")
        print("    <key>\(schemeName)</key>")
        print("    <dict></dict>")
        print("  </dict>")
        print("  <key>SuppressBuildableAutocreation</key>")
        print("  <dict></dict>")
        print("</dict>")
        print("</plist>")
    }

    for target in config.targets {
        ///// For framework targets, generate target.c99Name_Info.plist files in the
        ///// directory that Xcode project is generated
        let path = target.infoPlistPath
        try open(target.sources.root.appending(path)) { print in
            print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
            print("<plist version=\"1.0\">")
            print("<dict>")
            print("  <key>CFBundleDevelopmentRegion</key>")
            print("  <string>en</string>")
            print("  <key>CFBundleExecutable</key>")
            print("  <string>$(EXECUTABLE_NAME)</string>")
            print("  <key>CFBundleIdentifier</key>")
            print("  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>")
            print("  <key>CFBundleInfoDictionaryVersion</key>")
            print("  <string>6.0</string>")
            print("  <key>CFBundleName</key>")
            print("  <string>$(PRODUCT_NAME)</string>")
            print("  <key>CFBundleDisplayName</key>")
            print("  <string>\(target.name)</string>")
            print("  <key>CFBundlePackageType</key>")
            if target.isTest {
                print("  <string>BNDL</string>")
            } else {
                print("  <string>APPL</string>")
            }
            print("  <key>CFBundleShortVersionString</key>")
            print("  <string>1.0</string>")
            print("  <key>CFBundleSignature</key>")
            print("  <string>????</string>")
            print("  <key>CFBundleVersion</key>")
            print("  <string>1</string>")
            if !target.isTest {
                print("  <key>UILaunchStoryboardName</key>")
                print("  <string>LaunchScreen</string>")
                print("  <key>UIRequiredDeviceCapabilities</key>")
                print("  <array>")
                print("  <string>armv7</string>")
                print("  </array>")
                print("  <key>UISupportedInterfaceOrientations</key>")
                print("  <array>")
                print("  <string>UIInterfaceOrientationPortrait</string>")
                print("  <string>UIInterfaceOrientationLandscapeLeft</string>")
                print("  <string>UIInterfaceOrientationLandscapeRight</string>")
                print("  </array>")
                print("  <key>UISupportedInterfaceOrientations~ipad</key>")
                print("  <array>")
                print("  <string>UIInterfaceOrientationPortrait</string>")
                print("  <string>UIInterfaceOrientationPortraitUpsideDown</string>")
                print("  <string>UIInterfaceOrientationLandscapeLeft</string>")
                print("  <string>UIInterfaceOrientationLandscapeRight</string>")
                print("  </array>")
            }
//            print("  <key>NSPrincipalClass</key>")
//            print("  <string></string>")
            print("</dict>")
            print("</plist>")
        }
    }

    return xcodeprojPath
}
