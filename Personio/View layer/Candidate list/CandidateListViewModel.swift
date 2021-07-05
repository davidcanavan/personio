//
//  CandidateListViewModel.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol CandidateListViewModel {
    
    // MARK: - Outputs
    var loadingStatus: PublishRelay<LoadingStatus> { get }
    var candidates: PublishRelay<[Candidate]> { get }
    
    func loadData()
}

public class DefaultCandidateListViewModel: CandidateListViewModel {

    // MARK: - Internal vars
    
    internal let personioRemoteService: PersonioRemoteService
    internal let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    
    private(set) public var loadingStatus: PublishRelay<LoadingStatus> = PublishRelay()
    private(set) public var candidates: PublishRelay<[Candidate]> = PublishRelay()
    
    // MARK: - Initialisers
    
    public init(personioRemoteService: PersonioRemoteService) {
        self.personioRemoteService = personioRemoteService
    }
    
    public func loadData() {
        self.loadingStatus.accept(.loading)
        
        self.personioRemoteService.getCandidateList()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (candidates) in
                self?.candidates.accept(candidates)
            }, onError: { [weak self] error in
                self?.loadingStatus.accept(.loadingError(error: error))
            }, onCompleted: { [weak self] in
                self?.loadingStatus.accept(.loaded)
            })
            .disposed(by: self.disposeBag)
    }
    
}
