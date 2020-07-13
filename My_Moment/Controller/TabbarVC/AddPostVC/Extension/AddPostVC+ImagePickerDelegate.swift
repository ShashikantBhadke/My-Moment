//
//  AddPostVC+ImagePickerDelegate.swift
//  My_Moment
//
//  Created by Shashikant's_Macmini on 20/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import MobileCoreServices

// MARK:- Extension For :- UIImagePickerController
extension AddPostVC {
    
    func videoScreenOpen() {
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .camera
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = self
        self.present(mediaUI, animated: true, completion: nil)
    }
    
    func audioScreenOpen() {
        let mediaUI = MPMediaPickerController()
        mediaUI.delegate = self
        mediaUI.prompt = "Select Audio"
        self.present(mediaUI, animated: true, completion: nil)
    }
    
} //extension

// MARK:- Extension For :- UIImagePickerControllerDelegate
extension AddPostVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
            videoURL = url
            setLocalVideo()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
} //extension

// MARK:- Extension For :- UINavigationControllerDelegate
extension AddPostVC: UINavigationControllerDelegate {
    
} //extension
// MARK:- Extension For :- MPMediaPickerControllerDelegate
extension AddPostVC: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true) {
          let selectedSongs = mediaItemCollection.items
          guard let song = selectedSongs.first, let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else { return }
            self.audioURL = url
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
} //extension

