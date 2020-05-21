//
//  CodeDocumentWindow.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 21/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class BonsaiWindowController: NSWindowController {

    var editorController: EditorViewController {
        get {
            return contentViewController as! EditorViewController
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
