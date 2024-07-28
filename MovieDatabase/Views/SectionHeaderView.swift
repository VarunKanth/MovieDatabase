//
//  SectionHeaderView.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var arrowImage: UIImageView!
    
    
    var sectionHeaderName = "" {
        didSet{
            self.headerSectionName.text = sectionHeaderName
        }
    }
    
    @IBOutlet weak var headerSectionName: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
