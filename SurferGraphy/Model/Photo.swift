//
//  Photo.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 11..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: Mappable {
    
    var photographerId: String?
    var expired: Bool?
    var expirationDate: String?
    var dimesionWidth: Int?
    var dimensionHeight: Int?
    var wave: Int?
    var id: Int?
    var url: String?
    var name: String?
    var mimeType: String?
    var place: String?
    var resolution: Int?
    var valid: Bool?
    var totalCount: Int?
    var date: String?
    
    var isSelectMode: Bool = false
    var isClick: Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        photographerId <- map["PhotographerId"]
        expired <- map["Expired"]
        expirationDate <- map["ExpirationDate"]
        dimesionWidth <- map["DimensionHeight"]
        dimensionHeight <- map["DemesionWidth"]
        wave <- map["Wave"]
        id <- map["Id"]
        url <- map["Url"]
        name <- map["Name"]
        mimeType <- map["MimeType"]
        place <- map["Place"]
        resolution <- map["Resolution"]
        valid <- map["Valid"]
        totalCount <- map["TotalCount"]
        date <- map["Date"]
    }
}
