//
//  Indentation.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 10/06/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import AppKit

class IndentationManager {
    
    weak var codeSyntaxTree: CodeSyntaxTree!
    
    func newlineIndentationLevel(atSelectedRange range: NSRange) -> Int {
        return 0
    }
    
}
