//
//  ProfileController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 13..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileController: UIViewController {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelWaveCount: UILabel!
    
    static var likePhotoDict: [Int: Int] = [:]
    
    @IBOutlet weak var viewSignOut: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrl = UserDefaults.standard.string(forKey: "imageUrl") {
            imageViewProfile.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        if let id = UserDefaults.standard.string(forKey: "id") {
            RequestAPI.getUserInfo(id: id, response: { json in
                guard let json = json else {
                    return
                }
                
                self.labelEmail.text = json["Email"].stringValue
                self.labelWaveCount.text = String(json["Wave"].intValue)
            })
        }
        
        ProfileController.refreshUserLikePhoto()
        
        viewSignOut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedSignout)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        imageViewProfile.layer.cornerRadius = imageViewProfile.bounds.width / 2
        imageViewProfile.layer.masksToBounds = true
    }
    
    static func refreshUserLikePhoto() {
        if let userId = UserDefaults.standard.string(forKey: "id") {
            RequestAPI.getUserLikePhotos(userId: userId, response: {likePhotoDict in
                self.likePhotoDict = likePhotoDict
                print(likePhotoDict)
            })
        }
    }

    @objc private func clickedSignout() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        tabBarController?.dismiss(animated: false, completion: {
//            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInMainController") as? SignInMainController else {
//                return
//            }
//
//            self.present(controller, animated: false, completion: nil)
        })
    }
    

}
