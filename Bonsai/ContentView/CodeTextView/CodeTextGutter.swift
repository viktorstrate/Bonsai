//
//  LineNumberRulerView.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

// Class based on https://github.com/yichizhang/NSTextView-LineNumberView

import Cocoa

class CodeTextGutter: NSRulerView {
    
    var font: NSFont! {
        didSet {
            self.needsDisplay = true
        }
    }
    
    init(textView: NSTextView) {
        super.init(scrollView: textView.enclosingScrollView!, orientation: NSRulerView.Orientation.verticalRuler)
        self.font = textView.font ?? NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        self.clientView = textView
        
        self.ruleThickness = 40
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        NSColor.white.setFill()
        rect.fill()
        
        drawLineNumbers(in: rect)
    }
    

}
