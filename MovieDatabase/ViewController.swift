//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    
    @IBOutlet weak var movieList: UITableView!
    
    let sectionHeaders = ["Year","Genre","Directors","Actors","All Movies"]
    
    var originalMovieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieList.delegate = self
        movieList.dataSource = self
        let movieCellNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieList.register(movieCellNib, forCellReuseIdentifier: "MovieCell")
        originalMovieList = parseMovieData(filename: "movies")
        // Do any additional setup after loading the view.
    }


    
    func parseMovieData(filename fileName: String) -> [Movie]{
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Movie].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return originalMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieList.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        let movieDetail = originalMovieList[indexPath.row]
        if let imageUrl = URL(string: movieDetail.poster){
            cell.movieThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.movieThumbnail.sd_imageIndicator?.startAnimatingIndicator()
            cell.movieThumbnail.sd_setImage(with: imageUrl, completed: nil)
        }
        cell.movieLanguages.text = "Languages: \(movieDetail.language)"
        cell.movieYear.text = "Year: \(movieDetail.year)"
        cell.movieTitle.text = movieDetail.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    
}

