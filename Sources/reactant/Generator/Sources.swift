//
//  Sources.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

class Sources {
    let items: [Source]
    let root: AbsolutePath

    init(items: [Source], root: AbsolutePath) {
        // FIXME Do we want the sort? [Probably not]
        self.items = items //.sorted(by: { $0.path.asString < $1.path.asString })
        self.root = root
    }
}
