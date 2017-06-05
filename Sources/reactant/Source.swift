//
//  Source.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

struct Source {
    enum Kind {
        case source(() -> [String])
        case sourceRef
        case resource(() -> [String])
        case resourceRef
        case directory
        case fileRef
        case file(() -> [String])
    }

    let path: RelativePath
    let type: Kind
    let ignoreXcode: Bool

    init(path: String, type: Kind, ignoreXcode: Bool = false) {
        self.path = RelativePath(path)
        self.type = type
        self.ignoreXcode = ignoreXcode
    }

    func absolutePath(root: AbsolutePath) -> AbsolutePath {
        return root.appending(path)
    }
}
