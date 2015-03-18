//
//  Playlist.swift
//  KidzVids
//
//  Created by Bobby on 18/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

// omit inheriting NSCoding interface for now
class Playlist {
    
    let title: String
    let playlistID: String
    var videoIDs = [String]()
    
    let youtubePlaylistURLPrefix:String = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&playlistId="
    let youtubeKeySuffix:String = "&key=AIzaSyDG2hPqOEDnKeaBW365MCc9KFZVHB8LUYs"
    let searchString:String
    
    init(title:String, playlistID:String) {
        
        self.title = title ?? "na"
        self.playlistID = playlistID ?? "na"

        self.searchString = youtubePlaylistURLPrefix + playlistID + youtubeKeySuffix
        queryYoutube(self.searchString)
        
    }
        
    func getNumberOfVideos() -> Int {
        return self.videoIDs.count
    }
    
    // send an API request to Youtube to fetch playlist information
    func queryYoutube(searchString:String) {
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( searchString ,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                self.getVideoIDs(responseObject)
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: nil)
        
    }
    
    // recursively fetch all available videoIDs from playlist by navigating nextPageTokens
    func getVideoIDs(responseObject: AnyObject) {
        //println("Response: " + responseObject.description)
        
        if let dataArray = responseObject["items"] as? [AnyObject] {
            for dataObject in dataArray {
                if let imageURLString = dataObject.valueForKeyPath("contentDetails.videoId") as? String {
                    self.videoIDs.append(imageURLString)
                }
            }
        }
        
        if let nextToken = responseObject["nextPageToken"] as? String {
            println(nextToken)
            var newSearchString = self.searchString + "&pageToken=" + nextToken
            queryYoutube(newSearchString)
        }
        
    }
    
    
    
    /*
    required init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.playlistID = aDecoder.decodeObjectForKey("playlistID") as? String
        self.videoIDs = aDecoder.decodeObjectForKey("videoIDs") as [String]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.playlistID, forKey: "playlistID")
        aCoder.encodeObject(self.videoIDs, forKey: "videoIDs")
    }


    
    func save() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "playlist")
    }
    
    func clear() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("playlist")
    }
    
    class func loadSaved() -> Playlist? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("playlist") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Playlist
        }
        return nil
    }
    */
    
}


