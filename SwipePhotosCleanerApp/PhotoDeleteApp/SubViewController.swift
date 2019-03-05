//
//  SubViewController.swift
//  PhotoDeleteApp
//
//  Created by coco j on 2019/02/17.
//  Copyright © 2019 amaocha. All rights reserved.
//

import UIKit
import Photos

class SubViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: PHAsset!
    
    var uiViewControllerDelegate: UIViewControllerDelegate!
    
    //画像を削除する
    @IBAction func deleteButton(_ sender: Any) {
        
        uiViewControllerDelegate.deletePhotos()
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //画像を表示
        let manager: PHImageManager = PHImageManager()
        manager.requestImage(for: selectedImage,
                             targetSize: CGSize(width: 70, height: 70),
                             contentMode: .aspectFill,
                             options: nil) { (image, info) -> Void in
                                self.imageView.image = image
        }
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    
    

}
