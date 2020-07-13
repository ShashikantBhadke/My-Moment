//
//  HomeVC.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit
import Firebase

final class HomeVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK:- Variable
    private let refreshControl = UIRefreshControl()
    var arrVideo = VideoPostObj()
    var arrKeys = [String]()
    var isFullScreen = false
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getListing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrVideo.isEmpty || (self.tabBarController as? TabBarVC)?.user == nil {
            getListing()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard !self.isMovingFromParent else { return }
        if let cell = collectionView.visibleCells.first as? HomeCell {
            cell.pause(index: 0)
        }
    }
    
    // MARK:- SetUpView
    private func setUpView() {
        self.view.backgroundColor = .black
        self.collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    private func getListing() {
        self.showLoader()
        VideoPostModel.getListing { [weak self] (arr) in
            guard let self = self else { return }
            self.hideLoader()
            self.arrKeys = Array(arr.keys)
            self.arrKeys = self.arrKeys.sorted { $0 > $1 }
            
            self.arrVideo = arr
            if arr.isEmpty && Auth.auth().currentUser == nil {
                Alert.show(.appName, "Try after sign in...") { [weak self] btn in
                    guard let self = self else { return }
                    self.tabBarController?.selectedIndex = 2
                }
            } else {
                self.checkNewVideoAdded()
            }
            self.collectionView.reloadData()
        }
    }
    
    private func checkNewVideoAdded() {
        VideoPostModel.newVideoAdded { [weak self] (key, obj) in
            guard let self = self, let obj = obj else { return }
            if !self.arrKeys.contains(key) {
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .darkGray
                self.view.makeToast("New Video Available", duration: 2.0, position: .top, style: style) { didTap in
                    if didTap {
                        self.collectionView.reloadData()
                    }
                }
                self.arrKeys.insert(key, at: 0)
                self.arrVideo[key] = obj
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                /**
                 // For Update Only
                 self.collectionView.performBatchUpdates({
                    self.arrKeys.insert(key, at: 0)
                    self.arrVideo[key] = obj
                    self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                }, completion: nil)*/
            }
        }
    }
    
    // MARK:- Button Action
    
    // MARK:- Custom Methods
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        refreshControl.endRefreshing()
        getListing()
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
