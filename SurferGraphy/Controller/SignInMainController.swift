//
//  SignInMainController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 10..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin
import FacebookCore


class SignInMainController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var buttonFacebook:UIView!
    @IBOutlet weak var buttonGoogle: UIView!
    @IBOutlet weak var buttonEmail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        buttonGoogle.layer.borderWidth = 1
        buttonGoogle.layer.borderColor = UIColor.gray.cgColor
        buttonGoogle.layer.cornerRadius = 4
        
        buttonEmail.layer.borderWidth = 1
        buttonEmail.layer.borderColor = UIColor.gray.cgColor
        buttonEmail.layer.cornerRadius = 4
        
        buttonFacebook.layer.cornerRadius = 4
        
        buttonEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedEmail)))
        buttonFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedFacebook)))
        buttonGoogle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedGoogle)))
        
//        if let profile = GIDSignIn.sharedInstance().currentUser {
//            print("aa\n" + profile.profile.email)
//        }
//
//        if let token = AccessToken.current {
//            print(token)
//        }
//        if let user = UserProfile.current {
//            print("aa\n" + user.userId)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let loginType = UserDefaults.standard.string(forKey: "loginType") else {
            return
        }
        if loginType == "G" && UserDefaults.standard.bool(forKey: "isLogin") {
            //showMainView()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        }
        else {
            print(user.profile.email)
            RequestAPI.getMemberId(id: user.userID, response: { (isExist, imageUrl) in
                if isExist {
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.set("G", forKey: "loginType")
                    UserDefaults.standard.set(user.userID, forKey: "id")
                    if let url = imageUrl {
                        UserDefaults.standard.set(url, forKey: "imageUrl")
                    }
                    UserDefaults.standard.synchronize()
                    print("success google login")
                    self.showMainView()
                }
                else {
                    
                    let member = RequestMember(Id: user.userID, Email: user.profile.email, JoinType: "G", Name: user.profile.name, ImageUrl: user.profile.imageURL(withDimension: 400).absoluteString, password: "")
                    
                    RequestAPI.joinMember(member: member, response: { isComplete in
                        if isComplete {
                            UserDefaults.standard.set(true, forKey: "isLogin")
                            UserDefaults.standard.set("G", forKey: "loginType")
                            UserDefaults.standard.set(user.userID, forKey: "id")
                            UserDefaults.standard.set(member.ImageUrl, forKey: "imageUrl")
                            UserDefaults.standard.synchronize()
                            self.showMainView()
                        }
                    })
                }
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error)
    }
    
    private func showMainView() {
        guard let tabController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            return
        }
        self.present(tabController, animated: false, completion: nil)
        
    }
   
    private func loginFacebook(userProfile: [String: Any]) {
        
        guard let picture = userProfile["picture"] as? [String: Any], let data = picture["data"] as? [String: Any], let url = data["url"] as? String else {
            return
        }
        
        let id = userProfile["id"] as! String
        let name = userProfile["name"] as! String
        let email = userProfile["email"] as! String
        
        RequestAPI.getMemberId(id: id, response: { (isExist, imageUrl) in
            if isExist {
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.set("F", forKey: "loginType")
                UserDefaults.standard.set(id, forKey: "id")
                UserDefaults.standard.set(imageUrl, forKey: "imageUrl")
                UserDefaults.standard.synchronize()
                self.showMainView()
            }
            else {

                let member = RequestMember(Id: id, Email: email, JoinType: "G", Name: name, ImageUrl: url, password: "")

                RequestAPI.joinMember(member: member, response: { isComplete in
                    if isComplete {
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        UserDefaults.standard.set("F", forKey: "loginType")
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(url, forKey: "imageUrl")
                        UserDefaults.standard.synchronize()
                        self.showMainView()
                    }
                })
            }
        })
    }
    
    @objc private func clickedGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc private func clickedFacebook() {
        let manager = LoginManager.init()
        
        manager.loginBehavior = .native
        
        manager.logIn(readPermissions: [.email, .publicProfile], viewController: UIApplication.shared.keyWindow?.rootViewController, completion: { result in
            switch result {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("cancelled")
            case .success(let grantedPermissions, _, _):
                print(grantedPermissions)
                
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (response, result) in
                    
                    switch result {
                    case .success(let graphResponse):
                        
                        if let graph = graphResponse.dictionaryValue {
                            self.loginFacebook(userProfile: graph)
                            print(graph)
                        }
                        
                    case .failed(let error):
                        print(error)
                    }
                    
                }
            }
        })
    }
    
    @objc private func clickedEmail() {
        performSegue(withIdentifier: "SignInSegue", sender: nil)
    }
    

}
