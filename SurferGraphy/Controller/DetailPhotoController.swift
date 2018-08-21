//
//  DetailPhotoController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 16..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

class DetailPhotoController: UIViewController {

    var index: Int = -1
    var photo: Photo?
    
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var imageViewPhotographer: UIImageView!
    @IBOutlet weak var labelPhotographer: UILabel!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var labelWave: UILabel!
    
    @IBOutlet weak var viewFreeDownload: UIView!
    @IBOutlet weak var viewBuy: UIView!
    
    @IBOutlet weak var imageViewLike: UIImageView!
    
    var changedTitle: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = photo {
            imageViewPhoto.sd_setImage(with: URL(string: photo.url!), completed: nil)
            
            getPhtographerInfo(photographerId: photo.photographerId!)
            
            labelWave.text = String(photo.wave!)
            labelTotalCount.text = String(photo.totalCount!)
            
            if let place = photo.place {
                print(place)
                //navigationController?.navigationItem.title = getType(typeString: place).getName()
                changedTitle?(getType(typeString: place).getName())
            }
            
            if let photoId = photo.id {
                if let Id = ProfileController.likePhotoDict[photoId] {
                    imageViewLike.image = #imageLiteral(resourceName: "star_on.png")
                }
                else {
                    imageViewLike.image = #imageLiteral(resourceName: "star_off.png")
                }
            }
        }
        
        viewFreeDownload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(freeDownload)))
        
        viewBuy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedBuyDigitalDownload)))
        
        imageViewLike.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedLike)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        imageViewPhotographer.layer.cornerRadius = imageViewPhotographer.bounds.width / 2
        imageViewPhotographer.layer.masksToBounds = true
    }
    
    private func getPhtographerInfo(photographerId: String) {
        RequestAPI.getPhotographerInfo(photographerId: photographerId) {
            photographer in
            guard let photographer = photographer else {
                return
            }
            
            if let imageUrl = photographer.Image {
                self.imageViewPhotographer.sd_setImage(with: URL(string: imageUrl), completed: nil)
            }
            
            if let nickName = photographer.NickName {
                self.labelPhotographer.text = nickName
            }
        }
    }
    
    private func savedPhoto() {

        guard let bottomImage = imageViewPhoto.image else {
            return
        }
        let topImage = #imageLiteral(resourceName: "surfergraphy_final_1_width1200px_W.png")
        
        let bottomImageSize = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)
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
        
        //UIImageWriteToSavedPhotosAlbum(viewPhoto.takeScreenshot(), completionSavedImage(), nil, nil)
        
    }
    
    private func getType(typeString: String) -> Type {
        switch typeString {
        case "BP":
            return Type.BP
        case "EP":
            return Type.EP
        case "LP":
            return Type.LP
        case "PS":
            return Type.PS
        case "KOEC":
            return Type.KOEC
        case "KOSC":
            return Type.KOSC
        case "KOWC":
            return Type.KOWC
        case "KOJI":
            return Type.KOJI
        case "JP":
            return Type.JP
        case "CN":
            return Type.CN
        case "ID":
            return Type.ID
        case "PH":
            return Type.PH
        case "TW":
            return Type.TW
        case "US":
            return Type.US
        case "USHW":
            return Type.USHW
        case "AU":
            return Type.AU
        default:
            return Type.ETC
        }
    }
    
    @objc private func completionSavedImage() {
        
        guard let userId = UserDefaults.standard.string(forKey: "id"), let photoId = photo?.id else {
            return
        }
        
        RequestAPI.savePhotoHistory(userId: userId, photoId: photoId) { (photoSaveHistoryId, photoBuyHistoryId) in
            
            RequestAPI.saveUserPhoto(userId: userId, photoId: photoId, photoSaveHistoryId: photoSaveHistoryId, photoBuyHistoryId: photoBuyHistoryId)
            
            AlertController(self).showPopup(title: nil, message: "Saved.")
                .addDefaultButton(title: "OK", handler: nil)
                .show()
            
        }
    }
    
    
    @objc private func clickedLike() {
        
        guard let userId = UserDefaults.standard.string(forKey: "id"), let photoId = photo?.id else {
            return
        }
        
        guard let image = imageViewLike.image else {
            return
        }
        
        if image == #imageLiteral(resourceName: "star_on.png") {
            
            guard let likeId = ProfileController.likePhotoDict[photoId] else {
                return
            }
            
            RequestAPI.cancelLikePhoto(likeId: likeId, response: { completion in
                if completion {
                    self.imageViewLike.image = #imageLiteral(resourceName: "star_off.png")
                    ProfileController.refreshUserLikePhoto()
                }
                else {
                    self.imageViewLike.image = #imageLiteral(resourceName: "star_on.png")
                }
            })
        }
        else {
            RequestAPI.likePhoto(userId: userId, photoId: photoId, response: { completion in
                print(completion)
                if completion {
                    self.imageViewLike.image = #imageLiteral(resourceName: "star_on.png")
                    ProfileController.refreshUserLikePhoto()
                }
                else {
                    self.imageViewLike.image = #imageLiteral(resourceName: "star_off.png")
                }
            })
        }
        
        
    }
    
    @objc private func freeDownload() {
        
        self.savedPhoto()
        
        /*let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    
                } else {
                    
                }
            })
        }
        else {
            self.savedPhoto()
        }*/
    }
    
    @objc private func clickedBuyDigitalDownload() {
        guard let userId = UserDefaults.standard.string(forKey: "id"), let photoId = photo?.id else {
            return
        }
        
        print("clickedBuy")
        
        AlertController(self).showPopup(title: nil, message: "Would you like to buy this picture?")
            .addDdestructiveButton(title: "NO", handler: nil)
            .addDefaultButton(title: "YES", handler: {
                RequestAPI.savePhotoBuyHistory(userId: userId, photoId: photoId, response: {
                    
                    RequestAPI.savePhotoHistory(userId: userId, photoId: photoId) { (photoSaveHistoryId, photoBuyHistoryId) in
                        RequestAPI.saveUserPhoto(userId: userId, photoId: photoId, photoSaveHistoryId: photoSaveHistoryId, photoBuyHistoryId: photoBuyHistoryId)
                        AlertController(self).showPopup(title: nil, message: "Purchased.")
                            .addDefaultButton(title: "OK", handler: nil)
                            .show()
                        
                    }
                })
            })
            .show()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
