//
//  ViewController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 9..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionViewDate: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    private var photoArray: [Photo] = Array<Photo>()
    private var dateArray: [PhotoDate] = Array<PhotoDate>()
    
    private var clickedDateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "list_128.png"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedCategory)))
        
        let barItem = UIBarButtonItem(customView: button)
        
        if #available(iOS 11.0, *) {
            barItem.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
            barItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        }
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = barItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewDate.delegate = self
        collectionViewDate.dataSource = self
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.size.width / 3, height: collectionViewDate.bounds.height)
        collectionViewDate.collectionViewLayout = layout

        
        RequestAPI.getAllDate { dates in
            self.dateArray = dates
            self.collectionViewDate.reloadData()
            
            if self.dateArray.count == 0 {
                return
            }
            
            self.dateArray[0].isClicked = true
            self.getPhotos(date: self.dateArray[0].date)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return photoArray.count
        }
        else if collectionView == collectionViewDate {
            return dateArray.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            
            //cell.imageViewPhoto.image = UIImage(named: "\(indexPath.row % 7 + 1).jpg")
            
            if let url = photoArray[indexPath.row].url {
                cell.imageViewPhoto.sd_setImage(with: URL(string: url), completed: nil)
            }
            
            //print(cell.contentView.frame.width)
            
            return cell
        }
        else if collectionView == self.collectionViewDate {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
            
            cell.labelDate.text = dateArray[indexPath.row].date
            
            if dateArray[indexPath.row].isClicked {
                cell.labelDate.backgroundColor = UIColor.black
                cell.labelDate.textColor = UIColor.white
            }
            else {
                cell.labelDate.backgroundColor = UIColor.white
                cell.labelDate.textColor = UIColor.black
            }
            
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoPageController") as? DetailPhotoPageController else {
                return
            }
            
            controller.photoArray = photoArray
            controller.index = indexPath.row
            
            navigationController?.show(controller, sender: nil)
        }
        else if collectionView == self.collectionViewDate {
            
            self.dateArray[clickedDateIndex].isClicked = false
            
            self.dateArray[indexPath.row].isClicked = true
            
            self.clickedDateIndex = indexPath.row
            
            self.collectionViewDate.reloadData()
            getPhotos(date: self.dateArray[indexPath.row].date)
        }
    }
    
    private func getPhotos(date: String) {
        RequestAPI.getPhotos(date: date, response: { photos in
            photos.forEach {photo in
                //print(photo.url)
                
                
            }
            
            self.photoArray = photos
            self.collectionView.reloadData()
        })
    }
    
    
    @objc private func clickedCategory() {
        let controller = NationListController(nibName: "NationListController", bundle: nil)
        
        let popup = PopupDialog(viewController: controller, buttonAlignment: .vertical, transitionStyle: .fadeIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false, completion: nil)
        
        controller.selectedNation = { nationType in
            
            //popup.dismiss(animated: false, completion: nil)
            
            guard let navController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoListNavController") as? UINavigationController else {
                return
            }
            
            guard let controller = navController.topViewController as? PhotoListController else {
                return
            }
            
            controller.type = nationType
            
            popup.present(navController, animated: true, completion: nil)
            
            
        }
        
        present(popup, animated: true, completion: nil)
    }

}

