//
//  Model.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public func sampleTorchModel() -> [String] {
    return [
        "import Torch",
        "",
        "struct SampleModel: TorchEntity {",
        "",
        "   var id: Int?",
        "   var name: String",
        "}",
    ]
}

public func sampleModel() -> [String] {
    return [
        "import Foundation",
        "",
        "struct SampleModel {",
        "",
        "   var id: Int?",
        "   var name: String",
        "}",
    ]
}
