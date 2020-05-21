//
//  EditorViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class EditorViewController: NSSplitViewController {

    var projectController: ProjectViewController {
        get {
            return self.splitViewItems[0].viewController as! ProjectViewController
        }
    }
    
    var codeController: CodeViewController {
        get {
            return self.splitViewItems[1].viewController as! CodeViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func documentSetup() {
        codeController.editorSetup(editorController: self)
        projectController.editorSetup(editorController: self)
    }
    
    var document: CodeDocument? {
        get {
            return representedObject as? CodeDocument
        }
    }
    
    override var representedObject: Any? {
        didSet {
            codeController.editorSetup(editorController: self)
            projectController.editorSetup(editorController: self)
        }
    }
    
    
    
}
