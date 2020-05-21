//
//  ViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeViewController: NSViewController {

    var documentContent: CodeContent? {
        get {
            return representedObject as? CodeContent
        }
    }
    
    @IBOutlet var textView: CodeTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.setup()
        
        updateDocumentContent()
    }

    override var representedObject: Any? {
        didSet {
            updateDocumentContent()
        }
    }
    
    func updateDocumentContent() {
        if textView == nil {
            return
        }
        
        guard let documentContent = documentContent else {
            return
        }
        
        textView.string = documentContent.contentString
    }

}

