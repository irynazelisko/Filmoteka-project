//
//  Model.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import Foundation

struct MovieCell: Codable {
    let title: String
    let year: String
    let genre: String
    let posterImage: String
    let plot: String
    let url: String
    let trackViewUrl: String
    let id: Int
  }



