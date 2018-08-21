//
//  BaseViewController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 20..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLeftButton(image: UIImage, gesture: UITapGestureRecognizer) {
        let button = UIButton.init(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addGestureRecognizer(gesture)
        
        let barItem = UIBarButtonItem(customView: button)
        
        if #available(iOS 11.0, *) {
            barItem.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
            barItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        }
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = barItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
