//
//  Renderer+Observers.swift
//  Lormalized
//
//  Created by Reza Ali on 12/22/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Satin

extension Renderer {
    func updateBackground()
    {
        let c = self.bgColorParam.value
        let red = Double(c.x)
        let green = Double(c.y)
        let blue = Double(c.z)
        let alpha = Double(c.w)
        let clearColor: MTLClearColor = .init(red: red, green: green, blue: blue, alpha: alpha)
        self.renderer.clearColor = clearColor
    }
    
    func setupObservers() {
        let bgColorCb: (Float4Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self] _, _ in
            self.updateBackground()
        }
        observers.append(bgColorParam.observe(\.x, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.y, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.z, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.w, changeHandler: bgColorCb))
    }
}
