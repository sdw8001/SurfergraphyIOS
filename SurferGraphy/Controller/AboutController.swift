//
//  AboutController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 21..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class AboutController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addLeftButton(image: #imageLiteral(resourceName: "close.png"), gesture: UITapGestureRecognizer(target: self, action: #selector(closeView)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
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
