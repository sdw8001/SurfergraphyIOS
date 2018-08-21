//
//  BuyWaveController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 16..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit
import StoreKit

class BuyWaveController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var productArray = Array<SKProduct>()
    
    private var productImageDic: [String:UIImage] = ["sufergraphy.wave.5": #imageLiteral(resourceName: "inapp_x5.png"), "sufergraphy.wave.15": #imageLiteral(resourceName: "inapp_x15.png"), "sufergraphy.wave.55": #imageLiteral(resourceName: "inapp_x55.png"), "sufergraphy.wave.120": #imageLiteral(resourceName: "inapp_x120.png"), "sufergraphy.wave.280": #imageLiteral(resourceName: "inapp_x280.png"), "sufergraphy.wave.700": #imageLiteral(resourceName: "inapp_x700.png"), "sufergraphy.wave.1650": #imageLiteral(resourceName: "inapp_x1650.png"), "sufergraphy.wave.4000": #imageLiteral(resourceName: "inapp_x4000.png")]
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem + 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        collectionView.collectionViewLayout = layout
        
        let request = SKProductsRequest(productIdentifiers: Set(["sufergraphy.wave.5", "sufergraphy.wave.15", "sufergraphy.wave.55", "sufergraphy.wave.120", "sufergraphy.wave.280", "sufergraphy.wave.700", "sufergraphy.wave.1650", "sufergraphy.wave.4000"]))
        request.delegate = self
        request.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        response.products.forEach { product in
            self.productArray.append(product)
        }
        
        productArray.sort(by: {(product1, product2) in
            return (product1.price.doubleValue < product2.price.doubleValue) ? true : false
        })
        
        self.collectionView.reloadData()
        
        productArray.forEach({product in
            print(product.productIdentifier)
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            let price1Str = numberFormatter.string(from: product.price)
            print(price1Str)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = productArray[indexPath.row].priceLocale
        let price1Str = numberFormatter.string(from: productArray[indexPath.row].price)
        
        cell.buttonPrice.setTitle(price1Str, for: .normal)
        
        if let image = productImageDic[productArray[indexPath.row].productIdentifier] {
            cell.imageViewProduct.image = image
        }
        
        print(cell.contentView.frame.width)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let payment = SKPayment(product: productArray[indexPath.row])
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    do {
                        let receiptUrl = Bundle.main.appStoreReceiptURL
                        let receipt: Data = try Data.init(contentsOf: receiptUrl!)
                        
                        validateAppReceipt(receipt: receipt)
                    } catch {
                        
                    }
                    
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }
            }
        }
    }
    
    func validateAppReceipt(receipt: Data) {
        
        
        //let receipt = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        /*  Note 1: This is not local validation, the app receipt is sent to the app store for validation as explained here:
         https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html#//apple_ref/doc/uid/TP40010573-CH104-SW1
         Note 2: Refer to the url above. For good reasons apple recommends receipt validation follow this flow:
         device -> your trusted server -> app store -> your trusted server -> device
         In order to be a working example the validation url in this code simply points to the app store's sandbox servers.
         Depending on how you set up the request on your server you may be able to simply change the
         structure of requestDictionary and the contents of validationURLString.
         */
        let base64encodedReceipt = receipt.base64EncodedString()
        let requestDictionary = ["receipt-data":base64encodedReceipt]
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
            guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                if let data = data , error == nil {
                    do {
                        let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                        print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                        // if you are using your server this will be a json representation of whatever your server provided
                    } catch let error as NSError {
                        print("json serialization failed with error: \(error)")
                    }
                } else {
                    print("the upload task returned an error: \(error)")
                }
            }
            task.resume()
        } catch let error as NSError {
            print("json serialization failed with error: \(error)")
        }
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
