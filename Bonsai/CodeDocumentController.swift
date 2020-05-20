//
//  DocumentController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeDocumentController: NSDocumentController {
    
    override var documentClassNames: [String] {
        return ["CodeDocument"]
    }
    
    override var defaultType: String? {
        return "CodeDocument"
    }
    
    override func documentClass(forType typeName: String) -> AnyClass? {
        return CodeDocument.self
    }
    
}
