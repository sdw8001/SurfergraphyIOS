//
//  CollectionController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 21..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import M13Checkbox
import Photos
import SDWebImage

class DownloadController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonRight: UIBarButtonItem!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    private var photoArray: [Photo] = Array<Photo>()
    private var buyHistoryPhotoDict: [Int: Bool] = [:]
    
    private var selectedItemCount = 0
    private var downloadedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLeftButton(image: #imageLiteral(resourceName: "close.png"), gesture: UITapGestureRecognizer(target: self, action: #selector(closeView)))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "SourceSansPro-It", size: 17)], for: .selected)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "SourceSansPro-It", size: 17)], for: .normal)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshPhotos()
        refreshBuyHistoryPhoto()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPhotoCell", for: indexPath) as! CollectionPhotoCell
        
        if cell.checkBox == nil {
            cell.checkBox = M13Checkbox(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            cell.checkBox?.secondaryTintColor = UIColor.white
            cell.checkBox?.tintColor = UIColor.white
            cell.checkBox?.checkmarkLineWidth = 2
            cell.checkBox?.boxLineWidth = 2
            //cell.check
            cell.checkBox?.layer.masksToBounds = true
            cell.checkBoxView.addSubview(cell.checkBox!)
        }
        
        //print(cell.checkBox)
        if photoArray[indexPath.row].isClick {
            cell.checkBox?.setCheckState(.checked, animated: true)
        }
        else {
            cell.checkBox?.setCheckState(.unchecked, animated: true)
        }
        
        if photoArray[indexPath.row].isSelectMode {
            cell.checkBoxView.isHidden = false
        }
        else {
            cell.checkBoxView.isHidden = true
        }
        
        
        if let url = photoArray[indexPath.row].url {
            cell.imageViewPhoto.sd_setImage(with: URL(string: url), completed: nil)
        }
        
        print(cell.contentView.frame.width)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photoArray[indexPath.row].isSelectMode {
            photoArray[indexPath.row].isClick = !photoArray[indexPath.row].isClick
            collectionView.reloadItems(at: [indexPath])
            //collectionView.reloadData()
        }
        else {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoPageController") as? DetailPhotoPageController else {
                return
            }
            
            controller.photoArray = photoArray
            controller.index = indexPath.row
            
            navigationController?.show(controller, sender: nil)
        }
    }
    
    private func refreshBuyHistoryPhoto() {
        guard let userId = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        
        RequestAPI.getPhotoBuyHistoryUserPhoto(userId: userId, response: { dict in
            self.buyHistoryPhotoDict = dict
        })
    }
    
    private func refreshPhotos() {
        
        guard let userId = UserDefaults.standard.string(forKey: "id") else {
            return
        }
        
        RequestAPI.getUserPhotosInfo(userId: userId, response: { photos in
            photos.forEach { photo in
                print(photo)
            }
            
            self.photoArray = photos
            self.collectionView.reloadData()
        })
    }
    
    private func showPopup() {
        AlertController(self).showPopup(title: nil, message: "Would you like to download selected pictures?")
        .addDdestructiveButton(title: "NO", handler: nil)
        .addDefaultButton(title: "YES", handler: {
            self.savePhotos()
        })
        .show()
    }
    
    private func savePhotos() {
        //let viewPhoto = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.35))
        let imageViewPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.35))
        
        //viewPhoto.addSubview(imageViewPhoto)
        //view.addSubview(viewPhoto)
        //viewPhoto.isHidden = true
        
        
        photoArray.forEach { photo in
            if photo.isClick {
                if let url = photo.url {
                    
                    if let photoId = photo.id, let _ = buyHistoryPhotoDict[photoId] {
                        imageViewPhoto.sd_setImage(with: URL(string: url), completed: { (image, error, cacheType, url) in
                            
                            guard let image = image else {
                                return
                            }
                            
                            UIImageWriteToSavedPhotosAlbum(image, self.completionSavedImage(), nil, nil)
                        })
                    }
                    else {
                        imageViewPhoto.sd_setImage(with: URL(string: url), completed: { (image, error, cacheType, url) in
                            
                            guard let image = image else {
                                return
                            }
                            
                            let bottomImage = image
                            let topImage = #imageLiteral(resourceName: "surfergraphy_final_1_width1200px_W.png")
                            
                            let bottomImageSize = CGSize(width: image.size.width, height: image.size.height)
                            UIGraphicsBeginImageContext(bottomImageSize)
                            
                            let areaSize = CGRect(x: 0, y: 0, width: bottomImageSize.width, height: bottomImageSize.height)
                            bottomImage.draw(in: areaSize)
                            
                            let topImageWidthRatio = bottomImageSize.width * 0.75 / topImage.size.width
                            
                            let topImageWidth = bottomImageSize.width * 0.75
                            let topImageHeight = topImage.size.height * topImageWidthRatio
                            
                            let topImageSize = CGRect(x: (bottomImageSize.width / 2) - (topImageWidth / 2), y: (bottomImageSize.height / 2) - (topImageHeight / 2), width: topImageWidth, height: topImageHeight)
                            
                            topImage.draw(in: topImageSize, blendMode: .normal, alpha: 0.6)
                            print(topImageSize)
                            
                            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                            UIGraphicsEndImageContext()
                            
                            UIImageWriteToSavedPhotosAlbum(newImage, self.completionSavedImage(), nil, nil)
                        })
                    }
                }
            }
        }
    }
    
    @objc private func completionSavedImage() {
        //print("사진 저장 완료")
        
        downloadedCount += 1
        
        if selectedItemCount == downloadedCount {
            downloadedCount = 0
            buttonRight.title = "Select"
            
            photoArray.forEach { photo in
                photo.isSelectMode = false
                photo.isClick = false
            }
            
            collectionView.reloadData()
            
            AlertController(self).showPopup(title: nil, message: "Selected photos have been saved in Gallery.")
            .addDefaultButton(title: "OK", handler: nil)
            .show()
        }
    }
    
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedSelect(_ sender: UIBarButtonItem) {
        if sender.title == "Select" {
            
            photoArray.forEach { photo in
                photo.isSelectMode = true
            }
            
            collectionView.reloadData()
            selectedItemCount = 0
            
            sender.title = "Cancel"
        }
        else {
            
            photoArray.forEach { photo in
                photo.isSelectMode = false
                photo.isClick = false
            }
            
            collectionView.reloadData()
            
            sender.title = "Select"
        }
    }
    
    @IBAction func clickedDownload(_ sender: UIButton) {
        
        if selectedItemCount == 0 {
            AlertController(self).showPopup(title: nil, message: "No photos selected.")
                .addDefaultButton(title: "OK", handler: nil).show()
            return
        }
        
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .notDetermined {
            
            PHPhotoLibrary.requestAuthorization({status in
                
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.showPopup()
                    }
                } else {
                    
                }
            })
        }
        else {
            DispatchQueue.main.async {
                self.showPopup()
            }
        }
    }
}
