//
//  MoviesViewController.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit
import RxSwift

class MoviesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Dependencies
    var viewModel: IMoviesListViewModel!
    
    //private var controllersFactory: MoviesControllersFactory!
    private var moviesListViewController: MoviesListViewController?
    private var suggestionsViewController: UIViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Outlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var moviesListContainer: UIView!
    @IBOutlet private weak var suggestionsListContainer: UIView!
    @IBOutlet private weak var searchBarContainer: UIView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var emptyDataLabel: UILabel!

    // MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        configSearchController()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.isActive = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == String(describing: MoviesListViewController.self) {
            let destination = segue.destination as? MoviesListViewController
        }
    }
    
    private func configViews() {
        title = NSLocalizedString("Movies", comment: "")
        emptyDataLabel.text = NSLocalizedString("Search Results", comment: "")

        let coordinator = DIAppContainer.shared.container.resolve(ISceneCoordinator.self) 
        coordinator?.transition(to: .moviesList, type: .embed(container: moviesListContainer))
        //coordinator?.transition(to: .moviesQueriesList, type: .embed(container: suggestionsListContainer))
    }
    
    override func add(child: UIViewController, container: UIView) {
        super.add(child: child, container: container)
        
        if let vc = child as? MoviesListViewController {
            self.moviesListViewController = vc
        }
    }
}

// MARK: - Bindings
extension MoviesViewController {
    
    private func bindUI() {
       
        searchController.searchBar.rx.text.orEmpty
            .debug("search bar", trimOutput: false)
            .bind(to: viewModel.query)
            .disposed(by: disposeBag)
        
    
    }
}

// MARK: - Search Controller
extension MoviesViewController  {
    
    private func configSearchController() {
    
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Movies", comment: "")
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        
        searchBarContainer.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
        
        searchController.accessibilityLabel = NSLocalizedString("Search Movies", comment: "")
    }
}

// MARK: - Search Controller Delegate
extension MoviesViewController : UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
}

// MARK: - Search Bar Delegate
extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else { return }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// MARK: - Factory Methods
/*
extension MoviesViewController {
    
    final class func create(with viewModel: MoviesViewModel,
                            controllersFactory: MoviesControllersFactory) -> MoviesViewController {
        
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: MoviesViewController.identifier) as! MoviesViewController
        vc.viewModel = viewModel
        vc.controllersFactory = controllersFactory
        return vc
    }
}

protocol MoviesControllersFactory {
    
    func makeSuggestionsViewController() -> UIViewController
    func makeMoviesListViewController() -> UIViewController
}
*/
