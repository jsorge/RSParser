//
//  HFeedParser+Extensions.swift
//  RSParser
//
//  Created by Jared Sorge on 1/7/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSParserInternal

extension HFeedParser: RSSAXHTMLParserDelegate {
    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlStartElement localName: UnsafePointer<UInt8>, attributes: UnsafeMutablePointer<UnsafePointer<UInt8>?>?) {
        guard let attributesDict = SAXParser.attributesDictionary(attributes) else { return }
        let tag = String(cString: localName)
        for key in attributesDict.keys {
            if let values = attributesDict[key] as? String {
                let separatedValues = values.split(separator: " ")
                guard separatedValues.count > 0 else { continue }
                for value in separatedValues {
                    if let property = HFeedProperty(rawValue: String(value), tag: tag) {
                        properties.append(property)
                        print("starting \(property)")
                    }
                }
            }
        }
    }
    
    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlEndElement localName: UnsafePointer<UInt8>?) {
        guard let last = properties.last, let localName = localName, last.tag == String(cString: localName) else { return }
        let property = properties.removeLast()
        print("ended \(property), raw: \(property.rawData)")
    }
    
    public func saxParser(_ SAXParser: RSSAXHTMLParser, xmlCharactersFound characters: UnsafePointer<UInt8>?, length: UInt) {
        guard let characters = characters, let currentFeed = properties.last else { return }
        currentFeed.append(characters)
    }
}

class HFeedProperty {
    typealias RawValue = String
    let rawValue: String
    let tag: String
    
    private(set) var rawData: String = ""
    
    private enum Key: String {
        case feed = "h-feed"
        //    case name = "p-name"
        //    case author = "p-author"
        //    case url = "u-url"
        //    case photo = "u-photo"
    }
    
    init?(rawValue: RawValue, tag: String) {
        guard let _ = Key(rawValue: rawValue) else { return nil }
        self.rawValue = rawValue
        self.tag = tag
    }
    
    func append(_ characters: UnsafePointer<UInt8>) {
        let converted = String(cString: characters)
        rawData += converted
    }
}

//struct HFeed {
//    public let name: String
//    public let author: HCard
//    public let url: URL
//    public let photo: Data?
//    public let children = [HEntry]()
//}

