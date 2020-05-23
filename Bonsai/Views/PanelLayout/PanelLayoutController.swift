//
//  PanelLayoutController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelLayoutController: NSViewController {
    
    weak var editorController: EditorViewController!
    var panelPane: PanelLayoutPane!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        panelPane = PanelLayoutPane()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(panelPane)
        panelPane.layoutFill(inside: self.view)
    }
    
    func editorSetup(editorController: EditorViewController) {
        self.editorController = editorController
        //updateDocumentContent()
    }
    
}
