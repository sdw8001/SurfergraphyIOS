//
//  MoreController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 13..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class MoreController: UIViewController {

    @IBOutlet weak var viewBestPhoto: UIView!
    @IBOutlet weak var viewEvent: UIView!
    @IBOutlet weak var viewLesson: UIView!
    @IBOutlet weak var viewPersonal: UIView!
    
    @IBOutlet weak var viewDownload: UIView!
    @IBOutlet weak var viewAbout: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBestPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedMenu(_:))))
        viewEvent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedMenu(_:))))
        viewLesson.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedMenu(_:))))
        viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedMenu(_:))))
        
        viewDownload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedDownload)))
        viewAbout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedAbout)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func clickedMenu(_ sender: UITapGestureRecognizer) {
        
        guard let view = sender.view else {
            return
        }
        
        guard let navController = storyboard?.instantiateViewController(withIdentifier: "PhotoListNavController") as? UINavigationController else {
            return
        }
        
        guard let controller = navController.topViewController as? PhotoListController else {
            return
        }
        
        switch view {
        case viewBestPhoto:
            controller.type = Type.BP
        case viewEvent:
            controller.type = Type.EP
        case viewLesson:
            controller.type = Type.LP
        case viewPersonal:
            controller.type = Type.PS
        default:
            break
        }
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func clickedDownload() {
        performSegue(withIdentifier: "download", sender: nil)
    }
    
    @objc private func clickedAbout() {
        guard let navController = storyboard?.instantiateViewController(withIdentifier: "navAboutController") as? UINavigationController else {
            return
        }
        
        present(navController, animated: true, completion: nil)
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
