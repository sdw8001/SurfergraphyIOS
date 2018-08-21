//
//  Photographer.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 16..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import Foundation
import ObjectMapper

class Photographer: Mappable {
    
    var Id: String?
    var Name: String?
    var NickName: String?
    var Tel: String?
    var Image: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        Id <- map["Id"]
        Name <- map["Name"]
        NickName <- map["NickName"]
        Tel <- map["Tel"]
        Image <- map["Image"]
    }
    
    
}
