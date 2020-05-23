//
//  PanelTabButtonFrame.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 23/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelTabButtonCell: NSButtonCell {
    
    let button: PanelTabButton
    
    init(button: PanelTabButton) {
        self.button = button
        super.init(textCell: button.title)
        setup()
    }
    
//    override init(textCell string: String) {
//        super.init(textCell: string)
//        setup()
//    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.isBordered = false
        self.backgroundStyle = .light
        self.highlightsBy = []
        self.lineBreakMode = .byTruncatingTail
        self.focusRingType = .none
    }
    
    override func draw(withFrame frame: NSRect, in controlView: NSView) {
        if !isHighlighted {
            NSColor(calibratedWhite: 0.9, alpha: 1).setFill()
        } else {
            NSColor.white.setFill()
        }
        
        frame.fill()
        
        NSColor(calibratedWhite: 0.75, alpha: 1).setFill()
        NSRect(x: frame.maxX-1, y: frame.minY, width: 1, height: frame.height).fill()
        
        // Top highlight
        NSColor.red.setFill()
        NSRect(x: frame.minX, y: frame.minY, width: frame.width, height: 2).fill()
        
        var titleAttrs: [NSAttributedString.Key: Any] = [:]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleAttrs[.paragraphStyle] = paragraphStyle
        
        if isHighlighted {
            titleAttrs[.foregroundColor] = NSColor.black
        }
        
        let titleFormat = NSAttributedString(string: self.title, attributes: titleAttrs)
        
        drawTitle(titleFormat, withFrame: frame, in: controlView)
    }
    
    override func cellSize(forBounds rect: NSRect) -> NSSize {
        print("cellSize \(button.frame.width) \(button.frame.height)")
        return NSSize(width: button.frame.width, height: button.frame.height)
    }
    
}
