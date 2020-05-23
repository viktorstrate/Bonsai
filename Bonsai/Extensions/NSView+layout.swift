//
//  NSView+layout.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 22/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

extension NSView {
    func layoutFill(inside parentView: NSView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
