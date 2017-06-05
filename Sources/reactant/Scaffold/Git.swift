//
//  Git.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

func gitKeep() -> [String] {
    return []
}

func gitignore() -> [String] {
    return [
        "# Created by https://www.gitignore.io/api/swift,xcode,cocoapods",
        "Pods/",
        "",
        "build/",
        "DerivedData/",
        "",
        "*.pbxuser",
        "!default.pbxuser",
        "*.mode1v3",
        "!default.mode1v3",
        "*.mode2v3",
        "!default.mode2v3",
        "*.perspectivev3",
        "!default.perspectivev3",
        "xcuserdata/",
        "",
        "*.moved-aside",
        "*.xccheckout",
        "*.xcscmblueprint",
        "",
        "*.hmap",
        "*.ipa",
        "*.dSYM.zip",
        "*.dSYM",
        "",
        "timeline.xctimeline",
        "playground.xcworkspace",
        "",
        ".build/",
        "",
        "fastlane/report.xml",
        "fastlane/Preview.html",
        "fastlane/screenshots",
        "fastlane/test_output",
        "",
        "*.xcodeproj/*",
        "!*.xcodeproj/project.pbxproj",
        "!*.xcodeproj/xcshareddata/",
        "!*.xcworkspace/contents.xcworkspacedata",
        "/*.gcno",
        "*.generated.swift",
        ".DS_Store",
        "GeneratedUI.swift",
    ]
}
