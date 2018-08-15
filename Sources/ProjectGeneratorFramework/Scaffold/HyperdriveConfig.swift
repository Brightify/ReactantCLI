//
//  HyperdriveConfig.swift
//  ProjectGeneratorFramework
//
//  Created by Matouš Hýbl on 15/08/2018.
//

import Foundation

public func hyperdriveConfig() -> [String] {
    return [
        "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>",
        "<Application>",
        "   <Themes default=\"dark\">",
        "       <dark />",
        "       <light />",
        "   </Themes>",
        "",
        "   <Colors>",
        "       <dark",
        "           background=\"black\"",
        "       />",
        "       <light",
        "           background=\"white\"",
        "       />",
        "       <shared",
        "           accent=\"#FFC500\"",
        "       />",
        "   </Colors>",
        "",
        "   <Images>",
        "       <shared />",
        "   </Images>",
        "",
        "   <Fonts>",
        "       <shared />",
        "   </Fonts>",
        "</Application>",
    ]
}
