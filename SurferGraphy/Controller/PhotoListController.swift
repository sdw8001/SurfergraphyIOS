//
//  PhotoListController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 13..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class PhotoListController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionViewDate: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    private var photoArray: [Photo] = Array<Photo>()
    private var dateArray: [PhotoDate] = Array<PhotoDate>()
    
    private var clickedDateIndex = 0
    
    
    
    var type: Type?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLeftButton(image: #imageLiteral(resourceName: "close.png"), gesture: UITapGestureRecognizer(target: self, action: #selector(closeView)))
        
        
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
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.size.width / 3, height: collectionViewDate.bounds.height)
        collectionViewDate.collectionViewLayout = layout
        
        guard let type = type else {
            return
        }
        
        navigationItem.title = type.getName()
        
        RequestAPI.getDatesOfType(type: type.getType()) { dates in
            self.dateArray = dates
            self.collectionViewDate.reloadData()
            
            if self.dateArray.count > 0 {
                self.dateArray[0].isClicked = true
                self.getPhotos(type: type.getType(), date: self.dateArray[0].date)
            }
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
            
            print(cell.contentView.frame.width)
            
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
            
            guard let type = type else {
                return
            }
            
            getPhotos(type: type.getType(), date: self.dateArray[indexPath.row].date)
        }
    }
    
    private func getPhotos(type: String, date: String) {
        RequestAPI.getPhotosOfType(type: type, date: date, response: { photos in
            photos.forEach {photo in
                //print(photo.url)
                
            }
            
            self.photoArray = photos
            self.collectionView.reloadData()
        })
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
