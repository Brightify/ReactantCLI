/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import Foundation

/// This file contains temporary shim functions for use during the adoption of
/// AbsolutePath and RelativePath.  The eventual plan is to use the FileSystem
/// API for all of this, at which time this file will go way.  But since it is
/// important to have a quality FileSystem API, we will evolve it slowly.
///
/// Meanwhile this file bridges the gap to let call sites be as clean as pos-
/// sible, while making it fairly easy to find those calls later.

/// Creates a new, empty directory at `path`.  If needed, any non-existent ancestor paths are also created.  If there is
/// already a directory at `path`, this function does nothing (in particular, this is not considered to be an error).
public func makeDirectories(_ path: AbsolutePath) throws {
    try FileManager.default.createDirectory(atPath: path.asString, withIntermediateDirectories: true, attributes: [:])
}

/// Recursively deletes the file system entity at `path`.  If there is no file system entity at `path`, this function
/// does nothing (in particular, this is not considered to be an error).
public func removeFileTree(_ path: AbsolutePath) throws {
    try FileManager.default.removeItem(atPath: path.asString)
}

/// The current working directory of the process (same as returned by POSIX' `getcwd()` function or Foundation's
/// `currentDirectoryPath` method).
/// FIXME: This should probably go onto `FileSystem`, under the assumption that each file system has its own notion of
/// the `current` working directory.
public var currentWorkingDirectory: AbsolutePath {
    let cwdStr = FileManager.default.currentDirectoryPath
    return AbsolutePath(cwdStr)
}

extension AbsolutePath {
    /// Returns a path suitable for display to the user (if possible, it is made
    /// to be relative to the current working directory).
    /// - Note: Therefore this function relies on the working directory's not
    /// changing during execution.
    public var prettyPath: String {
        let currDir = currentWorkingDirectory
        // FIXME: Instead of string prefix comparison we should add a proper API
        // to AbsolutePath to determine ancestry.
        if self == currDir {
            return "."
        } else if self.asString.hasPrefix(currDir.asString + "/") {
            return "./" + self.relative(to: currDir).asString
        } else {
            return self.asString
        }
    }
}

// FIXME: All of the following will move to the FileSystem class.

public enum FileAccessError: Swift.Error {
    case unicodeDecodingError
    case unicodeEncodingError
    case couldNotCreateFile(path: String)
    case fileDoesNotExist(path: String)
}

extension FileAccessError : CustomStringConvertible {
    public var description: String {
        switch self {
          case .unicodeDecodingError: return "Could not decode input file into unicode"
          case .unicodeEncodingError: return "Could not encode string into unicode"
          case .couldNotCreateFile(let path): return "Could not create file: \(path)"
          case .fileDoesNotExist(let path): return "File does not exist: \(path)"
        }
    }
}

public enum FopenMode: String {
    case read = "r"
    case write = "w"
}

public func fopen(_ path: AbsolutePath, mode: FopenMode = .read) throws -> FileHandle {
    let handle: FileHandle!
    switch mode {
      case .read: handle = FileHandle(forReadingAtPath: path.asString)
      case .write:
        let success = FileManager.default.createFile(atPath: path.asString, contents: nil)
        guard success else {
            throw FileAccessError.couldNotCreateFile(path: path.asString)
        }
        handle = FileHandle(forWritingAtPath: path.asString)
    }
    guard handle != nil else {
        throw FileAccessError.fileDoesNotExist(path: path.asString)
    }
    return handle
}

public func fopen<T>(_ path: AbsolutePath, mode: FopenMode = .read, body: (FileHandle) throws -> T) throws -> T {
    let fp = try fopen(path, mode: mode)
    defer { fp.closeFile() }
    return try body(fp)
}

public func fputs(_ string: String, _ handle: FileHandle) throws {
    guard let data = string.data(using: .utf8) else {
        throw FileAccessError.unicodeEncodingError
    }

    handle.write(data)
}

public func fputs(_ bytes: [UInt8], _ handle: FileHandle) throws {
    handle.write(Data(bytes: bytes))
}

extension FileHandle {
    public func readFileContents() throws -> String {
        guard let contents = String(data: readDataToEndOfFile(), encoding: .utf8) else {
            throw FileAccessError.unicodeDecodingError
        }
        return contents
    }
}
