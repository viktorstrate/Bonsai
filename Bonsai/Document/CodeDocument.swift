//
//  Document.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

//@objc(CodeDocument)
class CodeDocument: NSDocument {
    
    var codeContent: CodeContent = CodeContent()
    var contentViewController: CodeViewController!

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        
        Swift.print("Make window controller")
        
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier:
          NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController

        guard let viewController = windowController.contentViewController as? CodeViewController else {
            fatalError("failed to get content view controller from document")
        }

        viewController.representedObject = codeContent
        self.contentViewController = viewController

        self.addWindowController(windowController)


    }

    override func data(ofType typeName: String) throws -> Data {
        return codeContent.data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        try codeContent.read(data: data)
    }
    
    


}

