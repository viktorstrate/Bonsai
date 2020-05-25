//
//  Document.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeDocument: NSDocument {
    
    var codeContent: CodeContent = CodeContent()
    var contentViewController: EditorViewController!

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        
        Swift.print("CodeDocument.makeWindowControllers")
        
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")
            ) as! CodeDocumentWindow

        windowController.addDocument(self)
        
        guard let viewController = windowController.contentViewController as? EditorViewController else {
            fatalError("failed to get content view controller from document")
        }

        self.contentViewController = viewController
        
        self.addWindowController(windowController)
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        if (typeName == "public.folder") {
            Swift.print("Opening project folder (CodeDocument)")
        } else {
            try super.read(from: fileWrapper, ofType: typeName)
        }
    }

    override func data(ofType typeName: String) throws -> Data {
        return codeContent.data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        try codeContent.read(data: data)
    }
    
    override func save(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType, completionHandler: @escaping (Error?) -> Void) {
        
        super.save(to: url, ofType: typeName, for: saveOperation) { (error) in
            completionHandler(error)
            Swift.print("Save completed")
            self.contentViewController.panelController.panelPane.tabsControl.layoutTabs()
        }
        
    }

}


