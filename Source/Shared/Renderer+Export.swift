//
//  Renderer+Export.swift
//  Stargaze
//
//  Created by Reza Ali on 8/27/21.
//  Copyright © 2021 Reza Ali. All rights reserved.
//

import Foundation
import Satin

extension Renderer {
    public func exportImage(_ url: URL) -> Bool {
        let tiler = Tiler(renderer: renderer, commandQueue: commandQueue, mtkView: mtkView, scale: exportScaleParam.value)
        return tiler.export(exportURL: url)
    }
}
