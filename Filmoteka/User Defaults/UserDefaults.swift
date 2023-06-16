//
//  UserDefaults.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 16.06.2023.
//

import Foundation
import UIKit

final class UserDafaultsManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefaults = UserDefaults.standard
    
    func saveFavorites() {
        let favorites = appDelegate.homeViewModel.favoriteMovieArray
        let encodedData = try? JSONEncoder().encode(favorites)
        userDefaults.set(favorites, forKey: "Favorites")
    }
    
    func loadFavorites() {
        if let encodedData = userDefaults.data(forKey: "Favorites") {
            if let favorites = try? JSONDecoder().decode([MovieCell].self, from: encodedData) {
                appDelegate.homeViewModel.favoriteMovieArray = favorites
            }
        }
    }
}
