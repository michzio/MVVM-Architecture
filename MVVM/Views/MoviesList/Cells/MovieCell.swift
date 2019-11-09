//
//  MovieCell.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Constants
    static let height = CGFloat(130)
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    // MARK:
    var viewModel: MovieItemViewModel! {
        didSet {
            bindUI()
        }
    }
    
    private func bindUI() {
        
        viewModel.posterImage.asDriver(onErrorJustReturn: nil)
        .debug("poster image", trimOutput: true)
            .filter { $0 != nil }
            .map { UIImage(data: $0!) }
            .drive(posterImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    
    func configure(with movie: Movie) {
        
        titleLabel.text = movie.title
        dateLabel.text = "\(NSLocalizedString("Release Date", comment: "")): \(movie.releaseDate ?? "-")"
        overviewLabel.text = movie.overview
        
        if let path = movie.posterPath {
            viewModel.updatePosterImage(path: path, width: Int(posterImageView.frame.width * UIScreen.main.scale))
        }
    }
}
