//
//  PanelTabButton.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelTabButton: NSButton {
    
    var activeTab: Bool = false
    
    var delegate: PanelTabButtonDelegate?
    
    public init() {
        super.init(frame: NSRect())
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.cell = PanelTabButtonCell(button: self)
        self.target = self
        self.action = #selector(onClick)
    }
    
    @objc func onClick() {
        print("Tab clicked")
        delegate?.tabClicked(tab: self)
    }
}

protocol PanelTabButtonDelegate {
    func tabClicked(tab: PanelTabButton)
}
