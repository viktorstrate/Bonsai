//
//  PanelTabsControl.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelTabsControl: NSControl {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    fileprivate func setup() {
        layoutTabs()
    }
    
    fileprivate func layoutTabs() {
        let tab = PanelTabButton()
        
        self.addSubview(tab)
        tab.translatesAutoresizingMaskIntoConstraints = false
        
        let tabFrame = NSRect(x: 0, y: 0, width: 100, height: 24)
        tab.frame = tabFrame
        tab.needsLayout = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 0.85, alpha: 1).setFill()
        dirtyRect.fill()
    }
}
