//
//  HEntryParser.swift
//  RSParser
//
//  Created by Jared Sorge on 1/5/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation

// http://microformats.org/wiki/h-entry

class HEntry: MicroType {
    static var metaValue = "h-entry"
    var tag: String
    var rawData = ""

    init(tag: String) {
        self.tag = tag
    }

    private struct Parsed {
        var name: String?
        var summary: String?
        var content: String?
        var published: Date?
        var author = [HCard]()
        var category = [String]()
        var url: URL?
        var uid: String?
        var location: HEntryLocation?
        var syndication = [URL]()
        var inReplyTo: HCite?
        var rsvp: HRSVP?
        var likeOf: HCite?
        var repostOf: HCite?
    }
}

//private enum HEntryProperty: String {
//    case name = "p-name"
//    case summary = "p-summary"
//    case content = "e-content"
//    case published = "dt-published"
//    case author = "p-author"
//    case category = "p-category"
//    case url = "u-url"
//    case uid = "u-uid"
//    case location = "p-location"
//    case syndication = "u-syndication"
//    case inReplyTo = "u-in-reply-to"
//    case rsvp = "p-rsvp" // the contents of this tag are an enum: yes, maybe, no, interested
//    case likeOf = "u-like-of"
//    case repostOf = "u-repost-of"
//}

protocol HEntryLocation {}
