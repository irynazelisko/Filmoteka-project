//
//  MovieCellViewModel.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import Foundation
import UIKit

protocol MovieCellPresentationModel {
    var title: String { get }
    var year: String { get }
    var genre: String { get }
    var posterImageView: String { get }
    var plot: String { get }
    func loadImage(completion: @escaping (UIImage?) -> Void)
}


final class MovieCellViewModel: MovieCellPresentationModel {
    let title: String
    let year: String
    let genre: String
    let posterImageView: String
    let plot: String
   
    
    init(movie: MovieCell) {
        self.title = movie.title
        self.year = movie.year
        self.genre = movie.genre
        self.posterImageView = movie.posterImage
        self.plot = movie.plot
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: posterImageView) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let imageData = data {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}
