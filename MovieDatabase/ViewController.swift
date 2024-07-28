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
    
    @IBOutlet weak var searchMovieBar: UISearchBar!
    
    
    let sectionHeaders = ["Year","Genre","Directors","Actors","All Movies"]
    
    var originalMovieList: [Movie] = []
    
    var yearsOfMovies: [String] = []
    
    var genreOfMovies: [String] = []
    
    var directorsOfMovies: [String] = []
    
    var actorsOfMovies: [String] = []
    
    var sortedDictionaryOfMovies : [String:Dictionary<String,[Movie]>] = [:]
    
    var collapsedSections: Set<Int> = []
    
    var filteredMovies: [Movie] = []
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovieBar.delegate = self
        self.navigationItem.title = "Movie Database"
        movieList.delegate = self
        movieList.dataSource = self
        let optionCellNib = UINib(nibName: "OptionTableViewCell", bundle: nil)
        movieList.register(optionCellNib, forCellReuseIdentifier: "OptionCell")
        let movieNib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        movieList.register(movieNib, forCellReuseIdentifier: "MovieCell")
        originalMovieList = parseMovieData(filename: "movies")
        sortMovies(movies: originalMovieList)
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        movieList.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        // Do any additional setup after loading the view.
    }

    func sortMovies(movies: [Movie]){
        
        var actorMoviesDict: [String: [Movie]] = [:]
        var directorMoviesDict: [String: [Movie]] = [:]
        var genreDict: [String: [Movie]] = [:]
        var yearMoviesDict: [String: [Movie]] = [:]
        
        for movie in movies {
            if (movie.actors != "N/A"){
                let actorsForTheMovie = movie.actors.split(separator: ", ").map { String($0) }
                
                for actor in actorsForTheMovie {
                    if actorMoviesDict[actor] == nil {
                        actorMoviesDict[actor] = []
                    }
                    actorMoviesDict[actor]?.append(movie)
                }
            }
            
            if (movie.director != "N/A"){
                
                let directorsOfTheMovie = movie.director.split(separator: ", ").map { String($0) }
                
                for director in directorsOfTheMovie {
                    if directorMoviesDict[director] == nil {
                        directorMoviesDict[director] = []
                    }
                    directorMoviesDict[director]?.append(movie)
                }
            }
            
            if (movie.genre != "N/A"){
                
                let genresOfTheMovie = movie.genre.split(separator: ", ").map { String($0) }
                
                for genre in genresOfTheMovie {
                    if genreDict[genre] == nil {
                        genreDict[genre] = []
                    }
                    genreDict[genre]?.append(movie)
                }
            }
            
            if (movie.year != "N/A"){
                let yearsOfTheMovie = movie.year.split(separator: "–").map{ String($0) }
                for year in yearsOfTheMovie {
                    if yearMoviesDict[year] == nil {
                        yearMoviesDict[year] = []
                    }
                    yearMoviesDict[year]?.append(movie)
                }
            }
        }
        yearsOfMovies = Array(yearMoviesDict.keys)
        actorsOfMovies = Array(actorMoviesDict.keys)
        directorsOfMovies = Array(directorMoviesDict.keys)
        genreOfMovies = Array(genreDict.keys)
        sortedDictionaryOfMovies["actors"] = actorMoviesDict
        sortedDictionaryOfMovies["directors"] = directorMoviesDict
        sortedDictionaryOfMovies["year"] = yearMoviesDict
        sortedDictionaryOfMovies["genre"] = genreDict
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
    
    @objc func handleHeaderTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else {
            return
        }

        if collapsedSections.contains(section) {
            collapsedSections.remove(section)
        } else {
            collapsedSections.insert(section)
        }

        movieList.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4{
            return 200
        }
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let movieDetail = originalMovieList[indexPath.row]
            self.showMovieDetail(movieDetail: movieDetail)
        }
        else if isSearching {
            let movieDetail = filteredMovies[indexPath.row]
            self.showMovieDetail(movieDetail: movieDetail)
        }
        else{
            guard let cell = tableView.cellForRow(at: indexPath) as? OptionTableViewCell else { return }
            cell.isInnerTableViewVisible.toggle()
            tableView.deselectRow(at: indexPath, animated: true)
            
            // Animate the changes
            UIView.animate(withDuration: 0.3) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {return 0}
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            return UIView()
        }
        guard let header = movieList.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionHeaderView else{
            return UIView()
        }
