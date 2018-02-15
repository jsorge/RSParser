//
//  HFeedParser.swift
//  RSParser
//
//  Created by Jared Sorge on 1/7/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation

// http://microformats.org/wiki/h-feed

class HFeed: MicroType {
    static let metaValue = "h-feed"
    var rawData = ""
    var entries = [HEntry]()

    let tag: String

    init(tag: String) {
        self.tag = tag
    }
}

//struct HFeed {
//    public let name: String
//    public let author: HCard
//    public let url: URL
//    public let photo: Data?
//    public let children = [HEntry]()
//}
