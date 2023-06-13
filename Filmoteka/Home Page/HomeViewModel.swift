//
//  HomeViewModel.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 13.06.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var movieCells: [MovieCell] { get }
    var updateTableView: (() -> Void)?  { get }
    func searchMovies(withQuery query: String)
    func favoriteIcon(id: Int) -> String
    var updateFavorites: (([MovieCell]) -> Void)? { get }
    func addToFavorites(movie: MovieCell)
    func removeFromFavorites(with id: Int)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    var movieCells: [MovieCell] = []
    
    var updateTableView: (() -> Void)?
    
    func searchMovies(withQuery query: String) {
        APIManager.shared.searchMovies(withQuery: query) { movies, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let movies = movies {
                self.movieCells = movies.map { movie in
                    return MovieCell(title: movie.title,
                                     year: movie.year,
                                     genre: movie.genre,
                                     posterImage: movie.posterImage,
                                     plot: movie.plot,
                                     url: movie.url,
                                     trackViewUrl: movie.trackViewUrl,
                                     id: movie.id)
                }
                DispatchQueue.main.async {
                    self.updateTableView?()
                }
            }
        }
    }
    
    func favoriteIcon(id: Int) -> String {
        if favoriteMovieArray.contains(where: { $0.id == id }) {
            return "heart.fill"
        }
        return "heart"
    }
    
    var updateFavorites: (([MovieCell]) -> Void)?
    var favoriteMovieArray: [MovieCell] = []
    
    func addToFavorites(movie: MovieCell) {
        favoriteMovieArray.append(movie)
        updateFavorites?(favoriteMovieArray)
    }
    
    func removeFromFavorites(with id: Int) {
        if let index = favoriteMovieArray.firstIndex(where: { $0.id == id }) {
            favoriteMovieArray.remove(at: index)
            updateFavorites?(favoriteMovieArray)
        }
    }
}
