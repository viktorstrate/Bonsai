//
//  AppDelegate.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 19/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillFinishLaunching(_ notification: Notification) {
        // Make CodeDocumentController the shared DocumentController
        _ = CodeDocumentController()
    }
        
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

