//
//  MovieDetailsViewController.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Dependencies
    var viewModel: IMovieDetailsViewModel!
    
    // MARK: - Outlets
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var overviewTextView: UITextView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
        
        bindUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    private func configViews() {
        view.accessibilityLabel = NSLocalizedString("Movie details view", comment: "")
    }
}

// MARK: - Bindings
extension MovieDetailsViewController {
    
    private func bindUI() {
        
    }
}

// MARK: - Factory Method 
extension MovieDetailsViewController {
    
    final class func create(with viewModel: MovieDetailsViewModel) -> MovieDetailsViewController {
        
        let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController
        vc.viewModel = viewModel
        return vc
    }
}
