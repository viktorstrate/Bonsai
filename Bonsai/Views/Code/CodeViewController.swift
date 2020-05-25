//
//  ViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeViewController: NSViewController {
    
    var textView: CodeTextView!
    let document: CodeDocument
    
    init(document: CodeDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = NSView()
        
        let textScrollView = NSScrollView()
        
        textView = CodeTextView(document: document)
        
        textScrollView.hasVerticalScroller = true
        textScrollView.horizontalScrollElasticity = .none
        textScrollView.borderType = .noBorder
        textScrollView.documentView = textView
        
        textView.layoutFill(inside: textScrollView.contentView)
        
        super.view.addSubview(textScrollView)
        textScrollView.layoutFill(inside: super.view)
        
        textView.setupGutter()
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
                textView.gutterView.needsDisplay = true
            }
        }
    }

}

