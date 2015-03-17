//
//  GridViewController.swift
//  KidzVids
//
//  Created by Bobby on 17/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

class GridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "videoCell"
    
    //let youtubePlaylistURL:String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=PL35F93FA3C740F3BB&key=AIzaSyDG2hPqOEDnKeaBW365MCc9KFZVHB8LUYs"
    
    let youtubePlaylistURL:String = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&playlistId=PL35F93FA3C740F3BB&key=AIzaSyDG2hPqOEDnKeaBW365MCc9KFZVHB8LUYs"
    
    var videoIDs = [String]()
    
    
    
    // SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        queryYoutube(youtubePlaylistURL)
        //self.collectionView?.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // MARK: Collection view
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(String(self.videoIDs.count))
        return self.videoIDs.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as VideoPhotoCell
        let videoPhotoURL = "http://img.youtube.com/vi/" + videoIDs[indexPath.row] + "/2.jpg"
        cell.backgroundColor = UIColor.whiteColor()
        cell.videoPhotoCell.setImageWithURL(NSURL(string: videoPhotoURL ))
        return cell
    }
    
    
    
    // MARK: Collection view flow delegate
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            
            return CGSize(width: 130, height: 100)
    }
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "loadPlayer") {
            let newViewController = segue.destinationViewController as PlayerViewController
            let indexPath = self.collectionView?.indexPathForCell(sender as VideoPhotoCell)
            if let indexValue = indexPath {
                newViewController.videoID = self.videoIDs[indexValue.row]
            }
        }
    }
    
    
    //MARK: Utility methods
    func queryYoutube(searchString:String) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET( searchString ,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                self.getVideoIDs(responseObject)
                self.collectionView?.reloadData()
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
    }
    
    // recursively fetch all available videoIDs from playlist by navigating nextPageTokens
    func getVideoIDs(responseObject: AnyObject) {
        println("Response: " + responseObject.description)
        
        if let dataArray = responseObject["items"] as? [AnyObject] {
            for dataObject in dataArray {
                if let imageURLString = dataObject.valueForKeyPath("contentDetails.videoId") as? String {
                    self.videoIDs.append(imageURLString)
                }
            }
        }
        
        if let nextToken = responseObject["nextPageToken"] as? String {
            println(nextToken)
            var newSearchString = youtubePlaylistURL + "&pageToken=" + nextToken
            queryYoutube(newSearchString)
        }
        
    }
}
