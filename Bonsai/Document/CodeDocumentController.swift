//
//  DocumentController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeDocumentController: NSDocumentController {
    
    static override var shared: Self {
        get {
            return NSDocumentController.shared as! Self
        }
    }
    
    override func runModalOpenPanel(_ openPanel: NSOpenPanel, forTypes types: [String]?) -> Int {
        print("Run modal open panel")
        openPanel.canChooseDirectories = true
        return super.runModalOpenPanel(openPanel, forTypes: types)
    }
    
    override func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (NSDocument?, Bool, Error?) -> Void) {
        print("openDocument")

        if url.hasDirectoryPath {
            print("Open project directory \(url)")

            guard let document = try? super.openUntitledDocumentAndDisplay(displayDocument) else {
                completionHandler(nil, false, DocumentControllerError.openDocument)
                return
            }
            
            if let editorController = documents.last?.windowControllers.first?.contentViewController as? EditorViewController {
                editorController.projectController.projectDirectory = url
            }
            
            completionHandler(document, false, nil)

        } else {            
            super.openDocument(withContentsOf: url, display: displayDocument, completionHandler: completionHandler)
        }
    }
    
    enum DocumentControllerError: Error {
        case openDocument
    }
    
}
