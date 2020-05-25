//
//  CodeContent.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 20/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Foundation

class CodeContent {
    var contentString: NSMutableAttributedString = NSMutableAttributedString()
    
    func read(data: Data) throws {
        guard let content = String(data: data, encoding: .utf8) else {
            throw CodeContentError.invalidEncoding
        }
        
        self.contentString = NSMutableAttributedString(string: content)
    }
    
    func data() -> Data {
        return contentString.string.data(using: .utf8)!
    }
    
    enum CodeContentError: Error {
        case invalidEncoding
    }
}
