//
//  AlertController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 21..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class AlertController {
    
    private var controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private var rootController: UIViewController?
    
    init(_ rootController: UIViewController) {
        self.rootController = rootController
    }
    
    func showPopup(title: String?, message: String?) -> AlertController {
        
        controller.title = title
        controller.message = message
        
        return self
    }
    
    func addCancelButton(title: String, handler: (() -> ())?) -> AlertController {
        
        let action = UIAlertAction(title: title, style: .cancel, handler: { action in
            self.controller.dismiss(animated: false, completion: nil)
            handler?()
        })
        controller.addAction(action)
        
        return self
    }
    
    func addDefaultButton(title: String, handler: (() -> ())?) -> AlertController {
        
        let action = UIAlertAction(title: title, style: .default, handler: { action in
            self.controller.dismiss(animated: false, completion: nil)
            handler?()
        })
        controller.addAction(action)
        
        return self
    }
    
    func addDdestructiveButton(title: String, handler: (() -> ())?) -> AlertController {
        
        let action = UIAlertAction(title: title, style: .destructive, handler: { action in
            self.controller.dismiss(animated: false, completion: nil)
            handler?()
        })
        controller.addAction(action)
        
        return self
    }
    
    func show() {
        rootController?.present(controller, animated: false, completion: nil)
    }
    
}
