//
//  MainController.swift
//  ReactantCLI
//
//  Created by Tadeas Kriz on 5/13/17.
//
//

import Foundation

func mainController() -> [String] {
    return controller()
}

func controller(controllerName: String = "MainController", rootViewName: String = "MainRootView") -> [String] {
    return [
        "import Reactant",
        "",
        "final class \(controllerName): ControllerBase<Void, \(rootViewName)> {",
        "}"
    ]
}

func mainRootView() -> [String] {
    return rootView()
}

func rootView(rootViewName: String = "MainRootView") -> [String] {
    return [
        "import Reactant",
        "",
        "final class \(rootViewName): ViewBase<Void, Void>, RootView {",
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

func component(componentName: String = "MainRootView") -> [String] {
    return [
        "import Reactant",
        "",
        "final class \(componentName): ViewBase<Void, Void> {",
        "}"
    ]
}

func componentXML() -> [String] {
    return [
        "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>",
        "<Component",
        "    xmlns=\"http://schema.reactant.tech/ui\"",
        "    xmlns:layout=\"http://schema.reactant.tech/layout\"",
        "    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"",
        "    xsi:schemaLocation=\"http://schema.reactant.tech/ui https://schema.reactant.tech/ui.xsd",
        "                        http://schema.reactant.tech/layout https://schema.reactant.tech/layout.xsd\">",
        "",
        "    <Label",
        "        text=\"Hello World!\"",
        "        layout:center=\"super\" />",
        "</Component>",
    ]
}

func mainRootViewXml() -> [String] {
    return componentXML()
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

func generalStyles() -> [String] {
    return [
        "<styleGroup name=\"general\">",
        "    <ViewStyle name=\"controllerRootView\" backgroundColor=\"white\"/>",
        "</styleGroup>",
    ]
}
