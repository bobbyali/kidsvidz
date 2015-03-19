//
//  PlaylistCollection.swift
//  KidzVids
//
//  Created by Bobby on 18/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

// this class holds references to all Playlists currently loaded

class PlaylistCollection {
    
    let list = [Playlist]()
    
    init() {
        // set up default playlists
        list.append(Playlist(title: "Trucks", playlistID: "PL35F93FA3C740F3BB"))
        list.append(Playlist(title: "Alphabet", playlistID: "PL97977A770B5B12E2"))
        list.append(Playlist(title: "Baby Einstein", playlistID: "PLRg7DhTholQCMjMfXLOQ2bVSTwpZz24OA"))        
    }
    
}
