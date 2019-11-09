//
//  MoviesQueriesListViewController.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class MoviesQueriesListViewController: UIViewController {

    // MARK: - Dependencies
    var viewModel: IMoviesQueriesListViewModel!
   
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Bindings
extension MoviesQueriesListViewController {
    
    private func bindUI() {
        
        //viewModel.queries.subscribe(onNext: ...
    }
}

// MARK: - Table View
extension MoviesQueriesListViewController {
    
    private func configTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
    }
}

// MARK: - Factory Method
extension MoviesQueriesListViewController {
    
    final class func create(with viewModel: MoviesQueriesListViewModel) -> MoviesQueriesListViewController {
        
        let storyboard = UIStoryboard(name: "MoviesQueriesList", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: MoviesQueriesListViewController.identifier) as! MoviesQueriesListViewController 
        vc.viewModel = viewModel
        return vc
    }
}
