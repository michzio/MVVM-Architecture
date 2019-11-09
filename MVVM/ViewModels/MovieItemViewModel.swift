//
//  MovieItemViewModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

class MovieItemViewModel : IMovieItemViewModel {    
    
    private let disposeBag = DisposeBag()
    
    private let repository: IPosterImagesRepository
    
    init(repository: IPosterImagesRepository) {
        self.repository = repository
    }
    
    // MARK: - Outputs
    private let posterImageSubject = BehaviorSubject<Data?>(value: nil)
    var posterImage: Observable<Data?> {
        return posterImageSubject.asObservable()
    }
    
    // MARK: - Inputs
    func updatePosterImage(path: String, width: Int) {
        
        repository.image(with: path, width: width)
            .debug("poster image request", trimOutput: true)
            .map { $0?.data }
            .bind(to: posterImageSubject)
        .disposed(by: disposeBag)
    }
}
