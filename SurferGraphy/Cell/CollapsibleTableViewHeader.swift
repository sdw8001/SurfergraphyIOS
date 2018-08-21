//
//  CollapsibleTableViewHeader.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 20..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
 
    @IBOutlet weak var imageViewNation: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    func addGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(gestureRecognizer:))))
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func setCollapsed(collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
        //arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }
}
