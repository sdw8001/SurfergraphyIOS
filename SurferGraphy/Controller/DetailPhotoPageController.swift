//
//  DetailPhotoPageController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 16..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class DetailPhotoPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var index: Int = -1
    var photoArray: [Photo] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "back.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popView)))
        
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
        
        self.delegate = self
        self.dataSource = self
        
        // Do any additional setup after loading the view.
       
        if index < 0 {
            return
        }
        
        let controller = viewControllerAtIndex(index: index)
        
        
        setViewControllers([controller] as! [UIViewController], direction: .forward, animated: false, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! DetailPhotoController).index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! DetailPhotoController).index
        
        if photoArray.count - 1 <= index {
            return nil
        }
        
        index += 1
        
        return viewControllerAtIndex(index: index)
    }
    

    private func viewControllerAtIndex(index: Int) -> DetailPhotoController? {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoController") as? DetailPhotoController
        
        controller?.photo = photoArray[index]
        controller?.index = index
        controller?.changedTitle = { title in
            self.navigationItem.title = title
        }
        
        print(index)
        
        return controller
        
    }
    
    @objc private func popView() {
        navigationController?.popViewController(animated: true)
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
