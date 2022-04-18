//
//  APODViewModel.swift
//  APOD
//
//  Created by Venkatesh S on 15/04/22.
//

import Foundation
import UIKit

protocol APODViewModel: AnyObject {
    var apod: APODModel? { set get }
    var onFetchAPODSucceed: (() -> Void)? { set get }
    var onFetchAPODFailure: ((Error) -> Void)? { set get }
    func fetchAPOD()
    var delegate : SpinnerDelegates? { set get }
    var searchByDate:String?  { set get }


}

final class APODDefaultViewModel: APODViewModel {
    
    var apod: APODModel?
    weak var delegate: SpinnerDelegates?
    private let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    var onFetchAPODSucceed: (() -> Void)?
    var onFetchAPODFailure: ((Error) -> Void)?
    var searchByDate: String?

    func fetchAPOD() {
        let request = APODAPIRequest(dateString: searchByDate ?? "")
        delegate?.showLoading()
        networkService.request(request) { [weak self] result in
            self?.delegate?.stopLoading()
            switch result {
            case .success(let news):
                self?.apod = news
                self?.onFetchAPODSucceed?()
            case .failure(let error):
                self?.onFetchAPODFailure?(error)
            }
        }
    }
       // Driver Code
   
}

protocol SpinnerDelegates : AnyObject {
    func showLoading()
    func stopLoading()
}


