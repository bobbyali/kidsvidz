//
//  GridViewController.swift
//  KidzVids
//
//  Created by Bobby on 17/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

let mySpecialNotificationKey = "com.azukiapps.fetchedVideoIDs"

class GridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    private let reuseIdentifier = "videoCell"
        
    var playlists: PlaylistCollection?
    var playlistIndex: Int = 0
    let longTouchIndicatorBar = UIView(frame: CGRect(x: 20, y: 0, width: 0, height: 20))
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    var infoLabel: UILabel = UILabel()
    
    // SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up notifications for when YouTube videos finish fetching in background
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "fetchedVideoIDs:",
            name: mySpecialNotificationKey,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "orientationChanged:",
            name: UIDeviceOrientationDidChangeNotification,
            object: nil)
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // start fetching playlists
        self.playlists = PlaylistCollection()
        
        infoLabel = UILabel(frame: CGRect(x: 20, y: 10, width: screenSize.width-40, height: 20))
        infoLabel.text = "Tap and hold for settings"
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.textAlignment = NSTextAlignment.Center
        collectionView?.addSubview(infoLabel)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func orientationChanged(notification: NSNotification) {
        println("notified of rotation!")
        refreshViewController()
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
            
            let screenWidth = screenSize.width
            
            let isLandscape = UIApplication.sharedApplication().statusBarOrientation.isLandscape
            
            if isLandscape {
                let iconWidth = (screenWidth/2) - 50
                return CGSize(width: iconWidth, height: iconWidth * 0.77)
            } else {
                let iconWidth = screenWidth - 50
                return CGSize(width: iconWidth, height: iconWidth * 0.77)
            }
            
    }
    
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    // MARK: Screen updates
    
    /*override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        refreshViewController()
    }*/
    
    override func viewWillAppear(animated: Bool) {
        // refresh view with latest videos after returning from settings view controller
        refreshViewController()
    }
    
    
    func refreshViewController() {
        self.collectionView?.reloadData()
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = UIColor.blackColor()
        }

        let rotation = UIApplication.sharedApplication().statusBarOrientation.rawValue
        //self.screenSize = UIScreen.mainScreen().bounds
        self.screenSize = UIScreen.mainScreen().applicationFrame
        println("Rotated \(rotation) h: \(screenSize.height) w: \(screenSize.width)")
        infoLabel.frame.size.width = screenSize.width-40

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
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    @IBAction func showLongTouchResponse(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            // give a visual clue that long press will do something
            let touchPosition = sender.locationInView(self.collectionView)
            longTouchIndicatorBar.frame = CGRect(x: 20, y: Int(touchPosition.y), width: 0, height: 10)
            
            longTouchIndicatorBar.backgroundColor = UIColor.redColor()
            collectionView?.addSubview(longTouchIndicatorBar)
            UIView.animateWithDuration(2.5, animations: {
                self.longTouchIndicatorBar.frame.size.width = self.screenSize.width - 40
            })
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            let touchPosition = sender.locationInView(self.collectionView)
            longTouchIndicatorBar.frame.size.width = 0
            longTouchIndicatorBar.removeFromSuperview()
        }
    }
    
    // a long tap is used to open the settings view controller
    @IBAction func loadSettingsMenu(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            
            let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            //let vc = PlaylistEditorViewController(nibName: nil, bundle: nil)
            vc.playlists = playlists
            vc.playlistIndex = playlistIndex
            navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.state == UIGestureRecognizerState.Began {
            
            // give a visual clue that press has been long enough to activate settings view controller
            UIView.animateWithDuration(0.2, animations: {
                self.longTouchIndicatorBar.backgroundColor = UIColor.greenColor()
            })
        }
    }
    
}
