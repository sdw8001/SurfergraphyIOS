//
//  Nation.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 20..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import Foundation
import UIKit

struct Nation {
    var name: String
    var regions: [Region]
    var image: UIImage?
    var collapsed: Bool
    var type: Type?
}

struct Region {
    var name: String
    var image: UIImage?
    var type: Type?
}
