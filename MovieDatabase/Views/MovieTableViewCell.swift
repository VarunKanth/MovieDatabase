//
//  MovieTableViewCell.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieThumbnail: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieLanguages: UILabel!
    
    @IBOutlet weak var movieYear: UILabel!
    
    var movieDetail: Movie?
    
    var delegateToShowDetail: SelectMovieDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
