//
//  MoviesViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
   
    let homeViewModel = HomeViewModel()
    
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
        self.tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        homeViewModel.searchMovies(withQuery: "action")
        homeViewModel.updateTableView = { [weak self] in
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
        homeViewModel.movieCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        let movie = homeViewModel.movieCells[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.yearLabel.text = movie.year
        cell.genreLabel.text = movie.genre
        cell.posterImageView.image = UIImage(named: movie.posterImageView)
    
        let viewModel = MovieCellViewModel(movie: movie)
        viewModel.loadImage { image in
            cell.posterImageView.image = image
        }
        
        let icon = homeViewModel.favoriteIcon(id: movie.id)
        cell.upDateFavoriteButton(icon: icon)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = homeViewModel.movieCells[indexPath.row]
        performSegue(withIdentifier: "showMovieDetails", sender: selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let movie = homeViewModel.movieCells[indexPath.row]
        
        // Створюємо favorite action
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, completion) in
            self?.homeViewModel.addToFavorites(with: movie.id)
            if let icon = self?.homeViewModel.favoriteIcon(id: movie.id) {
                if let cell = tableView.cellForRow(at: indexPath) as? MoviesTableViewCell {
                    cell.upDateFavoriteButton(icon: icon)
                }
                print("Added to favorites")
            }
            completion(true)
        }
        favoriteAction.backgroundColor = .lightGray
        
        
        // Створюємо unfavorite action
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] (action, view, completion) in
            self?.homeViewModel.removeFromFavorites(with: movie.id)
            if let icon = self?.homeViewModel.favoriteIcon(id: movie.id) {
                if let cell = tableView.cellForRow(at: indexPath) as? MoviesTableViewCell {
                    cell.upDateFavoriteButton(icon: icon)
                }
                print("Removed from favorites")
            }
            completion(true)
        }
        
        
        // Дії які виконуються під час проведення пальцем по рядках таблиці
        let configuration = UISwipeActionsConfiguration(actions: [unfavoriteAction, favoriteAction])
        return configuration
    }
    
}



// MARK: - Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            homeViewModel.searchMovies(withQuery: query)
            searchBar.resignFirstResponder()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
}
