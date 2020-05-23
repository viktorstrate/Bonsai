//
//  ViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeViewController: NSViewController {
    
    @IBOutlet weak var textView: CodeTextView!
    
    private weak var editorController: EditorViewController!
    
//    func editorSetup(editorController: EditorViewController) {
//        self.editorController = editorController
//        updateDocumentContent()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setup()
    }
    
//    func updateDocumentContent() {
//        if textView == nil {
//            return
//        }
//        
//        guard let documentContent = editorController.document?.codeContent else {
//            return
//        }
//        
//        textView.string = documentContent.contentString
//    }

}

