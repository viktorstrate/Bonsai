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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setup()
    }

}

