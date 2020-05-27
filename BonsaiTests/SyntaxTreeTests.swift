//
//  SyntaxTreeTests.swift
//  BonsaiTests
//
//  Created by Viktor Strate Kløvedal on 27/05/2020.
//  Copyright © 2020 viktorstrate. All rights reserved.
//

import XCTest
@testable import Bonsai

class SyntaxTreeTests: XCTestCase {
    func testEditTree() {
        // Insert 'a' in empty document
        let insertA = CodeSyntaxTree.getInputEdit(
            forRange: NSRange(location: 0, length: 0), newString: "a", oldString: "", documentString: "a"
        )

        XCTAssertEqual(insertA.startByte, 0)
        XCTAssertEqual(insertA.oldEndByte, 0)
        XCTAssertEqual(insertA.newEndByte, 1)
        XCTAssertEqual(insertA.startPoint.row, 0)
        XCTAssertEqual(insertA.startPoint.column, 0)
        XCTAssertEqual(insertA.oldEndPoint.row, 0)
        XCTAssertEqual(insertA.oldEndPoint.column, 0)
        XCTAssertEqual(insertA.newEndPoint.row, 0)
        XCTAssertEqual(insertA.newEndPoint.column, 1)

        let insertNewLine = CodeSyntaxTree.getInputEdit(forRange: NSRange(location: 1, length: 0), newString: "\n", oldString: "", documentString: "a\n")

        XCTAssertEqual(insertNewLine.startByte, 1)
        XCTAssertEqual(insertNewLine.oldEndByte, 1)
        XCTAssertEqual(insertNewLine.newEndByte, 2)
        XCTAssertEqual(insertNewLine.startPoint.row, 0)
        XCTAssertEqual(insertNewLine.startPoint.column, 1)
        XCTAssertEqual(insertNewLine.oldEndPoint.row, 0)
        XCTAssertEqual(insertNewLine.oldEndPoint.column, 1)
        XCTAssertEqual(insertNewLine.newEndPoint.row, 1)
        XCTAssertEqual(insertNewLine.newEndPoint.column, 0)
        
        let insertInMiddle = CodeSyntaxTree.getInputEdit(forRange: NSRange(location: 3, length: 0), newString: "hello", oldString: "", documentString: "hi hello there")
        
        XCTAssertEqual(insertInMiddle.startByte, 3)
        XCTAssertEqual(insertInMiddle.oldEndByte, 3)
        XCTAssertEqual(insertInMiddle.newEndByte, 8)
        XCTAssertEqual(insertInMiddle.startPoint.row, 0)
        XCTAssertEqual(insertInMiddle.startPoint.column, 3)
        XCTAssertEqual(insertInMiddle.oldEndPoint.row, 0)
        XCTAssertEqual(insertInMiddle.oldEndPoint.column, 3)
        XCTAssertEqual(insertInMiddle.newEndPoint.row, 0)
        XCTAssertEqual(insertInMiddle.newEndPoint.column, 8)
        
        // Replaced an eight character string with the four character string "test"
        let replaceSingleLine = CodeSyntaxTree.getInputEdit(forRange: NSRange(location: 3, length: 8), newString: "test", oldString: "abcdfghj", documentString: "my test works")
        
        XCTAssertEqual(replaceSingleLine.startByte, 3)
        XCTAssertEqual(replaceSingleLine.oldEndByte, 11)
        XCTAssertEqual(replaceSingleLine.newEndByte, 7)
        XCTAssertEqual(replaceSingleLine.startPoint.row, 0)
        XCTAssertEqual(replaceSingleLine.startPoint.column, 3)
        XCTAssertEqual(replaceSingleLine.oldEndPoint.row, 0)
        XCTAssertEqual(replaceSingleLine.oldEndPoint.column, 11)
        XCTAssertEqual(replaceSingleLine.newEndPoint.row, 0)
        XCTAssertEqual(replaceSingleLine.newEndPoint.column, 7)
        
        let deleteAll = CodeSyntaxTree.getInputEdit(forRange: NSRange(location: 0, length: 10), newString: "", oldString: "asdf\nhjklw", documentString: "")
        
        XCTAssertEqual(deleteAll.startByte, 0)
        XCTAssertEqual(deleteAll.oldEndByte, 10)
        XCTAssertEqual(deleteAll.newEndByte, 0)
        XCTAssertEqual(deleteAll.startPoint.row, 0)
        XCTAssertEqual(deleteAll.startPoint.column, 0)
        XCTAssertEqual(deleteAll.oldEndPoint.row, 1)
        XCTAssertEqual(deleteAll.oldEndPoint.column, 5)
        XCTAssertEqual(deleteAll.newEndPoint.row, 0)
        XCTAssertEqual(deleteAll.newEndPoint.column, 0)
        
    }
}
