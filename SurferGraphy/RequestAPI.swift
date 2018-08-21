//
//  RequestAPI.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 11..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

enum Type {
    case BP
    case EP
    case LP
    case PS
    case KOEC
    case KOSC
    case KOWC
    case KOJI
    case JP
    case CN
    case ID
    case PH
    case TW
    case US
    case USHW
    case AU
    case ETC
    
    
    func getType() -> String {
        switch self {
        case .BP:
            return "BP"
        case .EP:
            return "EP"
        case .LP:
            return "LP"
        case .PS:
            return "PS"
        case .KOEC:
            return "KOEC"
        case .KOSC:
            return "KOSC"
        case .KOWC:
            return "KOWC"
        case .KOJI:
            return "KOJI"
        case .JP:
            return "JP"
        case .CN:
            return "CN"
        case .ID:
            return "ID"
        case .PH:
            return "PH"
        case .TW:
            return "TW"
        case .US:
            return "US"
        case .USHW:
            return "USHW"
        case .AU:
            return "AU"
        case .ETC:
            return "ETC"
        }
    }
    
    func getName() -> String {
        switch self {
        case .BP:
            return "Best Photo"
        case .EP:
            return "Event & Promotion"
        case .LP:
            return "Lesson Photos - First TakeOff"
        case .PS:
            return "Personal Shoot"
        case .KOEC:
            return "Korea - East Coast"
        case .KOSC:
            return "Korea - South Coast"
        case .KOWC:
            return "Korea - West Coast"
        case .KOJI:
            return "Korea - Jeju Island"
        case .JP:
            return "Japan"
        case .CN:
            return "China"
        case .ID:
            return "Indonesia"
        case .PH:
            return "Philippines"
        case .TW:
            return "Taiwan"
        case .US:
            return "Usa"
        case .USHW:
            return "Hawaii"
        case .AU:
            return "Australia"
        case .ETC:
            return "Other Countries"
        }
    }
}

class RequestAPI {
    
    private static let baseURL = "https://surfergraphyapi.azurewebsites.net/"
    
    static func get(url: String) -> DataRequest {
        return Alamofire.request(baseURL + url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    }
    
    static func getPhotos(date: String, response: @escaping ([Photo]) -> ()) {
        Alamofire.request(baseURL + "api/Photos/Date/\(date)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            let photos = Mapper<Photo>().mapArray(JSONString: json.description)
            
            if let photos = photos {
                response(photos)
            }
        }
    }
    
    static func getAllDate(response: @escaping ([PhotoDate]) -> ()) {
        Alamofire.request(baseURL + "api/Dates", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            var dates = Array<PhotoDate>()
            
            json.arrayValue.forEach { data in
                //print(data["DateString"])
                dates.append(PhotoDate(date: data["DateString"].stringValue))
            }
            
            response(dates)
            
        }
    }
    
    static func getDatesOfType(type: String, response: @escaping ([PhotoDate]) -> ()) {
        Alamofire.request(baseURL + "api/Dates/Place/\(type)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            var dates = Array<PhotoDate>()
            
            json.arrayValue.forEach { data in
                //print(data["DateString"])
                dates.append(PhotoDate(date: data["DateString"].stringValue))
            }
            
            response(dates)
            
        }
    }
    
    static func getPhotosOfType(type: String, date: String, response: @escaping ([Photo]) -> ()) {
        Alamofire.request(baseURL + "api/Photos/Place/Date/\(type)/\(date)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            let photos = Mapper<Photo>().mapArray(JSONString: json.description)
            
            if let photos = photos {
                response(photos)
            }
        }
    }
    
    static func getUserInfo(id: String, response: @escaping (JSON?) -> ()) {
        Alamofire.request(baseURL + "api/Members/\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            if res.response?.statusCode == 404 {
                response(nil)
            }
            else {
                response(json)
            }
            
        }
    }
    
