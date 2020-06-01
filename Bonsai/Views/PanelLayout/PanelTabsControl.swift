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
    
    private(set) var tabs: [CodeViewController: PanelTabButton] = [:]
    
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
    
    func layoutTabs(animated: Bool = false) {
        print("Layout tabs \(layoutPane.codeControllers.count)")
        
        var offsetX = 0.0
        
        // Remove old tabs
        tabs.keys
            .filter { !layoutPane.codeControllers.contains($0) }
            .forEach {
                print("Removing tab")
                tabs[$0]?.removeFromSuperview()
                tabs.removeValue(forKey: $0)
            }
        
        for codeController in layoutPane.codeControllers {
            
            let document = codeController.document
            
            let activeDocument = document == layoutPane.activeDocument
            
            let tab = tabs[codeController] ?? { () -> PanelTabButton in
                let tab = PanelTabButton()
                print("Making new tab")

                self.addSubview(tab)
                tab.translatesAutoresizingMaskIntoConstraints = false
                tab.delegate = self
                
                tabs[codeController] = tab
                
                return tab
            }()
            
            let buttonWidth = max(Double(tab.tabCell.formattedTitle().size().width) + 24, 100)
            let tabFrame = NSRect(x: offsetX, y: 0, width: buttonWidth, height: 24)
            offsetX += buttonWidth
            
            if animated {
                tab.animator().frame = tabFrame
            } else {
                tab.frame = tabFrame
            }
            
            
            tab.title = document.displayName
            tab.activeTab = activeDocument
            tab.needsDisplay = true
        }
    }
    
    func reorderTab(_ tab: PanelTabButton, withEvent event: NSEvent) {
        
        let dragPoint = self.convert(event.locationInWindow, from: nil)
        let startX = NSMinX(tab.frame)
        
        var prevPoint = dragPoint
        var reordered = false
        
        let draggingCodeController: CodeViewController! = tabs.first { $1 == tab }?.key
        
        let draggingTab = tab.copy() as! PanelTabButton
        self.addSubview(draggingTab)
        tab.isHidden = true
        
        while(true) {
            let mask = NSEvent.EventTypeMask.leftMouseUp.union(NSEvent.EventTypeMask.leftMouseDragged)
            let event = self.window!.nextEvent(matching: mask)!
            
            if event.type == .leftMouseUp {
                print("Done")
//                tab.isHidden = false
                
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.completionHandler = {
                    tab.isHidden = false
                    draggingTab.removeFromSuperview()
                }
                
                draggingTab.animator().frame = tab.frame
                
                NSAnimationContext.endGrouping()
                
                
                break
            }
            
            let nextPoint = self.convert(event.locationInWindow, from: nil)
            let nextX = startX + (nextPoint.x - dragPoint.x)
            
            var newFrame = draggingTab.frame
            newFrame.origin.x = nextX
            draggingTab.frame = newFrame
            
            let draggingIndex: Int! = layoutPane.codeControllers
                .firstIndex { $0 == draggingCodeController }
            
            var swappingIndex: Int?
            
            let draggingLeft = nextPoint.x < dragPoint.x
            
            if draggingLeft && draggingIndex > 0 {
                let leftTab: PanelTabButton! = tabs[layoutPane.codeControllers[draggingIndex-1]]
                if NSMidX(draggingTab.frame) < NSMidX(leftTab.frame) {
                    swappingIndex = draggingIndex-1
                }
            }
            
            if !draggingLeft && draggingIndex < layoutPane.codeControllers.count-1 {
                let rightTab: PanelTabButton! = tabs[layoutPane.codeControllers[draggingIndex+1]]
                if NSMidX(draggingTab.frame) > NSMidX(rightTab.frame) {
                    swappingIndex = draggingIndex+1
                }
            }
            
            if let swappingIndex = swappingIndex {
                print("Swapping \(draggingIndex) \(swappingIndex)")
                layoutPane.codeControllers.swapAt(draggingIndex, swappingIndex)
                layoutTabs(animated: true)
            }
            
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 0.85, alpha: 1).setFill()
        dirtyRect.fill()
    }
    
    func tabClicked(tab: PanelTabButton) {
        
        guard let codeController = tabs.first(where: { tab == $1 })?.key else {
            print("Didn't find document")
            return
        }
        
        layoutPane.activeDocument = codeController.document
    }
    
    func closeTab(tab: PanelTabButton) {
        guard let codeController = tabs.first(where: { tab == $1 })?.key else {
            print("Didn't find document")
            return
        }
        
        layoutPane.removeDocument(codeController.document)
    }
    
    func closeOtherTabs(tab: PanelTabButton) {

        tabs.filter { $1 != tab }
            .keys
            .map { $0.document }
            .forEach { (document) in
                layoutPane.removeDocument(document)
            }
        
    }
    
    func mouseDown(tab: PanelTabButton, withEvent event: NSEvent) {
        
        let mask = NSEvent.EventTypeMask.leftMouseUp.union(NSEvent.EventTypeMask.leftMouseDragged)
        
        print("Reading next event")
        guard let event = self.window?.nextEvent(
            matching: mask, until: .distantFuture, inMode: .eventTracking, dequeue: false)
            , event.type == .leftMouseDragged else {
                return
        }
        
        print("Reorder tab")
        reorderTab(tab, withEvent: event)
    }
}
