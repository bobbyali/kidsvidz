//
//  GridViewController.swift
//  KidzVids
//
//  Created by Bobby on 17/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

let mySpecialNotificationKey = "com.azukiapps.fetchedVideoIDs"

class GridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "videoCell"
        
    var playlists: PlaylistCollection?
    var playlistIndex: Int = 0
    
    
    
    // SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "fetchedVideoIDs:",
            name: mySpecialNotificationKey,
            object: nil)
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.playlists = PlaylistCollection()
        var numVideos = getPlaylist().videoIDs.count
        println("Number of videos: " + String(numVideos))
        
        self.collectionView?.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    func getPlaylist() -> Playlist {
        return self.playlists!.list[playlistIndex]
    }
    

    
    func fetchedVideoIDs(notification: NSNotification) {
        println("notification received")
        if notification.name == mySpecialNotificationKey {
            self.collectionView?.reloadData()
            println("target notification received")
        }
    }
    
    
    // MARK: Collection view
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numResults = getPlaylist().videoIDs.count
        println(String(numResults))
        return numResults
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as VideoPhotoCell
        let videoPhotoURL = "http://img.youtube.com/vi/" + getPlaylist().videoIDs[indexPath.row] + "/0.jpg"
        cell.backgroundColor = UIColor.blackColor()
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
                newViewController.videoID = getPlaylist().videoIDs[indexValue.row]
            }
        }
    }
    
    

    
    // MARK: Gestures
    @IBAction func longTouch(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            println("Long press detected")
            let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            vc.playlists = playlists
            vc.playlistIndex = playlistIndex
            navigationController?.pushViewController(vc, animated: true)
            //self.collectionView?.reloadData()
        }
    }
    
    
}
