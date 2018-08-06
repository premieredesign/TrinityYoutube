//
//  API.swift
//  YouTube
//
//  Created by Clinton Johnson on 6/29/18.
//  Copyright © 2018 Clinton Johnson. All rights reserved.
//

import UIKit

class API: Decodable {
    var songData: [SongInfo]?
}

class SongInfo: Decodable {
    //MARK: - Properties
    var name: String?
    var songs: [artistData]?
}

class artistData: Decodable {
    var DATE: String?
    var ARTIST: String?
    var SONG: String?
    var SERVICE: String?
    var VIDEO: String?
    var LYRICS: String?
    var PROFILE: String?
}

struct SongsFromData {
    var DATE: String?
    var ARTIST: String?
    var SONG: String?
    var SERVICE: String?
    var VIDEO: String?
    var LYRICS: String?
    var PROFILE: String?
    
    
}
