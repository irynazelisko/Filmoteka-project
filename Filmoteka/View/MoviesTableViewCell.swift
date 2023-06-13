//
//  MoviesTableViewCell.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import UIKit

final class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: MovieCellViewModel? {
        didSet{
            initData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func upDateFavoriteButton(icon: String) {
        favoriteButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    
    func setUpData(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        
    }
    
    func initData() {
        titleLabel.text = viewModel?.title
        yearLabel.text = viewModel?.year
        genreLabel.text = viewModel?.genre
        
        viewModel?.loadImage { [weak self] image in
            self?.posterImageView.image = image
        }
    }
}
