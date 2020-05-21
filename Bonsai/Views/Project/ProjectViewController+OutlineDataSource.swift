//
//  ProjectViewController+OutlineDataSource.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 21/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

extension ProjectViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        guard let fileItem = item as? ProjectFileItem else {
            print("Could not convert item to ProjectFileItem")
            return nil
        }

        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("FileItemCell"), owner: self) as! ProjectFileItemCell

        view.nameTextField.stringValue = fileItem.url.lastPathComponent
        
        var icon = fileItem.icon
        if icon == nil {
            icon = NSWorkspace.shared.icon(forFile: fileItem.url.path)
        }
        
        view.iconImageView.image = icon

        return view
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        let fileItems = (item as? ProjectFileItem)?.subItems! ?? projectFileItems

        return fileItems.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let parent = item as? ProjectFileItem {
            // handle if parent
            return parent.subItems![index]
        }
        
        return projectFileItems[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let fileItem = item as? ProjectFileItem else {
            print("Could not convert item to ProjectFileItem")
            return false
        }
        
        return fileItem.subItems != nil || fileItem.url.hasDirectoryPath
    }
    
}
