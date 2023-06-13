//
//  FavoritesViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 12.06.2023.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    let favoritiesViewModel = FavoritesViewModel()
    let homeViewModel = HomeViewModel()
    var placeholderLabel = UILabel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.reloadData()
        setupPlaceholderLabel()
        updatePlaceholderVisibility()
    }
    
    func setupPlaceholderLabel() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "No favorites yet"
        placeholderLabel.font = UIFont.systemFont(ofSize: 28)
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !favoritiesViewModel.favoritesList.isEmpty
        tableView.isHidden = favoritiesViewModel.favoritesList.isEmpty
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritiesViewModel.favoritesList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath)
        
        guard let movieCell = cell as? MoviesTableViewCell else {
            return cell
        }
        
        let movie = homeViewModel.favoriteMovieArray[indexPath.row]
        let m = MovieCellViewModel.init(movie: movie)
        movieCell.setUpData(viewModel: m)
       
        return movieCell
    }
}

