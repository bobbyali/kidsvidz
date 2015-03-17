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
    
    // init YouTubePlayerView w/ playerFrame rect (assume playerFrame declared)
    //var videoPlayer = YouTubePlayerView(frame: playerFrame)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        videoPlayer.delegate = self
        
        // Load video from YouTube ID
        if let videoID = self.videoID {
            videoPlayer.loadVideoID(videoID)

            
            /*
            if videoPlayer.ready {
                if videoPlayer.playerState != YouTubePlayerState.Playing {
                    videoPlayer.play()
                } else {
                    videoPlayer.pause()
                }
            }
            */
            
            
            
            /*
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                println("Loading video...")
                self.checkVideoLoaded()
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    sleep(2)
                    println("Ready now!")
                    self.videoPlayer.play()
                }
                
            }
            */
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func checkVideoLoaded() {
        while !videoPlayer.ready {
            println("checking for videoPlayer.ready")
        }
        
        
    }
    */
    
    // MARK: YouTubePlayerDelegate
    // These are all required. See https://github.com/gilesvangruisen/Swift-YouTube-Player/
    func playerReady(videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
    
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if videoPlayer.playerState == YouTubePlayerState.Ended {
            println("Ended")
            //self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if videoPlayer.playerState == YouTubePlayerState.Paused {
            println("Paused")
            //self.navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        println("Quality has changed")
    }
    
    

}
