//
//  HomeVC+CollectionView.swift
//  My_Moment
//
//  Created by Shashikant Bhadke on 07/06/20.
//  Copyright © 2020 Shashikant Bhadke. All rights reserved.
//

import UIKit

// MARK:- Extension For:- UICollectionViewDelegate
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeCell {
            if cell.isPlaying {
                cell.pause(index: indexPath.item)
            } else {
                cell.play(false, index: indexPath.item)
            }
        }
    }
    
} //extension

// MARK:- Extension For:- UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCell {
            cell.play(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCell {
            cell.pause(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCell.self), for: indexPath) as? HomeCell, let obj = arrVideo[arrKeys[indexPath.item]] else { return HomeCell() }
        
        cell.setUpVideo(indexPath.item, obj, isFullScreen)
        cell.onComplection = { [weak self] index in
            guard let self = self else { return }
            if index + 1 < self.arrVideo.count {
                let indexP = IndexPath(item: index + 1, section: 0)
                collectionView.scrollToItem(at: indexP, at: .centeredVertically, animated: true)
            }
        }
        cell.onFullScreenBtnPressed = { [weak self] in
            guard let self = self else { return }
            self.isFullScreen.toggle()
        }
        
        return cell
    }
} //extension

// MARK:- Extension For:- UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
} //extension
