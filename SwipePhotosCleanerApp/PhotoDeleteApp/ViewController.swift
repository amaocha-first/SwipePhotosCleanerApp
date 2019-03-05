//
//  ViewController.swift
//  PhotoDeleteApp
//
//  Created by coco j on 2019/02/17.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import Photos
import Intents

protocol UIViewControllerDelegate {
    func deletePhotos()
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UIViewControllerDelegate {
    
    var photoAssets = [PHAsset]()
    
    var selectedImage: PHAsset?
    var removeInt: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //画像を全て取得する
    private func getAllPhotosInfo() {
        photoAssets = []
        
        // 画像をすべて取得
        var assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as PHAsset)
            print("did append!")
        }
        print(photoAssets)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //コレクションビューから識別子「TestCell」のセルを取得する。
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as UICollectionViewCell
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        
        //画像を表示
        let manager: PHImageManager = PHImageManager()
        manager.requestImage(for: photoAssets[indexPath.row],
                             targetSize: CGSize(width: 70, height: 70),
                             contentMode: .aspectFill,
                             options: nil) { (image, info) -> Void in
                                imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数は１つ
        return 1
    }
    
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImage = photoAssets[indexPath.row]
        removeInt = indexPath.row
        if selectedImage != nil {
            performSegue(withIdentifier: "goToSubVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToSubVC") {
            let subVC: SubViewController = (segue.destination as? SubViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            subVC.selectedImage = selectedImage
            subVC.uiViewControllerDelegate = self
        }
    }
    
    func deletePhotos() {
        
        if selectedImage != nil {
            PHPhotoLibrary.shared().performChanges({ () -> Void in
                // 削除などの変更はこのblocks内でリクエストする
                PHAssetChangeRequest.deleteAssets([self.selectedImage!] as NSFastEnumeration)
                
            }, completionHandler: { (success, error) -> Void in
                
                if (success) {
                    print("success!")
                    
                    self.dismiss(animated: true, completion: {
                        self.updateCollectionView()
                    })
                    
                } else {
                    print("error!")
                }
                
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllPhotosInfo()
    }
    
    
    func updateCollectionView() {
        
        photoAssets.remove(at: removeInt)
        print("remove PhotoAssets: \(photoAssets)")
        collectionView.reloadData()
    }
    
}



