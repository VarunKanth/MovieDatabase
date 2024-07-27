//
//  OptionTableViewCell.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import UIKit
import SDWebImage

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var innerTableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var optionValueLabel: UILabel!
    
    var selectedOption : String = ""
    
    var selectedValue : String = ""
    
    var movieList : [String:Dictionary<String,[Movie]>] = [:]
    
    var movieListForSection: [Movie] = []{
        didSet{
            innerTableView.reloadData()
        }
    }
    
    var isInnerTableViewVisible = false {
        didSet {
            innerTableView.isHidden = !isInnerTableViewVisible
            innerTableViewHeightConstraint.constant = isInnerTableViewVisible ? 200 : 0 // Adjust the height as needed
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        innerTableView.delegate = self
        innerTableView.dataSource = self
        innerTableView.separatorColor = .clear
//        innerTableView.isHidden = true
//        isInnerTableViewVisible = false
        let movieNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        innerTableView.register(movieNib, forCellReuseIdentifier: "MovieCell")
    }
}

extension OptionTableViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListForSection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = innerTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else{return UITableViewCell()}
        let movieDetail = movieListForSection[indexPath.row]
        cell.movieYear.text = "Year: \(movieDetail.year)"
        cell.movieLanguages.text = "Languages: \(movieDetail.language)"
        cell.movieTitle.text = movieDetail.title
        if let imageUrl = URL(string: movieDetail.poster){
            
            cell.movieThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.movieThumbnail.sd_imageIndicator?.startAnimatingIndicator()
            cell.movieThumbnail.sd_setImage(with: imageUrl, completed: nil)
        }
      
        return cell
    }
}

extension OptionTableViewCell: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

}
