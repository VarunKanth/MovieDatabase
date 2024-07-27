//
//  Movie.swift
//  MovieDatabase
//
//  Created by Varun Kanth Murugesan on 27/07/24.
//

import Foundation

// Define a struct for the Ratings
struct Rating: Codable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

// Define the main Movie struct
struct Movie: Codable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: URL
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
    }
}

// Example usage:
let json = """
{
    "Title": "Meet the Parents",
    "Year": "2000",
    "Rated": "PG-13",
    "Released": "06 Oct 2000",
    "Runtime": "108 min",
    "Genre": "Comedy, Romance",
    "Director": "Jay Roach",
    "Writer": "Greg Glienna, Mary Ruth Clarke, Greg Glienna (story), Mary Ruth Clarke (story), Jim Herzfeld (screenplay), John Hamburg (screenplay)",
    "Actors": "Robert De Niro, Ben Stiller, Teri Polo, Blythe Danner",
    "Plot": "A Jewish male nurse plans to ask his live-in girlfriend to marry him. However, he learns that her strict father expects to be asked for his daughter's hand before she can accept. Thus begins the visit from Hell as the two travel to meet Mom and Dad, who turns out to be former CIA with a lie detector in the basement. Coincidentally, a sister also has announced her wedding to a young doctor. Of course, everything that can go wrong, does, including the disappearance of Dad's beloved Himalayan cat, Jinxie.",
    "Language": "English, Thai, Spanish, Hebrew, French",
    "Country": "USA",
    "Awards": "Nominated for 1 Oscar. Another 7 wins & 14 nominations.",
    "Poster": "https://m.media-amazon.com/images/M/MV5BMGNlMGZiMmUtZjU0NC00MWU4LWI0YTgtYzdlNGVhZGU4NWZlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg",
    "Ratings": [{
        "Source": "Internet Movie Database",
        "Value": "7.0/10"
    }, {
        "Source": "Rotten Tomatoes",
        "Value": "84%"
    }, {
        "Source": "Metacritic",
        "Value": "73/100"
    }],
    "Metascore": "73",
    "imdbRating": "7.0",
    "imdbVotes": "310,464",
    "imdbID": "tt0212338",
    "Type": "movie",
    "DVD": "N/A",
    "BoxOffice": "$166,244,045",
    "Production": "Nancy Tenenbaum Productions, Universal Pictures, Tribeca Productions, DreamWorks Pictures",
    "Website": "N/A",
    "Response": "True"
}
"""
