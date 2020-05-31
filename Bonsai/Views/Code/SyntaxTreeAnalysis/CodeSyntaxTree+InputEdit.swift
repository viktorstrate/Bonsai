//
//  CodeSyntaxTree+InputEdit.swift
//  Bonsai
//
//  Created by Viktor Strate Kløvedal on 27/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import Foundation
import SwiftTreeSitter

extension CodeSyntaxTree {
    fileprivate static func pointFromString(string: NSString, endOffset: Int) -> STSPoint {
        var line: uint = 0
        var column: uint = 0
        
        var lineCounter = 0
        var index = 0
        
        while index < endOffset {
            
            var lineRange = string.lineRange(for: NSRange(location: index, length: 0))
            lineRange = lineRange.intersection(NSRange(location: 0, length: endOffset))!
            
            if lineRange.contains(endOffset-1) {
                
                let endIsNewline = Character(Unicode.Scalar(string.character(at: endOffset-1))!).isNewline
                if endIsNewline {
                    column = 0
                    line = uint(lineCounter + 1)
                } else {
                    column = uint(endOffset - lineRange.location)
                    line = uint(lineCounter)
                }
            }
            
            lineCounter += 1
            
            // Set index to start of next line
            index = NSMaxRange(lineRange)
        }
        
        let point = STSPoint(row: line, column: column)
        return point
    }
    
    fileprivate static func incrementPoint(_ point: STSPoint, by otherPoint: STSPoint) -> STSPoint {
        if point.row == otherPoint.row {
            return STSPoint(row: point.row, column: point.column + otherPoint.column)
        } else {
            return STSPoint(row: point.row + otherPoint.row, column: otherPoint.column)
        }
    }
    
    static func getInputEdit(beginIndex: Int, newString: String, oldString: String, documentString: NSString) -> STSInputEdit {
        
        let startPoint = pointFromString(string: documentString, endOffset: beginIndex)
        
        var oldEndPoint = pointFromString(string: oldString as NSString, endOffset: oldString.count)
        oldEndPoint = incrementPoint(startPoint, by: oldEndPoint)
        
        var newEndPoint = pointFromString(string: newString as NSString, endOffset: newString.count)
        newEndPoint = incrementPoint(startPoint, by: newEndPoint)
        
        let editInput = STSInputEdit(
            startByte: uint(beginIndex),
            oldEndByte: uint(beginIndex + oldString.count),
            newEndByte: uint(beginIndex + newString.count),
            startPoint: startPoint,
            oldEndPoint: oldEndPoint,
            newEndPoint: newEndPoint)
        
        return editInput
    }
}
