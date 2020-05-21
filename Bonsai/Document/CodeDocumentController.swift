//
//  DocumentController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeDocumentController: NSDocumentController {
    
    var shared: Self {
        get {
            return NSDocumentController.shared as! Self
        }
    }
    
    override func runModalOpenPanel(_ openPanel: NSOpenPanel, forTypes types: [String]?) -> Int {
        print("Run modal open panel \(kUTTypeFolder)")
        openPanel.canChooseDirectories = true
        return super.runModalOpenPanel(openPanel, forTypes: types)
    }
    
    override func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (NSDocument?, Bool, Error?) -> Void) {
        
        if url.hasDirectoryPath {
            print("Open project directory \(url)")
            let document = CodeDocument()
            document.makeWindowControllers()
            
            guard let windowController = document.windowControllers.first as? BonsaiWindowController else {
                fatalError("Document window controller not found")
            }
            
            windowController.showWindow(self)
            windowController.editorController.projectController.projectDirectory = url
            
        } else {
            super.openDocument(withContentsOf: url, display: displayDocument, completionHandler: completionHandler)
        }
    }
    
    
}
