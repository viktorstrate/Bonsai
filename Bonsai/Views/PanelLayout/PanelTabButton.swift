//
//  PanelTabButton.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelTabButton: NSButton {
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    fileprivate func setup() {
        self.cell = PanelTabButtonCell(button: self)
    }
}
