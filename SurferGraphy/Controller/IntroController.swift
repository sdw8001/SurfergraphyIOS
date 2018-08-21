//
//  IntroController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 10..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class IntroController: UIViewController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewCampaign: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 3, animations: {
            self.imageViewLogo.alpha = 1.0
        }, completion: { b in
            if b {
                UIView.animate(withDuration: 3, animations: {
                    self.imageViewLogo.alpha = 0.0
                }, completion: { b in
                    if b {
                        self.showCampaign()
                    }
                })
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showCampaign() {
        let number: UInt32 = arc4random_uniform(4) + 1
        
        imageViewCampaign.image = UIImage(named: "loading_images-0\(number).jpg")
        imageViewCampaign.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            
            if UserDefaults.standard.bool(forKey: "isLogin") {
                self.showMainView()
                return
            }
            
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInMainController") as? SignInMainController else {
                return
            }
            
            self.present(controller, animated: true, completion: nil)
        })
    }
    
    private func showMainView() {
        guard let tabController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            return
        }
        
        self.present(tabController, animated: false, completion: nil)
    }

}
