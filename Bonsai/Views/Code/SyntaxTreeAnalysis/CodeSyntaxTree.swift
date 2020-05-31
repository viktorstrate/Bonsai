//
//  CodeSyntaxTree.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 27/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa
import SwiftTreeSitter

class CodeSyntaxTree {
    
    let textStorage: NSTextStorage
    
    var parser: STSParser?
    var highlightsQuery: STSQuery?
    var queryCursor: STSQueryCursor?
    var tree: STSTree!
    var theme: SyntaxHighlightTheme
    
    func detectLanguage(filetype: String) -> STSLanguage? {
        switch filetype {
        case "java":
            return try? STSLanguage(fromPreBundle: .java)
        case "js":
            return try? STSLanguage(fromPreBundle: .javascript)
        case "json":
            return try? STSLanguage(fromPreBundle: .json)
        default:
            return nil
        }
    }
    
    init(textStorage: NSTextStorage, document: CodeDocument) {
        self.textStorage = textStorage
        self.theme = SyntaxHighlightTheme()
        
        setupParser(document: document)
        
    }
    
    func setupParser(document: CodeDocument) {
        guard let filetype = document.fileURL?.pathExtension else {
            return
        }
        
        guard let language = detectLanguage(filetype: filetype) else {
            return
        }
        
        self.parser = STSParser()
        let parser = self.parser!
        
        parser.language = language
        
        tree = parser.parse(string: textStorage.string, oldTree: nil)
        
        highlightsQuery = try! STSQuery.loadBundledQuery(language: language, sourceType: .highlights)!
        queryCursor = STSQueryCursor()
        
        updateTextHighlight(in: nil)
    }
    
    func documentWasEdited(beginIndex: Int, with str: String, oldString: String) {
        
        guard let parser = self.parser else {
            return
        }
        
        let oldTree = self.tree.copy()
        
        let inputEdit = CodeSyntaxTree.getInputEdit(beginIndex: beginIndex, newString: str, oldString: oldString, documentString: textStorage.string as NSString)
        oldTree.edit(inputEdit)
        
        
        self.tree = parser.parse(string: textStorage.string, oldTree: nil)
        
        // Update syntax highlighting for changes nodes
        let changedRanges = STSTree.changedRanges(oldTree: oldTree, newTree: self.tree)
        
        textStorage.beginEditing()
        
        updateTextHighlight(in: NSRange(location: Int(inputEdit.startByte), length: Int(inputEdit.newEndByte-inputEdit.startByte)))
        
        for range in changedRanges {
            updateTextHighlight(in: NSRange(location: Int(range.startByte), length: Int(range.endByte - range.startByte)))
        }
        
        textStorage.endEditing()
        
    }
    
    fileprivate func updateTextHighlight(in range: NSRange?) {
        
        guard let queryCursor = self.queryCursor, let highlightsQuery = self.highlightsQuery else {
            return
        }
        
        if let range = range {
            queryCursor.setByteRange(from: uint(range.location), to: uint(NSMaxRange(range)))
            textStorage.addAttribute(.foregroundColor, value: NSColor.black, range: range)
        }
        
        let captures = queryCursor.captures(query: highlightsQuery, onNode: tree.rootNode)
        
        var loopCapture = captures.next()
        while loopCapture != nil {
            let capture = loopCapture!
            loopCapture = captures.next()
            
            let node = capture.node
            let captureName = highlightsQuery.captureName(forId: capture.index)
            
            let atts = theme.getAttributes(forCaptureName: captureName)
            
            let attributeRange = NSRange(location: Int(node.byteRange.lowerBound), length: Int(NSRange(node.byteRange).length))
            
            textStorage.addAttributes(atts, range: attributeRange)
            
            
        }
        
    }
    
}
