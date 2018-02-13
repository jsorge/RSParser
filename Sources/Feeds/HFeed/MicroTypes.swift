//
//  MicroTypes.swift
//  RSParser
//
//  Created by Jared Sorge on 1/6/18.
//  Copyright © 2018 Ranchero Software, LLC. All rights reserved.
//

import Foundation

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
