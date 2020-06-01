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
    
    public convenience init() {
        self.init(frame: NSRect())
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.cell = PanelTabButtonCell(button: self)
        //self.target = self
        //self.action = #selector(onClick)
        
        let contextMenu = NSMenu()
        contextMenu.addItem(withTitle: "Close", action: #selector(closeTab), keyEquivalent: "")
        contextMenu.addItem(withTitle: "Close Others", action: #selector(closeOtherTabs), keyEquivalent: "")
        
        self.menu = contextMenu
        
    }
    
    override open func copy() -> Any {
        let copy = PanelTabButton(frame: self.frame)
        copy.activeTab = self.activeTab
        copy.isHighlighted = self.isHighlighted
        copy.title = self.title
        
        return copy
    }
    
    @objc func onClick() {
        print("onClick")
        delegate?.tabClicked(tab: self)
    }
    
    @objc func closeTab() {
        self.delegate?.closeTab(tab: self)
    }
    
    @objc func closeOtherTabs() {
        self.delegate?.closeOtherTabs(tab: self)
    }
    
    override func mouseDown(with event: NSEvent) {
        print("mouseDown")
        onClick()
        self.isHighlighted = true
        print("mouseDown end")
        self.delegate?.mouseDown(tab: self, withEvent: event)
        
        self.isHighlighted = false
    }
}

protocol PanelTabButtonDelegate {
    func tabClicked(tab: PanelTabButton)
    func closeTab(tab: PanelTabButton)
    func closeOtherTabs(tab: PanelTabButton)
    func mouseDown(tab: PanelTabButton, withEvent event: NSEvent)
}
