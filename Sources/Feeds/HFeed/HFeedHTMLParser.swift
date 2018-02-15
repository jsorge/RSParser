//
//  HFeedHTMLParser.swift
//  RSParser
//
//  Created by Jared Sorge on 2/13/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSParserInternal

struct MicroTypeTagTracker {
    private var count = 1
    let microType: MicroType

    init(microType: MicroType) {
        self.microType = microType
    }

    mutating func increment(tag: String) {
        guard tag == microType.tag else { return }
        count += 1
    }

    mutating func decrement(tag: String) {
        guard tag == microType.tag else { return }
        count -= 1
    }

    var typeIsRoot: Bool {
        return count == 0
    }
}

public final class HFeedHTMLParser: NSObject {
    static func parse(_ parserData: ParserData) -> ParsedFeed? {
        let parser = HFeedHTMLParser()
        let parsed = parser.parse(parserData)
        return parsed
    }

    private func parse(_ parserData: ParserData) -> ParsedFeed? {
        let parser = RSSAXHTMLParser(delegate: self)
        parser.parseData(parserData.data)
        parser.finishParsing()
//        let entries = foundEntries
        return nil
    }

    var foundFeed: HFeed? {
        didSet {
            if let feed = foundFeed {
                feedTracker = MicroTypeTagTracker(microType: feed)
            }
            else {
                feedTracker = nil
            }
        }
    }
    var feedTracker: MicroTypeTagTracker?
    var currentEntry: HEntry?
    var foundEntries = [HEntry]()
}

extension HFeedHTMLParser: RSSAXHTMLParserDelegate {
    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlStartElement localName: UnsafePointer<UInt8>,
                          attributes: UnsafeMutablePointer<UnsafePointer<UInt8>?>?)
    {
        let tag = String(cString: localName)
        feedTracker?.increment(tag: tag)

        guard let attributesDict = SAXParser.attributesDictionary(attributes) else { return }
        for key in attributesDict.keys {
            if let values = attributesDict[key] as? String {
                let separatedValues = values.split(separator: " ")
                guard separatedValues.count > 0 else { continue }
                for value in separatedValues {
                    if let newType = MicroTypeParser.createInstance(from: String(value), tag: tag) {
                        print("starting a \(value)")
                        if let feed = newType as? HFeed {
                            foundFeed = feed
                        }
                        else if let entry = newType as? HEntry {
                            currentEntry = entry
                        }
                    }
                }
            }
        }
    }

    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlEndElement localName: UnsafePointer<UInt8>?) {
        guard let localName = localName else { return }
        let tagName = String(cString: localName)

        if let currentEntry = currentEntry, currentEntry.tag == tagName {
            foundEntries.append(currentEntry)
            self.currentEntry = nil
            print("Ending an entry")
        }
        else {
            feedTracker?.decrement(tag: tagName)
        }

        if foundFeed?.tag == tagName, let tracker = feedTracker, tracker.typeIsRoot {
            print("The feed has finalized!")
            foundFeed?.entries = foundEntries
            SAXParser.cancel()
        }
    }

    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlCharactersFound characters: UnsafePointer<UInt8>?,
                          length: UInt)
    {
        guard let characters = characters else { return }

        if currentEntry != nil {
            currentEntry?.append(characters)
        }
        else {
            foundFeed?.append(characters)
        }
    }
}
