//
//  Renderer+Observers.swift
//  Lormalized
//
//  Created by Reza Ali on 12/22/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Satin

extension Renderer {
#if os(macOS)
    func updateWindow()
    {
        guard _updateWindow, let window = self.mtkView.window else { return }
        let windowFrame = window.frame
        let finalHeight = CGFloat(self.windowSize.y)
        let originYOffset = windowFrame.height - finalHeight
        window.setFrame(NSRect(x: Int(self.windowPosition.x), y: Int(self.windowPosition.y) + Int(originYOffset), width: Int(self.windowSize.x), height: Int(self.windowSize.y)), display: true)
        _updateWindow = false
    }
    
    func updateWindowParams() {
        if let window = mtkView.window {
            let w = Int(window.frame.width)
            let h = Int(window.frame.height)
            let x = Int(window.frame.origin.x)
            let y = Int(window.frame.origin.y)
            
            if w != windowSize.x {
                windowSize.x = Int32(w)
            }
            
            if h != windowSize.y {
                windowSize.y = Int32(h)
            }
            
            if x != windowPosition.x {
                windowPosition.x = Int32(x)
            }
            
            if y != windowPosition.y {
                windowPosition.y = Int32(y)
            }
        }
    }
#endif
}
