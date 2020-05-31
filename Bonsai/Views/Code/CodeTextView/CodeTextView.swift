//
//  CodeTextView.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeTextView: NSTextView, NSTextStorageDelegate {
    
    var gutterView: CodeTextGutter?
    var syntaxTree: CodeSyntaxTree!
    var document: CodeDocument!
    
    func setup(document: CodeDocument) {
        self.document = document
        document.codeTextView = self
        
        self.syntaxTree = CodeSyntaxTree(textStorage: self.textStorage!, document: document)
        self.textStorage!.delegate = self
        
        self.textContainerInset = NSSize(width: 0, height: 10)
        self.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        
        self.allowsUndo = true
        
        self.isAutomaticDataDetectionEnabled = false
        self.isAutomaticLinkDetectionEnabled = false
        self.isAutomaticTextCompletionEnabled = false
        self.isAutomaticTextReplacementEnabled = false
        self.isAutomaticDashSubstitutionEnabled = false
        self.isAutomaticQuoteSubstitutionEnabled = false
        self.isAutomaticSpellingCorrectionEnabled = false
        
        setupGutter()
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
        gutterView?.needsDisplay = true
    }
    
    var oldStr: String = ""
    var newStr: String = ""
    
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        oldStr = (self.string as NSString).substring(with: affectedCharRange)
        newStr = replacementString ?? ""
        return super.shouldChangeText(in: affectedCharRange, replacementString: replacementString)
    }
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if editedMask.contains(.editedCharacters) {
            syntaxTree.documentWasEdited(beginIndex: editedRange.location,
                                         with: newStr, oldString: oldStr)
        }
        
    }
    
}
