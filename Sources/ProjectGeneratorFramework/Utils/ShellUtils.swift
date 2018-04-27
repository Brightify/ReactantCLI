//
//  ShellUtils.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

@discardableResult
public func shell(workingDir: String? = nil, _ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    if let workingDir = workingDir {
        task.currentDirectoryPath = workingDir
    }
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func shellOutput(workingDir: String?, _ args: String...) -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    if let workingDir = workingDir {
        task.currentDirectoryPath = workingDir
    }

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: String.Encoding.utf8) ?? ""

    return output
}

public var swiftVersion: String {
    let output = shellOutput(workingDir: nil, "swift", "--version")
    let version = output.components(separatedBy: " ")[3]
    let regex = try! NSRegularExpression(pattern: "\\d+\\.\\d+")
    if regex.matches(in: version, options: [], range: NSMakeRange(0, version.count)).isEmpty {
        fatalError("Unknown Swift version.")
    }
    return version
}

/// Writes the contents to the file specified.
///
/// This method doesn't rewrite the file in case the new and old contents of
/// file are same.
public func open(_ path: AbsolutePath, body: ((String) -> Void) throws -> Void) throws {
    // let stream = BufferedOutputByteStream()
    var lines = [] as [String]
    try body { line in
        lines.append(line + "\n")
    }
    // If the file exists with the identical contents, we don't need to rewrite it.
    //
    // This avoids unnecessarily triggering Xcode reloads of the project file.
    // if let contents = try? localFileSystem.readFileContents(path), contents == stream.bytes {
    //     return
    // }

    // Write the real file.
    // try localFileSystem.writeFileContents(path, bytes: stream.bytes)
    let data = lines.joined().data(using: .utf8)
    let url = URL(fileURLWithPath: path.asString)
    try data?.write(to: url)
}

/// Finds directories that will be added as blue folder
/// Excludes hidden directories, Xcode projects and reserved directories
//func findDirectoryReferences(path: AbsolutePath) throws -> [AbsolutePath] {
//    let rootDirectories = try walk(path, recursively: false)
//
//    return rootDirectories.filter({
//        if $0.suffix == ".xcodeproj" { return false }
//        if $0.suffix == ".playground" { return false }
//        if $0.basename.hasPrefix(".") { return false }
//        if PackageBuilder.isReservedDirectory(pathComponent: $0.basename) { return false }
//        return isDirectory($0)
//    })
//}
