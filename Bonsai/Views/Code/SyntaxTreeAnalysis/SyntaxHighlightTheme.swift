//
//  SyntaxHighlightTheme.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 31/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import AppKit
import SwiftTreeSitter

class SyntaxHighlightTheme {
    init() {
        
    }
    
    public func getAttributes(forCaptureName captureName: String) -> [NSAttributedString.Key:Any] {
        
        print("Capture name: \(captureName)")
        
        let foregroundColor: NSColor
        switch captureName {
        case "variable":
            //foregroundColor = NSColor(red: 0.141, green: 0.161, blue: 0.18, alpha: 1)
            //foregroundColor = NSColor(red: 0.541, green: 0.161, blue: 0.18, alpha: 1)
            foregroundColor = NSColor(red: 0.122, green: 0.498, blue: 0.604, alpha: 1)
        case "property":
            //foregroundColor = NSColor(red: 0.435, green: 0.259, blue: 0.757, alpha: 1)
            foregroundColor = NSColor(red: 0.106, green: 0.145, blue: 0.565, alpha: 1.000)
        case "string":
            foregroundColor = NSColor(red: 0.0118, green: 0.184, blue: 0.384, alpha: 1)
        case "number":
            foregroundColor = NSColor(red: 0, green: 0.361, blue: 0.773, alpha: 1)
        case "keyword":
            foregroundColor = NSColor(red: 0.843, green: 0.227, blue: 0.286, alpha: 1)
        case "comment":
            foregroundColor = NSColor(red: 0.416, green: 0.451, blue: 0.49, alpha: 1)
        case "constructor":
            foregroundColor = NSColor.magenta
        default:
            foregroundColor = .black
        }
        
        var atts: [NSAttributedString.Key: Any] = [:]
        atts[.foregroundColor] = foregroundColor
        
        return atts
    }
}
