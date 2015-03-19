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
        
        // set up notifications for when YouTube videos finish fetching in background
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "fetchedVideoIDs:",
            name: mySpecialNotificationKey,
            object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    
        // set up notice on how to access settings menu
        var alert = UIAlertController(title: "Info", message: "To change playlist, tap and hold until screen goes white.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        // start fetching playlists
        self.playlists = PlaylistCollection()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        // refresh view with latest videos after returning from settings view controller
        self.collectionView?.reloadData()
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = UIColor.blackColor()
        }
    }
    
    // MARK: Helper functions
    
    // retrieve the current Playlist object
    func getPlaylist() -> Playlist {
        return self.playlists!.list[playlistIndex]
    }
    

    // receive and act on notifications that background video fetch has finished
    func fetchedVideoIDs(notification: NSNotification) {
        if notification.name == mySpecialNotificationKey {
            self.collectionView?.reloadData()
        }
    }
    
    
    // MARK: Collection view
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPlaylist().videoIDs.count
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
    
    // a long tap is used to open the settings view controller
    @IBAction func longTouch(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            
            let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            vc.playlists = playlists
            vc.playlistIndex = playlistIndex
            navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.state == UIGestureRecognizerState.Began {
            
            // give a visual clue that press has been long enough to activate settings view controller
            UIView.animateWithDuration(2.0, animations: {
                if let collectionView = self.collectionView {
                    collectionView.backgroundColor = UIColor.whiteColor()
                }
            })
        }
    }
    
    
}
