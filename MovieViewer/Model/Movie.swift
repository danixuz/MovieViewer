//
//  Movie.swift
//  MovieViewer
//
//  Created by Daniel Spalek on 15/05/2022.
//

import SwiftUI

// MARK: Movie data model and sample movie data
struct Movie: Identifiable{
    var id = UUID().uuidString
    var movieTitle: String
    var artwork: String
}

var movies: [Movie] = [
    
    Movie(movieTitle: "The Wolf of Wall Street", artwork: "Movie1"),
    Movie(movieTitle: "Star Wars", artwork: "Movie2"),
    Movie(movieTitle: "Toy Story 4", artwork: "Movie3"),
    Movie(movieTitle: "Lion King", artwork: "Movie4"),
    Movie(movieTitle: "Spider-Man: No Way Home", artwork: "Movie5"),
    Movie(movieTitle: "Shang Chi", artwork: "Movie6"),
    Movie(movieTitle: "Hawkeye", artwork: "Movie7")
]

// MARK: Dummy Text
var sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus egestas odio eget erat tincidunt sagittis. Curabitur vitae mi vel ipsum auctor ornare. Duis vulputate porta elit, ut varius felis malesuada eu. In elementum et massa sit amet faucibus. Sed elit velit, aliquam et auctor eget, ultricies nec tortor. Sed at libero dui. Sed eget arcu ipsum. Cras imperdiet molestie gravida. Etiam id finibus libero. In interdum varius mi ut egestas. Morbi tristique sem a cursus vestibulum."
