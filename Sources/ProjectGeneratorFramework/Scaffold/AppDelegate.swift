//
//  AppDelegate.swift
//  ReactantCLI
//
//  Created by Matous Hybl on 6/5/17.
//
//

import Foundation

public func appDelegate(experimentalFeatures: Set<ExperimentalFeatures>) -> () -> [String] {
    return {
        [
            "import UIKit",
            "import Reactant",
            "",
            "@UIApplicationMain",
            "class AppDelegate : UIResponder, UIApplicationDelegate {",
            "    var window : UIWindow?",
            "",
            "    private let module = ApplicationModule()",
            "",
            "    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {",
            experimentalFeatures.contains(.xmlUI) ?
                "        Configuration.global.set(Properties.Style.controllerRoot, to: GeneralStyles.controllerRootView)" :
            "        Configuration.global.set(Properties.Style.controllerRoot) { $0.backgroundColor = .white }",
            "",
            "        let window = UIWindow()",
            "        let wireframe = MainWireframe(module: module)",
            "        window.rootViewController = wireframe.entrypoint()",
            "        window.makeKeyAndVisible()",
            "        self.window = window",
            experimentalFeatures.contains(.liveUI) ?
                "        activateLiveReload(in: window)" :
            "",
            "        return true",
            "    }",
            "}",
            ]
    }
}
