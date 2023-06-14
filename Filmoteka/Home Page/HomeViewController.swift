//
//  MoviesViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import UIKit
import Firebase

final class HomeViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = UIColor.white
        }
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        appDelegate.homeViewModel.searchMovies(withQuery: "action")
        appDelegate.homeViewModel.updateTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let detailViewController = segue.destination as? MovieDetailsViewController,
               let selectedMovie = sender as? MovieCell {
                detailViewController.viewModel.movie = selectedMovie
            }
        }
    }
    
}
// MARK: - TableView Delegate, DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.homeViewModel.movieCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        guard let movieCell = cell as? MoviesTableViewCell else {
            return cell
        }
        let movie =  appDelegate.homeViewModel.movieCells[indexPath.row]
        movieCell.titleLabel.text = movie.title
        movieCell.yearLabel.text = movie.year
        movieCell.genreLabel.text = movie.genre
        movieCell.posterImageView.image = UIImage(named: movie.posterImage)
        
        let viewModel = MovieCellViewModel(movie: movie)
        viewModel.loadImage { image in
            movieCell.posterImageView.image = image
        }
        
        let icon =  appDelegate.homeViewModel.favoriteIcon(id: movie.id)
        movieCell.upDateFavoriteButton(icon: icon)
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie =  appDelegate.homeViewModel.movieCells[indexPath.row]
        performSegue(withIdentifier: "showMovieDetails", sender: selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = appDelegate.homeViewModel.movieCells[indexPath.row]
        
        // Створюємо favorite action
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, completion) in
            self?.appDelegate.homeViewModel.addToFavorites(movie: movie)
            if let icon = self?.appDelegate.homeViewModel.favoriteIcon(id: movie.id) {
                if let cell = tableView.cellForRow(at: indexPath) as? MoviesTableViewCell {
                    cell.upDateFavoriteButton(icon: icon)
                }
                print("Added to favorites")
            }
            completion(true)
        }
        favoriteAction.backgroundColor = .lightGray
        
        
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] (action, view, completion) in
            self?.appDelegate.homeViewModel.removeFromFavorites(with: movie.id)
            if let icon = self?.appDelegate.homeViewModel.favoriteIcon(id: movie.id) {
                if let cell = tableView.cellForRow(at: indexPath) as? MoviesTableViewCell {
                    cell.upDateFavoriteButton(icon: icon)
                }
                print("Removed from favorites")
            }
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [unfavoriteAction, favoriteAction])
        return configuration
    }
}
// MARK: - Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        appDelegate.homeViewModel.searchMovies(withQuery: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
