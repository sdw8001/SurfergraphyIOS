//
//  SignInController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 11..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewEmail.layer.cornerRadius = 4
        viewEmail.layer.borderColor = UIColor.black.cgColor
        viewEmail.layer.borderWidth = 1
        
        viewPassword.layer.cornerRadius = 4
        viewPassword.layer.borderColor = UIColor.black.cgColor
        viewPassword.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
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
