//
//  HomeViewModel.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 13.06.2023.
//

import Foundation

final class HomeViewModel {
    
    var movieCells: [MovieCell] = []
    
    var updateTableView: (() -> Void)?
    
    func searchMovies(withQuery query: String) {
        APIManager.shared.searchMovies(withQuery: query) { movies, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let movies = movies {
                self.movieCells = movies.map { MovieCell(title: $0.title,
                                                         year: $0.year,
                                                         genre: $0.genre,
                                                         posterImageView: $0.posterImageView,
                                                         plot: $0.plot,
                                                         url: $0.url,
                                                         trackViewUrl: $0.trackViewUrl,
                                                         id: $0.id
                ) }
                DispatchQueue.main.async {
                    self.updateTableView?()
                }
            }
        }
    }
    
    func favoriteIcon(id: Int) -> String {
        let idString = String(id)
        if favoriteMovieArray.contains(idString){
            return "heart.fill"
        }
        return "heart"
    }
    
    var favoriteMovieArray: [String] = []
    
    func addToFavorites(with id: Int) {
        let idString = String(id)
        favoriteMovieArray.append(idString)
    }
    
    func removeFromFavorites(with id: Int) {
        let idString = String(id)
        if let index = favoriteMovieArray.firstIndex(of: idString) {
            favoriteMovieArray.remove(at: index)
        }
    }
    
}
