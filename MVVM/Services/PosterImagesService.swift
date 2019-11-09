//
//  PosterImagesService.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

public final class PosterImagesService {
    
    internal let networkService: INetworkService & INetworkService_Rx
    
    public init(networkService: INetworkService & INetworkService_Rx) {
        self.networkService = networkService
    }
}

extension PosterImagesService : IPosterImagesService {

    func getPosterImage(path: String, width: Int, completion: @escaping (Result<PosterImage, Error>) -> Void ) -> Cancellable? {

        let requestable = Router.moviePoster(path: path, width: width)
        
        let sizes = [92, 185, 500, 780]
        let availableWidth = sizes.sorted().first { width <= $0 } ?? sizes.last!
        
        return networkService.request(with: requestable, queue: .main) { (result : Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                let posterImage = PosterImage(path: path, width: availableWidth, data: data)
                completion(.success(posterImage))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
