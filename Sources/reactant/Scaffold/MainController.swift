//
//  MainController.swift
//  ReactantCLI
//
//  Created by Tadeas Kriz on 5/13/17.
//
//

import Foundation

func launchScreen() -> [String] {
    return [
        "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>",
        "<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"11134\" systemVersion=\"15F34\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\"", "launchScreen=\"YES\" useTraitCollections=\"YES\" colorMatched=\"YES\" initialViewController=\"01J-lp-oVM\">",
        "    <dependencies>",
        "        <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"11106\"/>",
        "        <capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>",
        "    </dependencies>",
        "    <scenes>",
        "        <!--View Controller-->",
        "        <scene sceneID=\"EHf-IW-A2E\">",
        "            <objects>",
        "                <viewController id=\"01J-lp-oVM\" sceneMemberID=\"viewController\">",
        "                    <layoutGuides>",
        "                        <viewControllerLayoutGuide type=\"top\" id=\"Llm-lL-Icb\"/>",
        "                        <viewControllerLayoutGuide type=\"bottom\" id=\"xb3-aO-Qok\"/>",
        "                    </layoutGuides>",
        "                    <view key=\"view\" contentMode=\"scaleToFill\" id=\"Ze5-6b-2t3\">",
        "                        <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"375\" height=\"667\"/>",
        "                        <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>",
        "                        <color key=\"backgroundColor\" red=\"1\" green=\"1\" blue=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"sRGB\"/>",
        "                    </view>",
        "                </viewController>",
        "                <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"iYj-Kq-Ea1\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>",
        "            </objects>",
        "            <point key=\"canvasLocation\" x=\"53\" y=\"375\"/>",
        "        </scene>",
        "    </scenes>",
        "</document>",
    ]
}

func mainController() -> [String] {
    return [
        "import Reactant",
        "",
        "final class MainController: ControllerBase<Void, MainRootView> {",
        "}"
    ]
}

func mainRootView() -> [String] {
    return [
        "import Reactant",
        "",
        "final class MainRootView: ViewBase<Void, Void>, RootView {",
        "    private let label = UILabel(text: \"Hello World!\")",
        "",
        "    override func loadView() {",
        "        children(",
        "            label",
        "        )",
        "    }",
        "",
        "    override func setupConstraints() {",
        "        label.snp.makeConstraints { make in",
        "            make.center.equalToSuperview()",
        "        }",
        "    }",
        "}"
    ]
}

func mainRootViewXml() -> [String] {
    return [
        "import Reactant",
        "",
        "final class MainRootView: ViewBase<Void, Void> {",
        "}"
    ]
}

func mainRootViewXmlUI() -> [String] {
    return [
        "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>",
        "<Component",
        "    xmlns=\"http://schema.reactant.tech/ui\"",
        "    xmlns:layout=\"http://schema.reactant.tech/layout\"",
        "    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"",
        "    xsi:schemaLocation=\"http://schema.reactant.tech/ui https://schema.reactant.tech/ui.xsd",
        "                        http://schema.reactant.tech/layout https://schema.reactant.tech/layout.xsd\"",
        "    rootView=\"true\">",
        "",
        "    <Label",
        "        text=\"Hello World!\"",
        "        layout:center=\"super\" />",
        "</Component>",
    ]
}

func dependencyModule() -> [String] {
    return [
        "protocol DependencyModule {",
        "}",
    ]
}

func applicationModule() -> [String] {
    return [
        "final class ApplicationModule: DependencyModule {",
        "}",
    ]
}

func gitKeep() -> [String] {
    return []
}

func assetsJson() -> [String] {
    return [
        "{",
        "    \"info\" : {",
        "        \"version\" : 1,",
        "        \"author\" : \"xcode\"",
        "    }",
        "}",
    ]
}

func appIconJson() -> [String] {
    return [
        "{",
        "  \"images\" : [",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"20x20\",",
        "      \"scale\" : \"2x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"20x20\",",
        "      \"scale\" : \"3x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"29x29\",",
        "      \"scale\" : \"1x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"29x29\",",
        "      \"scale\" : \"2x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"29x29\",",
        "      \"scale\" : \"3x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"40x40\",",
        "      \"scale\" : \"2x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"40x40\",",
        "      \"scale\" : \"3x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"57x57\",",
        "      \"scale\" : \"1x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"57x57\",",
        "      \"scale\" : \"2x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"60x60\",",
        "      \"scale\" : \"2x\"",
        "    },",
        "    {",
        "      \"idiom\" : \"iphone\",",
        "      \"size\" : \"60x60\",",
        "      \"scale\" : \"3x\"",
        "    }",
        "  ],",
        "  \"info\" : {",
        "    \"version\" : 1,",
        "    \"author\" : \"xcode\"",
        "  }",
        "}",
    ]
}

func mainWireframe() -> [String] {
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

func generalStyles() -> [String] {
    return [
        "<styleGroup name=\"general\">",
        "    <ViewStyle name=\"controllerRootView\" backgroundColor=\"white\"/>",
        "</styleGroup>",
    ]
}

func appDelegate(experimentalFeatures: Set<ExperimentalFeatures>) -> () -> [String] {
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

func sampleTorchModel() -> [String] {
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

func sampleService() -> [String] {
    return [
        "import Foundation",
        "",
        "struct SampleService { }",
    ]
}
