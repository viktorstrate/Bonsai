//
//  PanelLayoutController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelLayoutController: NSViewController, PanelLayoutPaneDelegate {
    
    weak var editorController: EditorViewController!
    var panelPane: PanelLayoutPane!
    
    var activeDocument: CodeDocument? {
        didSet {
            print("Active document changed")
            self.view.window?.windowController?.document = activeDocument
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        panelPane = PanelLayoutPane()
        panelPane.delegate = self
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(panelPane)
        panelPane.layoutFill(inside: self.view)
    }
    
    func editorSetup(editorController: EditorViewController) {
        self.editorController = editorController
        //updateDocumentContent()
    }
    
    func addDocument(_ document: CodeDocument) {
        panelPane.addDocument(document)
    }
    
    func removeDocument(_ document: CodeDocument) {
        panelPane.removeDocument(document)
    }
    
    func layoutPane(_ pane: PanelLayoutPane, activeDocumentChanged document: CodeDocument?) {
        activeDocument = document
    }
    
    func layoutPane(_ pane: PanelLayoutPane, removeDocument document: CodeDocument) {
        if let window = self.view.window?.windowController as? CodeDocumentWindow {
            window.removeDocument(document)
        } else {
            print("PanelLayoutController: Could not get CodeDocumentWindow")
        }
    }
    
}
