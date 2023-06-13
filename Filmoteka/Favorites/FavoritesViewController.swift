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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        tableView.reloadData()
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
        
        let movieId = favoritiesViewModel.favoritesList[indexPath.row]
        let movie = homeViewModel.movieCells.first(where: { String($0.id) == movieId })
        
        return movieCell
    }
}
