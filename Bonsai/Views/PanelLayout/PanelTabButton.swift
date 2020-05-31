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
    
    var tabCell: PanelTabButtonCell {
        get {
            return self.cell! as! PanelTabButtonCell
        }
    }
    
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
        
        let contextMenu = NSMenu()
        contextMenu.addItem(withTitle: "Close", action: #selector(closeTab), keyEquivalent: "")
        contextMenu.addItem(withTitle: "Close Others", action: #selector(closeOtherTabs), keyEquivalent: "")
        
        self.menu = contextMenu
        
    }
    
    @objc func onClick() {
        delegate?.tabClicked(tab: self)
    }
    
    @objc func closeTab() {
        self.delegate?.closeTab(tab: self)
    }
    
    @objc func closeOtherTabs() {
        self.delegate?.closeOtherTabs(tab: self)
    }
}

protocol PanelTabButtonDelegate {
    func tabClicked(tab: PanelTabButton)
    func closeTab(tab: PanelTabButton)
    func closeOtherTabs(tab: PanelTabButton)
}
