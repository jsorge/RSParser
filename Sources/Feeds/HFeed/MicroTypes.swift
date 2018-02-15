//
//  MicroTypes.swift
//  RSParser
//
//  Created by Jared Sorge on 1/6/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation

protocol MicroType {
    static var metaValue: String { get }
    var rawData: String { get set }
    var tag: String { get }
}

extension MicroType {
    mutating func append(_ characters: UnsafePointer<UInt8>) {
        let converted = String(cString: characters)
        rawData += converted
    }
}

struct MicroTypeParser {
    static func createInstance(from identifier: String, tag: String) -> MicroType? {
        switch identifier {
        case HFeed.metaValue:
            return HFeed(tag: tag)
        case HEntry.metaValue:
            return HEntry(tag: tag)
        default:
            return nil
        }
    }
}

struct HCard: HEntryLocation {
    
}

struct HAdr: HEntryLocation {
    
}

struct HGeo: HEntryLocation {
    
}

struct HRSVP {
    
}

struct HCite {
    let name: String?
    let datePublished: Date?
    let author: HCard?
    let url: URL?
    let uid: String?
}
