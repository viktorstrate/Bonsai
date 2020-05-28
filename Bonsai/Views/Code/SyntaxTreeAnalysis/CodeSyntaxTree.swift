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
    
    let document: CodeDocument
    
    let parser: STSParser
    let highlightsQuery: STSQuery
    let queryCursor: STSQueryCursor
    var tree: STSTree!
    
    init(document: CodeDocument) {
        self.document = document
        
        let language = try! STSLanguage(fromPreBundle: .javascript)
        
        parser = STSParser()
        parser.language = language
        
        tree = parser.parse(string: document.codeContent.contentString.string, oldTree: nil)
        
        highlightsQuery = try! STSQuery.loadBundledQuery(language: language, sourceType: .highlights)!
        queryCursor = STSQueryCursor()
        
        updateTextHighlight(in: nil)
        
    }
    
    func documentWasEdited(beginIndex: Int, with str: String, oldString: String) {
        
        let oldTree = self.tree.copy()
        
        let inputEdit = CodeSyntaxTree.getInputEdit(beginIndex: beginIndex, newString: str, oldString: oldString, documentString: document.codeContent.contentString.string as NSString)
        oldTree.edit(inputEdit)
        
        
        self.tree = parser.parse(string: document.codeContent.contentString.string, oldTree: nil)
    }
    
    func updateTextHighlight(in range: NSRange?) {
        
        document.codeContent.contentString.beginEditing()
        
        if let range = range {
            queryCursor.setByteRange(from: uint(range.location), to: uint(NSMaxRange(range)))
            
            document.codeContent.contentString.addAttribute(.foregroundColor, value: NSColor.black, range: range)
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
                foregroundColor = NSColor(red: 0.141, green: 0.161, blue: 0.18, alpha: 1)
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
            
            document.codeContent.contentString.addAttributes(atts, range: attributeRange)
            
        }
        
        document.codeContent.contentString.endEditing()
        
    }
    
}
