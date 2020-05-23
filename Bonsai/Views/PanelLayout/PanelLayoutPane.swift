//
//  PanelLayoutPane.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class PanelLayoutPane: NSView {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    fileprivate func setup() {
        layoutSubviews()
    }
    
    fileprivate func layoutSubviews() {
        print("LayoutSubviews")
        
        let tabsControl = PanelTabsControl()
        self.addSubview(tabsControl)
        tabsControl.translatesAutoresizingMaskIntoConstraints = false
        tabsControl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tabsControl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tabsControl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tabsControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let codeController = CodeViewController()
        let codeView = codeController.view
        codeView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(codeView)
        codeView.topAnchor.constraint(equalTo: tabsControl.bottomAnchor).isActive = true
        codeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        codeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        codeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