//        header.backgroundColor = .lightGray

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        header.addGestureRecognizer(tapGesture)
        header.tag = section
        header.sectionHeaderName = sectionHeaders[section]

        return header
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {return filteredMovies.count}
        if collapsedSections.contains(section) {
            return 0
        }
        switch section{
            case 0:
                return yearsOfMovies.count
            case 1:
                return genreOfMovies.count
            case 2:
                return directorsOfMovies.count
            case 3:
                return actorsOfMovies.count
            case 4: return originalMovieList.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            guard let cell = movieList.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else{
                return UITableViewCell()
            }
            let movieDetail = filteredMovies[indexPath.row]
            if let imageUrl = URL(string: movieDetail.poster){
                cell.movieThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.movieThumbnail.sd_imageIndicator?.startAnimatingIndicator()
                cell.movieThumbnail.sd_setImage(with: imageUrl, completed: nil)
            }
            cell.movieLanguages.text = "Languages: \(movieDetail.language)"
            cell.movieYear.text = "Year: \(movieDetail.year)"
            cell.movieTitle.text = movieDetail.title
            cell.delegateToShowDetail = self
            return cell
        }
        switch indexPath.section{
            case 0:
                guard let cell = movieList.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell else{return UITableViewCell()}
                let yearToDisplay = yearsOfMovies[indexPath.row]
                cell.optionValueLabel.text = yearsOfMovies[indexPath.row]
                if let moviesForYear = sortedDictionaryOfMovies["year"]?[yearToDisplay]{
                    cell.movieListForSection = moviesForYear
                }
                cell.delegateForTable = self
                return cell
            case 1:
                guard let cell = movieList.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell else{return UITableViewCell()}
                let genreToDisplay = genreOfMovies[indexPath.row]
                cell.optionValueLabel.text = genreOfMovies[indexPath.row]
                if let moviesForGenre = sortedDictionaryOfMovies["genre"]?[genreToDisplay]{
                    cell.movieListForSection = moviesForGenre
                }
                cell.delegateForTable = self
                return cell
            case 2:
                guard let cell = movieList.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell else{return UITableViewCell()}
                let directorToDisplay = directorsOfMovies[indexPath.row]
                cell.optionValueLabel.text = directorsOfMovies[indexPath.row]
                if let moviesForDirectors = sortedDictionaryOfMovies["directors"]?[directorToDisplay]{
                    cell.movieListForSection = moviesForDirectors
                }
                cell.delegateForTable = self
                return cell
            case 3:
                guard let cell = movieList.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell else{return UITableViewCell()}
                let actorToDisplay = actorsOfMovies[indexPath.row]
                cell.optionValueLabel.text = actorsOfMovies[indexPath.row]
                if let moviesForActors = sortedDictionaryOfMovies["actors"]?[actorToDisplay]{
                    cell.movieListForSection = moviesForActors
                }
                cell.delegateForTable = self
                return cell
            case 4:
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
                cell.delegateToShowDetail = self
                return cell
                
            default:
                return UITableViewCell()
        }
//
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {return 1}
        return sectionHeaders.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionHeaders[section]
//    }
    
    
}


extension ViewController: SelectMovieDetail{
    
    func showMovieDetail(movieDetail: Movie) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovieDetailViewController") { coder in
            return MovieDetailViewController(coder: coder, movieDetail: movieDetail)
        }

        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter movies based on searchText
        isSearching = !searchText.isEmpty
        filteredMovies = originalMovieList.filter { movie in
                
            let containsInTitle = movie.title.contains(searchText)
            let containsInGenre = movie.genre.contains(searchText)
            let containsInDirector = movie.director.contains(searchText)
            let containsInActors = movie.actors.contains(searchText)
            
            return containsInTitle || containsInGenre || containsInDirector || containsInActors
        }
        movieList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear search
        searchBar.text = ""
        isSearching = false
        movieList.reloadData()
    }
}
