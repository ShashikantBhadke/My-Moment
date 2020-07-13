//
//  HomeCell.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import AVFoundation

final class HomeCell: UICollectionViewCell {
    
    // MARK:- Variables
    var isPlaying = false
    fileprivate var player: AVPlayer?
    fileprivate var playerObserver: Any?
    fileprivate var playerBuffering: Any?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var isFullScreen = false
    
    var onFullScreenBtnPressed: (()->())?
    var onComplection: ((Int)->())?
    var obj: VideoPostModel?
    
    // MARK:- Outlets
    @IBOutlet private weak var viewBG       : UIView!
    @IBOutlet private weak var imgvPlay     : UIImageView!
    @IBOutlet private weak var indicator    : UIActivityIndicatorView!
    @IBOutlet private weak var btnExpand    : UIButton!
    @IBOutlet private weak var lblName      : UILabel!
    @IBOutlet private weak var lblDesc      : UILabel!
    @IBOutlet private weak var lblDate      : UILabel!
    
    // MARK:- Default Methods
    override func awakeFromNib() {
        self.contentView.backgroundColor = .black
        viewBG.backgroundColor = .black
        imgvPlay.layer.cornerRadius = 10
    }
    
    // MARK:- Custom Methods
    func setUpVideo(_ index: Int, _ obj: VideoPostModel,_ isFullScreen: Bool) {
        guard let url = URL(string: obj.url) else { return }
        
        lblName.text = !(obj.user?.name ?? "").isEmpty ? (obj.user?.name ?? "") : (obj.user?.email ?? "")
        lblDate.text = obj.createdOn ?? ""
        lblDesc.text = obj.description ?? ""
        
        self.isFullScreen = isFullScreen
        self.obj = obj
        removeObserver()
        player = AVPlayer(url: url)
        // AVPlayerLooper
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = isFullScreen ? AVLayerVideoGravity.resizeAspectFill : AVLayerVideoGravity.resizeAspect
        playerLayer?.frame = self.bounds
        if self.viewBG.layer.sublayers?.first as? AVPlayerLayer != nil {
            self.viewBG.layer.sublayers?.removeAll()
        }
        self.viewBG.layer.insertSublayer(playerLayer!, at: 0)
        
        btnExpand.setImage(UIImage(named: isFullScreen ? "m_Compress" : "m_Expand"), for: .normal)
                
        playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            self.onComplection?(index)
            //debugPrint("Video Ended restart called.")
            self.player?.seek(to: CMTime.zero)
            //self.player?.play()
            self.pause(index: index)
        }
        self.indicator.startAnimating()
        self.playerBuffering = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main) {
            [weak self] time in
            guard let self = self else { return }
            if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                if let isPlaybackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp {
                    if isPlaybackLikelyToKeepUp {
                        self.indicator.stopAnimating()
                    } else {
                        self.indicator.startAnimating()
                    }
                }
            } else {
                self.indicator.stopAnimating()
            }
        }
    }
    
    func play(_ isRestart: Bool = true, index: Int) {
        guard obj != nil else { return }
        imgvPlay.isHidden = true
        if player != nil {
            //debugPrint("Play called", index)
            if isRestart {
                player?.seek(to: CMTime.zero)
            }
            player?.play()
            isPlaying = true
        }
    }
    func pause(index: Int) {
        guard obj != nil else { return }
        imgvPlay.isHidden = false
        if player != nil {
            //debugPrint("Paused called", index)
            player?.pause()
            isPlaying = false
        }
    }
    func removeObserver(_ isCompletely: Bool = false) {
        guard obj != nil else { return }
        if isCompletely {
            player = nil
        }
        playerBuffering = nil
        guard let observer = playerObserver else { return }
        playerObserver = nil
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK:- Custom Methods
    
    
    // MARK :- Button Action
    @IBAction private func btnExpandCompressPressed(_ sender: UIButton) {
        isFullScreen.toggle()
        playerLayer?.videoGravity = isFullScreen ? AVLayerVideoGravity.resizeAspectFill : AVLayerVideoGravity.resizeAspect
        btnExpand.setImage(UIImage(named: isFullScreen ? "m_Compress" : "m_Expand"), for: .normal)
        onFullScreenBtnPressed?()
    }
    
    deinit {
        guard obj != nil else { return }
        removeObserver(true)
    }
} //class
