//
//  Wireframe.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public func applicationWireframe() -> [String] {
    return [
        "import UIKit",
        "import Reactant",
        "",
        "final class ApplicationWireframe {",
        "    private let module: ApplicationModule",
        "",
        "    init(module: ApplicationModule) {",
        "        self.module = module",
        "    }",
        "",
        "    func entrypoint() -> UIViewController {",
        "        return mainWire(context: MainWireframe.Context()).entrypoint()",
        "    }",
        "",
        "    private func mainWire(context: MainWireframe.Context) -> MainWireframe {",
        "        return MainWireframe(module: module, context: context, wires: MainWireframe.Wires())",
        "    }",
        "}"
    ]
}

public func mainWireframe() -> [String] {
    return [
        "import UIKit",
        "import Reactant",
        "",
        "protocol MainDependencyModule {",
        "}",
        "",
        "final class MainWireframe: Wireframe {",
        "    struct Context {",
        "    }",
        "    struct Wires {",
        "    }",
        "",
        "    private let module: MainDependencyModule",
        "    private let context: Context",
        "    private let wires: Wires",
        "",
        "    init(module: MainDependencyModule, context: Context, wires: Wires) {",
        "        self.module = module",
        "        self.context = context",
        "        self.wires = wires",
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


