//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let movies = parseMovieData(filename: "movies")
        // Do any additional setup after loading the view.
    }


    
    func parseMovieData(filename fileName: String) -> [Movie]? {
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
        return nil
    }
}

