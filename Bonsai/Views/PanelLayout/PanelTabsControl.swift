//
//  PanelTabsControl.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelTabsControl: NSControl, PanelTabButtonDelegate {
    
    let layoutPane: PanelLayoutPane
    
    private(set) var tabs: [CodeDocument: PanelTabButton] = [:]
    
    init(layoutPane: PanelLayoutPane) {
        self.layoutPane = layoutPane
        super.init(frame: NSRect())
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        layoutTabs()
    }
    
    func layoutTabs() {
        print("Layout tabs \(layoutPane.documents.count)")
        
        var offsetX = 0.0
        
        for document in layoutPane.documents {
            
            let activeDocument = document == layoutPane.activeDocument
            
            let tabFrame = NSRect(x: offsetX, y: 0, width: 100, height: 24)
            offsetX += 100
            
            let tab = tabs[document] ?? { () -> PanelTabButton in
                let tab = PanelTabButton()
                print("Making new tab")

                self.addSubview(tab)
                tab.translatesAutoresizingMaskIntoConstraints = false
                tab.delegate = self
                
                tabs[document] = tab
                
                return tab
            }()
            
            tab.frame = tabFrame
            tab.title = document.displayName
            tab.activeTab = activeDocument
            tab.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 0.85, alpha: 1).setFill()
        dirtyRect.fill()
    }
    
    func tabClicked(tab: PanelTabButton) {
        
        guard let document = tabs.first(where: { tab == $1 })?.key else {
            print("Didn't find document")
            return
        }
        
        layoutPane.activeDocument = document
    }
}