    static func getMemberId(id: String, response: @escaping (Bool, String?) -> ()) {
        Alamofire.request(baseURL + "api/Members/\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            if res.response?.statusCode == 404 {
                response(false, nil)
            }
            else {
                response(true, json["ImageUrl"].stringValue)
            }
            
        }
    }
    
    static func joinMember(member: RequestMember, response: @escaping (Bool) -> ()) {
        
        let params: Parameters = ["Id": member.Id,
                                  "Email": member.Email,
                                  "JoinType": member.JoinType,
                                  "Name": member.Name,
                                  "ImageUrl": member.ImageUrl,
                                  "Password": member.password]
        
        Alamofire.request(baseURL + "api/Members", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
            
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            print(json)
            
            if res.response?.statusCode == 404 {
                response(false)
            }
            else {
                response(true)
            }
        }
    }
    
    static func getPhotographerInfo(photographerId: String, response: @escaping (Photographer?) -> ()) {
        Alamofire.request(baseURL + "api/Photographer/\(photographerId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject {(res: DataResponse<Photographer>) in
            
            response(res.result.value)
            
        }
    }
    
    static func getUserLikePhotos(userId: String, response: @escaping ([Int: Int]) -> ()) {
        Alamofire.request(baseURL + "api/LikePhotos/UserPhotos/\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)

            //print(json)
            
            var likePhotoDic: [Int: Int] = [:]
            
            json.arrayValue.forEach { data in
                likePhotoDic[data["PhotoId"].intValue] = data["Id"].intValue
            }
            
            response(likePhotoDic)
            
//            let photos = Mapper<Photo>().mapArray(JSONString: json.description)
//
//            if let photos = photos {
//                response(photos)
//            }
        }
    }
    
    static func likePhoto(userId: String, photoId: Int, response: @escaping (Bool) -> ()) {
        
        let params: Parameters = ["UserId": userId,
                                  "PhotoId": photoId]
        
        Alamofire.request(baseURL + "api/LikePhotos", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            //print(json)
            
            if json["Id"].int != nil {
                response(true)
                return
            }
            
            response(false)
        }
    }
    
    static func cancelLikePhoto(likeId: Int, response: @escaping (Bool) -> ()) {
        Alamofire.request(baseURL + "api/LikePhotos/\(likeId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            //print(json)
            
            if json["Id"].int != nil {
                response(true)
                return
            }
            
            response(false)
        }
    }
    
    static func getUserLikePhotosInfo(userId: String, response: @escaping ([Photo]) -> ()) {
        Alamofire.request(baseURL + "api/Photo/LikePhotos/\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            let photos = Mapper<Photo>().mapArray(JSONString: json.description)
            
            if let photos = photos {
                response(photos)
            }
        }
    }
    
    static func getUserPhotosInfo(userId: String, response: @escaping ([Photo]) -> ()) {
        Alamofire.request(baseURL + "api/Photo/UserPhotos/\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            let photos = Mapper<Photo>().mapArray(JSONString: json.description)
            
            if let photos = photos {
                response(photos)
            }
        }
    }
    
    static func savePhotoBuyHistory(userId: String, photoId: Int, response: @escaping () -> ()) {
        
        let params: Parameters = ["UserId": userId,
                                  "PhotoId": photoId]
        
        Alamofire.request(baseURL + "api/PhotoBuyHistories", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            print(json)
            
            //errorcode: 101 wave가 부족할 때
            
            guard let photoSaveHistoryId = json["Id"].int else {
                return
            }
            
            response()
            
        }
    }
    
    static func savePhotoHistory(userId: String, photoId: Int, response: @escaping (Int, Int) -> ()) {
        
        let params: Parameters = ["UserId": userId,
                                  "PhotoId": photoId]
        
        Alamofire.request(baseURL + "api/PhotoSaveHistories", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            guard let photoSaveHistoryId = json["Id"].int, let photoBuyHistoryId = json["PhotoBuyHistoryId"].int else {
                return
            }
            
            print(json)
            response(photoSaveHistoryId, photoBuyHistoryId)
            
        }
    }
    
    static func saveUserPhoto(userId: String, photoId: Int, photoSaveHistoryId: Int, photoBuyHistoryId: Int) {
        
        let params: Parameters = ["UserId": userId,
                                  "PhotoId": photoId,
                                  "PhotoSaveHistoryId": photoSaveHistoryId,
                                  "PhotoBuyHistoryId": photoBuyHistoryId]
        
        Alamofire.request(baseURL + "api/UserPhotos", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            print(json)
            
        }
    }
    
    static func getPhotoBuyHistoryUserPhoto(userId: String, response: @escaping ([Int: Bool]) -> ()) {
        Alamofire.request(baseURL + "api/PhotoBuyHistories/UserPhotos/\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            var dict: [Int: Bool] = [:]
            
            json.arrayValue.forEach { data in
                dict[data["PhotoId"].intValue] = true
            }
            
            response(dict)
        }
    }
    
    static func deleteLikePhoto(likeId: Int, response: @escaping () -> ()) {
        Alamofire.request(baseURL + "api/LikePhotos/\(likeId)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).response {res in
            guard let resData = res.data else {
                return
            }
            
            let json = JSON(resData)
            
            print(json)
            
            if json["Id"].int != nil {
                response()
            }
        }
    }
    
    
}
