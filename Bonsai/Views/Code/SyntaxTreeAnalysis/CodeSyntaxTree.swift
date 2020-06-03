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
    var injectsQuery: STSQuery?
    var tree: STSTree!
    var subtrees: [STSTree] = []
    var theme: SyntaxHighlightTheme
    
    func detectLanguage(filetype: String) -> STSLanguage? {
        switch filetype {
        case "css":
            return try? STSLanguage(fromPreBundle: .css)
        case "html":
            return try? STSLanguage(fromPreBundle: .html)
        case "java":
            return try? STSLanguage(fromPreBundle: .java)
        case "js", "javascript":
            return try? STSLanguage(fromPreBundle: .javascript)
        case "json":
            return try? STSLanguage(fromPreBundle: .json)
        case "php":
            return try? STSLanguage(fromPreBundle: .php)
        default:
            return nil
        }
    }
    
    init(textStorage: NSTextStorage, document: CodeDocument) {
        self.textStorage = textStorage
        self.theme = SyntaxHighlightTheme()
        
        initialParse(document: document)
        
    }
    
    func initialParse(document: CodeDocument) {
        guard let filetype = document.fileURL?.pathExtension else {
            return
        }
        
        guard let language = detectLanguage(filetype: filetype) else {
            return
        }
        
        self.parser = STSParser(language: language)
        let parser = self.parser!
        
        tree = parser.parse(string: textStorage.string, oldTree: nil)
        
        highlightsQuery = try! STSQuery.loadBundledQuery(language: language, sourceType: .highlights)!
        injectsQuery = try! STSQuery.loadBundledQuery(language: language, sourceType: .injections)
        
        if let highlightsQuery = highlightsQuery {
            updateTextHighlight(query: highlightsQuery, tree: tree, in: nil)
        }
        
        parseSubtrees(in: nil)
        
    }
    
    func parseSubtrees(in range: NSRange?) {
        
        guard let injectsQuery = self.injectsQuery, let tree = self.tree else {
            return
        }
        
        let subCursor: STSQueryCursor
        
        if let range = range {
            print("Subtrees range: \(range)")
            subCursor = STSQueryCursor(byteRangeFrom: uint(range.location), to: uint(NSMaxRange(range)))
        } else {
            subCursor = STSQueryCursor()
        }
        
        
        let matches = subCursor.matches(query: injectsQuery, onNode: tree.rootNode)
        for match in matches {
            
            
            let predicates = injectsQuery.predicates(forPatternIndex: match.index)
            let injectLangPred = predicates.first { $0.name == "set!" && $0.args.first == STSQueryPredicateArg.string("injection.language") }
            
            guard case let .string(languageStr) = injectLangPred?.args[1] else {
                continue
            }
            
            guard let subLang = detectLanguage(filetype: languageStr) else {
                print("Could not find parser for embedded language: \(languageStr)")
                continue
            }
            
            guard let subQuery = try? STSQuery.loadBundledQuery(language: subLang, sourceType: .highlights) else {
                print("Could not find highlights for embedded language: \(languageStr)")
                continue
            }
            
            let subParser = STSParser(language: subLang)
            
            let ranges = match.captures.map { STSRange(from: $0.node) }
            print("Sub language ranges \(ranges.count)")
            
            let _ = subParser.setIncludedRanges(ranges)
            
            guard let subTree = subParser.parse(string: textStorage.string, oldTree: nil) else {
                print("Embedded language parser returned nil")
                continue
            }
            
            updateTextHighlight(query: subQuery, tree: subTree, in: nil)
            
            print("Found injection match: \(match.index) with lang: \(languageStr)")
        }
        
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
        
        var rangesToUpdate: [NSRange] = []
        
        if let highlightsQuery = highlightsQuery {
        
            rangesToUpdate.append(NSRange(location: Int(inputEdit.startByte), length: Int(inputEdit.newEndByte-inputEdit.startByte)))
            
            
            for range in changedRanges {
                
                rangesToUpdate.append(NSRange(location: Int(range.startByte), length: Int(range.endByte - range.startByte)))
                
                
            }
            
            textStorage.beginEditing()
            
            rangesToUpdate.forEach { range in
                updateTextHighlight(query: highlightsQuery, tree: tree, in: range)
            }
            
            textStorage.endEditing()
            
        }
        
        let unionRange = rangesToUpdate.reduce(rangesToUpdate[0]) { (acc, next) -> NSRange in
            return acc.union(next)
        }
        
        parseSubtrees(in: unionRange)
        
    }
    
    fileprivate func updateTextHighlight(query: STSQuery, tree: STSTree, in range: NSRange?) {
        
        let queryCursor: STSQueryCursor
        if let range = range {
            queryCursor = STSQueryCursor(byteRangeFrom: uint(range.location), to: uint(NSMaxRange(range)))
            textStorage.addAttribute(.foregroundColor, value: NSColor.black, range: range)
        } else {
            queryCursor = STSQueryCursor()
        }
        
        let captures = queryCursor.captures(query: query, onNode: tree.rootNode)
        for capture in captures {
            
            let node = capture.node
            
            let atts = theme.getAttributes(forCapture: capture)
            
            let attributeRange = NSRange(location: Int(node.byteRange.lowerBound), length: Int(NSRange(node.byteRange).length))
            
            textStorage.addAttributes(atts, range: attributeRange)
            
            
        }
        
    }
    
}
