//
//  CodeSyntaxTree.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 27/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Foundation
import SwiftTreeSitter

class CodeSyntaxTree {
    
    let document: CodeDocument
    
    var parser: STSParser
    var tree: STSTree?
    
    init(document: CodeDocument) {
        self.document = document
        
        parser = STSParser()
        parser.language = STSLanguage.loadLanguage(preBundled: .javascript)
        
        tree = parser.parse(string: document.codeContent.contentString.string, oldTree: nil)
    }
    
    func documentWasEdited(in range: NSRange, with str: String, oldString: String) {
        
        guard let oldTree = self.tree else {
            return
        }
        
        let inputEdit = CodeSyntaxTree.getInputEdit(forRange: range, newString: str, oldString: oldString, documentString: document.codeContent.contentString.string as NSString)
        oldTree.edit(inputEdit)
        
        
        self.tree = parser.parse(string: document.codeContent.contentString.string, oldTree: oldTree)
    }
    
}
