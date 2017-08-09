//
//  Wireframe.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public func mainWireframe() -> [String] {
    return [
        "import UIKit",
        "import Reactant",
        "",
        "final class MainWireframe: Wireframe {",
        "    private let module: DependencyModule",
        "",
        "    init(module: DependencyModule) {",
        "        self.module = module",
        "    }",
        "",
        "    func entrypoint() -> UIViewController {",
        "        let mainController = main()",
        "        return UINavigationController(rootViewController: mainController)",
        "    }",
        "",
        "    private func main() -> MainController {",
        "        return create { provider in",
        "            return MainController()",
        "        }",
        "    }",
        "}",
    ]
}
