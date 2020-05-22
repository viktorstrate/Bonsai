//
//  CodeDocumentWindow.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 21/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeDocumentWindow: NSWindowController, NSWindowDelegate {

    var editorController: EditorViewController {
        get {
            return contentViewController as! EditorViewController
        }
    }
    
    var documents: Set<CodeDocument> = Set()
    
    func addDocument(_ document: CodeDocument) {
        documents.insert(document)
        document.addWindowController(self)
    }
    
    func removeDocument(_ document: CodeDocument) {
        if !documents.contains(document) {
            return
        }
        
        document.removeWindowController(self)
        CodeDocumentController.shared.removeDocument(document)
        documents.remove(document)
    }
    
    func openDocument(url: URL) {
        guard let document = try? CodeDocument(contentsOf: url, ofType: "public.text") else {
            print("Could not open document")
            return
        }
        
        addDocument(document)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.delegate = self
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowWillClose(_ notification: Notification) {
        if notification.object as AnyObject? !== window {
            print("Ignore windowWillClose event")
            return
        }
        
        print("Closing CodeDocumentWindow (\(documents.count) documents)")
        
        for document in documents {
            removeDocument(document)
        }
    }

}
