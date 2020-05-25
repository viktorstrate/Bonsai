//
//  PanelLayoutPane.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelLayoutPane: NSView {
    
    // The active document for the pane
    var activeDocument: CodeDocument? {
        didSet {
            delegate?.layoutPane(self, activeDocumentChanged: activeDocument)
            
            for controller in codeControllers {
                controller.isHidden = controller.document != activeDocument
            }
            
            tabsControl.layoutTabs()
        }
    }
    
    var delegate: PanelLayoutPaneDelegate?
    
    var codeControllers: Set<CodeViewController> = Set()
    var tabsControl: PanelTabsControl!

    init() {
        super.init(frame: NSRect())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDocument(_ document: CodeDocument) {
        print("PanelLayoutPane add document")
        
        let codeController = CodeViewController(document: document)
        
        let codeView = codeController.view
        codeView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(codeView)
        codeView.topAnchor.constraint(equalTo: tabsControl.bottomAnchor).isActive = true
        codeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        codeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        codeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        codeControllers.insert(codeController)
        
        activeDocument = document
        tabsControl.layoutTabs()
    }
    
    func removeDocument(_ document: CodeDocument) {
        
        guard let codeController = (codeControllers.first { $0.document == document }) else {
            print("could not remove document, document was not found")
            return
        }
        
        codeController.removeFromParent()
        codeController.view.removeFromSuperview()
        
        codeControllers.remove(codeController)
        tabsControl.layoutTabs()
    }
    
    fileprivate func setup() {
        layoutSubviews()
    }
    
    fileprivate func layoutSubviews() {
        print("LayoutSubviews")
        
        tabsControl = PanelTabsControl(layoutPane: self)
        
        self.addSubview(tabsControl)
        tabsControl.translatesAutoresizingMaskIntoConstraints = false
        tabsControl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tabsControl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tabsControl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tabsControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
}

protocol PanelLayoutPaneDelegate {
    func layoutPane(_ pane: PanelLayoutPane, activeDocumentChanged document: CodeDocument?)
}
