//
//  CodeTextView.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeTextView: NSTextView {
    
    var gutterView: CodeTextGutter!
    
    init(document: CodeDocument) {
        let container = NSTextContainer()
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(container)
        
        let textStorage = CodeTextStorage(document: document)
        textStorage.addLayoutManager(layoutManager)
        
        super.init(frame: NSRect(), textContainer: container)
        
        self.textContainerInset = NSSize(width: 0, height: 10)
        self.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGutter() {
        if let scrollView = enclosingScrollView {
            gutterView = CodeTextGutter(textView: self)
            
            scrollView.verticalRulerView = gutterView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
            
            postsFrameChangedNotifications = true
            NotificationCenter.default.addObserver(self, selector: #selector(redrawGutter), name: NSView.frameDidChangeNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(redrawGutter), name: NSText.didChangeNotification, object: self)
        }
    }
    
    @objc func redrawGutter() {
        gutterView.needsDisplay = true
    }
    
}
