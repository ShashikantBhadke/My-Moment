//
//  AddPostVC.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

final class AddPostVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet private weak var btnHide          : UIButton!
    @IBOutlet private weak var btnUpload        : UIButton!
    @IBOutlet private weak var btnAudio         : UIButton!
    @IBOutlet private weak var btnVideo         : UIButton!
    @IBOutlet private weak var btnPlay          : UIButton!
    @IBOutlet private weak var viewVideo        : UIView!
    @IBOutlet private weak var txtvDescription  : UITextView!
    
    // MARK:- Variable
    var videoURL: URL?
    var audioURL: URL?
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var playerProgress: Any?
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingFromParent {
            player = nil
            playerLayer = nil
            playerProgress = nil
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    // MARK:- SetUpView
    
    func setUpView() {
        txtvDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtvDescription.layer.cornerRadius = 10
        txtvDescription.layer.borderWidth = 1
        txtvDescription.isHidden = true
        btnAudio.isHidden = true
    }
    
    // MARK:- Button Action
    @IBAction private func btnVideoPressed(_ sender: UIButton) {
        videoScreenOpen()
    }
    @IBAction private func btnAudioPressed(_ sender: UIButton) {
        if let url = audioURL {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.play()
            } catch {
                debugPrint(error.localizedDescription)
                audioScreenOpen()
            }
        } else {
            audioScreenOpen()
        }
    }

    @IBAction private func btnUploadPressed(_ sender: UIButton) {
        guard let vURL = videoURL else { return }
        self.showLoader()
        VideoPostModel.uploadVideo(vURL) { [weak self] (filePath) in
            guard let self = self else { return }
            if let path = filePath {
                VideoPostModel.addData(description: self.txtvDescription.text ?? "", url: path.absoluteString)
            } else {
                debugPrint("Function: \(#function), line: \(#line), Error: Unable to upload file")
                Alert.show(.appName, "Error: Unable to upload file")
            }
            self.hideLoader()
            self.pushToHome()
        }
    }
    
    @IBAction private func btnPlayPressed(_ sender: UIButton) {
        guard player != nil else { return }
        if player?.timeControlStatus == .playing {
            player?.pause()
            btnPlay.setImage(UIImage(named: "m_PlayVideo"), for: .normal)
        } else {
            btnPlay.setImage(UIImage(named: "m_PauseVideo"), for: .normal)
            player?.play()
        }
    }
    
    // MARK:- Custom Methods
    func setLocalVideo() {
        guard let url = videoURL else {
            viewVideo.isHidden = true
            btnPlay.isHidden = true
            btnUpload.isHidden = true
            playerProgress = nil
            txtvDescription.isHidden = true
            return
        }
        viewVideo.isHidden = false
        btnPlay.isHidden = false
        btnUpload.isHidden = false
        txtvDescription.isHidden = false
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = viewVideo.bounds
        if self.viewVideo.layer.sublayers?.first as? AVPlayerLayer != nil {
            self.viewVideo.layer.sublayers?.removeAll()
        }
        self.viewVideo.layer.insertSublayer(playerLayer!, at: 0)
        
        playerProgress = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            self.player?.seek(to: CMTime.zero)
            self.btnPlay.setImage(UIImage(named: "m_PlayVideo"), for: .normal)
        }
    }
    
    func pushToHome() {
        videoURL = nil
        audioURL = nil
        setLocalVideo()
        
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK:- ReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        debugPrint("⚠️🤦‍♂️⚠️ Receive Memory Warning on \(self) ⚠️🤦‍♂️⚠️")
    }
    
    // MARK:- Deinit
    deinit {
        debugPrint("🏹 Controller is removed from memory \(self) 🎯 🏆")
    }
    
} //class
