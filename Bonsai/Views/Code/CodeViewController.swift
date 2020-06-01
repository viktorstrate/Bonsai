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
    
    var detachedSubview: NSView?
    
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
            
            if isHidden {
                if detachedSubview == nil {
                    detachedSubview = self.view.subviews.first
                    detachedSubview?.removeFromSuperviewWithoutNeedingDisplay()
                }
            } else {
                if let subview = detachedSubview {
                    print("found subview")
                    self.view.addSubview(subview)
                    subview.layoutFill(inside: self.view)
                    detachedSubview = nil
                }
            }
            
            if isHidden == false {
                textView.gutterView?.needsDisplay = true
            }
        }
    }

}

