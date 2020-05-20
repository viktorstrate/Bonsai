//
//  ViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class ContentViewController: NSViewController {

    var documentContent: CodeContent? {
        get {
            return representedObject as? CodeContent
        }
    }
    
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.string = documentContent!.contentString
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Document content changed
        }
    }

}

