//
//  CodeTextView.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeTextView: NSTextView {
    
    var lineNumberView: LineNumberRulerView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerLineNumbers()
    }
    
    func registerLineNumbers() {
        if let scrollView = enclosingScrollView {
            lineNumberView = LineNumberRulerView(textView: self)
            
            scrollView.verticalRulerView = lineNumberView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
            
            postsFrameChangedNotifications = true
            NotificationCenter.default.addObserver(self, selector: #selector(updateLineNumbers), name: NSView.frameDidChangeNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(updateLineNumbers), name: NSText.didChangeNotification, object: self)
        }
    }
    
    @objc func updateLineNumbers() {
        lineNumberView.needsDisplay = true
    }
    
}
