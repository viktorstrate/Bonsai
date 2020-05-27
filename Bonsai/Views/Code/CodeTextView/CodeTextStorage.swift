//
//  CodeTextStorage.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 25/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Cocoa

class CodeTextStorage: NSTextStorage {
    
    let document: CodeDocument
    let syntaxTree: CodeSyntaxTree
    
    override var string: String {
        return document.codeContent.contentString.string
    }
    
    fileprivate var textContent: NSMutableAttributedString {
        document.codeContent.contentString
    }
    
    init(document: CodeDocument) {
        self.document = document
        self.syntaxTree = CodeSyntaxTree(document: document)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return document.codeContent.contentString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        
        let oldStr = (textContent.string as NSString).substring(with: range)
        
        super.beginEditing()
        
        textContent.replaceCharacters(in: range, with: str)
        
        super.edited(
            [.editedCharacters, .editedAttributes], range: range,
            changeInLength: (str as NSString).length - range.length
        )
        
        super.endEditing()
        
        syntaxTree.documentWasEdited(in: range, with: str, oldString: oldStr)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        super.beginEditing()
        
        textContent.addAttributes(attrs ?? [:], range: range)
        
        super.edited(.editedAttributes, range: range, changeInLength: 0)
        
        super.endEditing()
    }
    
    override func processEditing() {
        super.processEditing()
    }
    
}
