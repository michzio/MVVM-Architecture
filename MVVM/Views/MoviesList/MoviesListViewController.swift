//
//  MoviesListViewController.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxDataSources

import Action

typealias MovieSection = AnimatableSectionModel<String, Movie> // string header, movie items 

class MoviesListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Dependencies
    var viewModel: IMoviesListViewModel!

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Source
    var dataSource: RxTableViewSectionedAnimatedDataSource<MovieSection>!
  
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        bindUI()
    }
}

// MARK: - Bindings
extension MoviesListViewController {
    
    private func bindUI() {
        
        viewModel.movies
            .debug("movies observer", trimOutput: true)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map { [unowned self] indexPath in
                try? self.dataSource.model(at: indexPath) as? Movie
            }
            .filter { $0 != nil}
            .map { $0! }
            .bind(to: viewModel.detailsAction.inputs)
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Table View
extension MoviesListViewController { // }: UITableViewDelegate, UITableViewDataSource {
    
    private func configTableView() {
        tableView.estimatedRowHeight = MovieCell.height
        tableView.rowHeight = UITableView.automaticDimension
    
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
        
        configDataSource()
    }
    
    private func configDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<MovieSection>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
                cell.viewModel = DIAppContainer.shared.container.resolve(IMovieItemViewModel.self) as? MovieItemViewModel
                
                
                if let self = self {
                    cell.configure(with: item)
                }
                return cell
            }, titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }, canEditRowAtIndexPath: { _, _ in true }
        )
    }
    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }*/
}
