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
    weak var document: CodeDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setup()
        textView.string = document.codeContent.contentString
    }
    
    var isHidden: Bool = false {
        didSet {
            self.view.isHidden = isHidden
            
            if isHidden == false {
                textView.gutterView.needsDisplay = true
            }
        }
    }

}

