//
//  FavoritesViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 12.06.2023.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    var placeholderLabel = UILabel()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefaults = UserDafaultsManager()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.reloadData()
        appDelegate.homeViewModel.updateFavorites = { [weak self] favorites in
            self?.appDelegate.homeViewModel.favoriteMovieArray = favorites
            self?.tableView.reloadData()
            self?.userDefaults.saveFavorites()
        }
        userDefaults.loadFavorites()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.homeViewModel.favoriteMovieArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath)
        
        guard let movieCell = cell as? MoviesTableViewCell else {
            return cell
        }
        
        let movie = appDelegate.homeViewModel.favoriteMovieArray[indexPath.row]
        let m = MovieCellViewModel.init(movie: movie)
        movieCell.setUpData(viewModel: m)
        
        return movieCell
    }
}

