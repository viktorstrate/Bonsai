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
    
    let parser: STSParser
    let highlightsQuery: STSQuery
    let queryCursor: STSQueryCursor
    var tree: STSTree!
    
    init(textStorage: NSTextStorage) {
        self.textStorage = textStorage
        
        let language = try! STSLanguage(fromPreBundle: .javascript)
        
        parser = STSParser()
        parser.language = language
        
        tree = parser.parse(string: textStorage.string, oldTree: nil)
        
        highlightsQuery = try! STSQuery.loadBundledQuery(language: language, sourceType: .highlights)!
        queryCursor = STSQueryCursor()
        
        updateTextHighlight(in: nil)
        
    }
    
    func documentWasEdited(beginIndex: Int, with str: String, oldString: String) {
        
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
        
        if let range = range {
            queryCursor.setByteRange(from: uint(range.location), to: uint(NSMaxRange(range)))
            textStorage.addAttribute(.foregroundColor, value: NSColor.black, range: range)
        }
        
        let captures = queryCursor.captures(query: highlightsQuery, onNode: tree.rootNode)
        
        var syntaxForNodes: [STSNode: uint] = [:]
        
        var loopCapture = captures.next()
        while loopCapture != nil {
            let capture = loopCapture!
            
            syntaxForNodes[capture.node] = capture.index
            
            loopCapture = captures.next()
        }
        
        for (_, syntaxNode) in syntaxForNodes.enumerated() {
            
            let node = syntaxNode.key
            let captureId = syntaxNode.value
            
            let captureName = highlightsQuery.captureName(forId: captureId)
            
//            print("Node: \(node.byteRange)")
//            print("Syntax: \(captureName)")
            
            let foregroundColor: NSColor
            switch captureName {
            case "variable":
                //foregroundColor = NSColor(red: 0.141, green: 0.161, blue: 0.18, alpha: 1)
                foregroundColor = NSColor(red: 0.541, green: 0.161, blue: 0.18, alpha: 1)
            case "property":
                foregroundColor = NSColor(red: 0.435, green: 0.259, blue: 0.757, alpha: 1)
            case "string":
                foregroundColor = NSColor(red: 0.0118, green: 0.184, blue: 0.384, alpha: 1)
            case "number":
                foregroundColor = NSColor(red: 0, green: 0.361, blue: 0.773, alpha: 1)
            case "keyword":
                foregroundColor = NSColor(red: 0.843, green: 0.227, blue: 0.286, alpha: 1)
            case "comment":
                foregroundColor = NSColor(red: 0.416, green: 0.451, blue: 0.49, alpha: 1)
            default:
                foregroundColor = .black
            }
            
            var atts: [NSAttributedString.Key: Any] = [:]
            atts[.foregroundColor] = foregroundColor
            
            let attributeRange = NSRange(location: Int(node.byteRange.lowerBound), length: Int(NSRange(node.byteRange).length))
            
//            print("Attr range: \(attributeRange)")
//            print("String: '\(document.codeContent.contentString.string)'")
            
            textStorage.addAttributes(atts, range: attributeRange)
            
        }
        
        
    }
    
}
