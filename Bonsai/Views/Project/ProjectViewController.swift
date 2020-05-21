//
//  ProjectOutlineViewController.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class ProjectViewController: NSViewController {

    var projectDirectory: URL! = FileManager.default.homeDirectoryForCurrentUser {
        didSet {
            loadProjectFiles()
        }
    }
    
    var projectFileItems: [ProjectFileItem] = []
    
    private weak var editorController: EditorViewController!
    
    @IBOutlet weak var projectOutlineView: NSOutlineView!
    
    func editorSetup(editorController: EditorViewController) {
        self.editorController = editorController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        projectOutlineView.rowHeight = 18
    }
    
    private func loadProjectFiles() {
        print("Loading project files")
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: projectDirectory, includingPropertiesForKeys: nil, options: []) else {
            print("Could not get project files")
            return
        }
        
        print("Found \(files.count) files")
        
        let items = files.map { ProjectFileItem(url: $0, subItems: nil) }
        projectFileItems = items
        projectOutlineView.reloadData()
    }
    
}

struct ProjectFileItem {
    var url: URL
    var subItems: [ProjectFileItem]?
    var icon: NSImage?
}
