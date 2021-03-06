//
//  PlayerViewController.swift
//  KidzVids
//
//  Created by Bobby on 17/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit
import YouTubePlayer
import Darwin

class PlayerViewController: UIViewController, YouTubePlayerDelegate {

    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    var videoID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoPlayer.delegate = self
        
        if let videoID = self.videoID {
            videoPlayer.loadVideoID(videoID)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: YouTubePlayerDelegate
    // These are all required for the interface. See https://github.com/gilesvangruisen/Swift-YouTube-Player/
    func playerReady(videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
    
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == YouTubePlayerState.Ended || playerState == YouTubePlayerState.Paused {
            if let nav = self.navigationController {
                videoPlayer.closePlayer()
                nav.popViewControllerAnimated(true)
            }
        }
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        println("Quality has changed")
    }
    
    

}
