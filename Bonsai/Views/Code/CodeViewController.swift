//
//  CodeViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 27/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.

import Cocoa

class CodeViewController: NSViewController {
    
    @IBOutlet weak var textView: CodeTextView!
    let document: CodeDocument
    
    init(document: CodeDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear() {
        textView.setup(document: document)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var isHidden: Bool = false {
        didSet {
            self.view.isHidden = isHidden
            
            if isHidden == false {
                textView.gutterView?.needsDisplay = true
            }
        }
    }

}

