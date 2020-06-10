//
//  ProjectDirectoryManager.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 10/06/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import AppKit

struct WorkingDirectoryManager {
    
    struct WorkingDirectoryEntry: Codable {
        let url: URL
        let accessDate: Date
        let bookmark: Data
    }
    
    static func persistWorkingDirectory(for workDir: URL) {
        do {
            let bookmark = try workDir.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            var entries = loadWorkingDirectories()
            
            if !entries.contains(where: { $0.url == workDir }) {
                let entry = WorkingDirectoryEntry(url: workDir, accessDate: Date(), bookmark: bookmark)
                entries.append(entry)
            }
            
            let encodedEntries: [NSData] = entries.map { (entry) in
                try! JSONEncoder().encode(entry) as NSData
            }
            
            UserDefaults.standard.set(encodedEntries, forKey: "working-directories")
        
        } catch {
            print("Error: failed to save working directory to recent projects")
        }
    }
    
    static func loadWorkingDirectories() -> [WorkingDirectoryEntry] {
        
        let entries = (UserDefaults.standard.array(forKey: "working-directories") ?? []) as! [NSData]
        
        return entries.map { (data) -> WorkingDirectoryManager.WorkingDirectoryEntry in
            try! JSONDecoder().decode(WorkingDirectoryEntry.self, from: data as Data)
        }
    }
    
}
