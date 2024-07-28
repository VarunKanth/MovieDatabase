//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 28/07/24.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var plotText: UITextView!
    
    @IBOutlet weak var castList: UILabel!
    
    @IBOutlet weak var crewList: UILabel!
    
    @IBOutlet weak var directorList: UILabel!
    
    @IBOutlet weak var genreList: UILabel!
    
    @IBOutlet weak var releasedDate: UILabel!
    
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var ratingValue: UILabel!
    
    var movieDetail : Movie
    
    var ratingSources:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlForImage = URL(string: movieDetail.poster){
            posterImage.sd_setImage(with: urlForImage, placeholderImage: UIImage(named: "video.png"))
        }
        movieTitle.text = movieDetail.title
        plotText.text = movieDetail.plot
        plotText.isEditable = false
        castList.text = "Actors: \(movieDetail.actors)"
        crewList.text = "Writer(s): \(movieDetail.writer)"
        directorList.text = "Director(s): \(movieDetail.director)"
        genreList.text = "Genre: \(movieDetail.genre)"
        releasedDate.text = "Released: \(movieDetail.released)"
        for rating in movieDetail.ratings {
            ratingSources[rating.source] = rating.value
        }
//        let ratingSources = movieDetail.ratings.map { $0.source }*/
        ratingSegmentedControl.removeAllSegments()
//        [
//        "Internet Movie Database","Rotten Tomatoes","Metacritic"
//        ]
        if ratingSources["Internet Movie Database"] != nil{
            ratingSegmentedControl.insertSegment(withTitle: "IMdb", at: 0, animated: false)
        }
        if ratingSources["Rotten Tomatoes"] != nil{
            ratingSegmentedControl.insertSegment(withTitle: "Rotten Tomatoes", at: 1, animated: false)
        }
        if ratingSources["Metacritic"] != nil{
            ratingSegmentedControl.insertSegment(withTitle: "Metacritic", at: 2, animated: false)
        }
        ratingSegmentedControl.selectedSegmentIndex = 0
        ratingSegmentedControl.sendActions(for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, movieDetail: Movie) {
        self.movieDetail = movieDetail
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing movieDetail.")
    }

    @IBAction func ratingSelected(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex){
            case "IMdb":
                ratingValue.text = ratingSources["Internet Movie Database"]
                break
            case "Rotten Tomatoes":
                ratingValue.text = ratingSources["Rotten Tomatoes"]
                break
            case "Metacritic":
                ratingValue.text = ratingSources["Metacritic"]
                break
            default:break
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
