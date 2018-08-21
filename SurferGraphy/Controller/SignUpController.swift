//
//  SignUpController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 20..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class SignUpController: BaseViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldVerificationCode: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfrimPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLeftButton(image: #imageLiteral(resourceName: "close.png"), gesture: UITapGestureRecognizer(target: self, action: #selector(closeView)))
        // Do any additional setup after loading the view.
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedView)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func clickedView() {
        view.endEditing(true)
    }

    @IBAction func clickedSignup(_ sender: UIButton) {
        
        guard let email = textFieldEmail.text, !email.isEmpty else {
            return
        }
        
        guard let password = textFieldPassword.text, !password.isEmpty else {
            return
        }
        
        guard let confirmPassword = textFieldConfrimPassword.text, !confirmPassword.isEmpty else {
            return
        }
        
        guard let name = textFieldName.text, !name.isEmpty else {
            return
        }
        
        
        let member = RequestMember(Id: email, Email: email, JoinType: "E", Name: name, ImageUrl: "", password: password)
        
        RequestAPI.joinMember(member: member, response: { isComplete in
            if isComplete {
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.set("E", forKey: "loginType")
                UserDefaults.standard.set(email, forKey: "id")
                UserDefaults.standard.set("", forKey: "imageUrl")
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        
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
