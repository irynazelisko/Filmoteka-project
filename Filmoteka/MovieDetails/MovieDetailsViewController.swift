//
//  DetailsViewController.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 12.06.2023.
//

import UIKit
import AVKit
import AVFoundation

final class MovieDetailsViewController: UIViewController {
    
    let viewModel = MovieDetailsViewModel()
    
    private var moviePlayerController = AVPlayerViewController()
    private var playerView = AVPlayer()
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailerButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        trailerButton.layer.cornerRadius = 14
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        
        
        if let movie = viewModel.movie {
            posterImageView.image = UIImage(named: movie.posterImage)
            titleLabel.text = movie.title
            genreLabel.text = movie.genre
            yearLabel.text = movie.year
            plotLabel.text = movie.plot
            
            let viewModel = MovieCellViewModel(movie: movie)
            viewModel.loadImage { image in
                self.posterImageView.image = image
            }
        }
    }
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func playVideo() {
        guard let urlString = viewModel.movie?.url, let url = URL(string: urlString) else {
            showAlert(withTitle: "Trailer is not available!", message: "Try again")
            return
        }
        playerView = AVPlayer(url: url)
        moviePlayerController.player = playerView
        self.present(moviePlayerController, animated: true) {
            self.moviePlayerController.player?.play()
        }
        
    }
    
    @IBAction func trailerPressed(_ sender: UIButton) {
        playVideo()
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        guard let urlString = viewModel.movie?.trackViewUrl, let url = URL(string: urlString) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = sender
        
        present(activityViewController, animated: true, completion: nil)
    }
}





