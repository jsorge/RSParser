//
//  HEntryParserTests.swift
//  RSParserTests
//
//  Created by Jared Sorge on 1/5/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import XCTest
import RSParser

class HEntryParserTests: XCTestCase {
    func testTantekHFeed() {
        let d = parserData("tantek.com", "html", "http://tantek.com")
        do {
            let parsedFeed = try FeedParser.parse(d)
            XCTAssertTrue(parsedFeed == nil)
        }
        catch {
            
        }
    }

    func testPareckiHEntries() {
        let d = parserData("aaronparecki.com", "html", "https://aaronparecki.com")
        do {
            let parsedFeed = try FeedParser.parse(d)
            XCTAssertTrue(parsedFeed == nil)
        }
        catch {

        }
    }
}
