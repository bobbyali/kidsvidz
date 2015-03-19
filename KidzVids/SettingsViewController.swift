//
//  SettingsViewController.swift
//  KidzVids
//
//  Created by Bobby on 18/03/2015.
//  Copyright (c) 2015 AzukiApps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var playlistSelector: UIPickerView!
    @IBOutlet weak var newPlaylistTitle: UITextField!
    @IBOutlet weak var newPlaylistID: UITextField!
    
    var playlists: PlaylistCollection?
    var playlistIndex: Int? = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // set up the playlist selector picker
        playlistSelector.dataSource = self
        playlistSelector.delegate = self
        playlistSelector.selectRow(playlistIndex!, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            let parentVC = navigationController.viewControllers[0] as GridViewController
            parentVC.playlistIndex = self.playlistIndex!
        }
    }
    

    //MARK: Playlist Selector
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let playlists = self.playlists {
            return playlists.list.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return playlists?.list[row].title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return self.playlistIndex = row
    }

    
    @IBAction func saveNewPlaylist(sender: AnyObject) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
