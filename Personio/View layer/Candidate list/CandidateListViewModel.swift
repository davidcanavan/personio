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
    
    var loading: BehaviorRelay<Bool> {get}
    var candidates: BehaviorRelay<[Candidate]> {get}
    
    func loadData()
}

public class DefaultCandidateListViewModel: CandidateListViewModel {

    // MARK: - Internal vars
    
    internal let personioRemoteService: PersonioRemoteService
    internal let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    
    private(set) public var loading: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    private(set) public var candidates: BehaviorRelay<[Candidate]> = BehaviorRelay(value: [])
    
    // MARK: - Initialisers
    
    public init(personioRemoteService: PersonioRemoteService) {
        self.personioRemoteService = personioRemoteService
    }
    
    public func loadData() {
        self.loading.accept(true)
        
        self.personioRemoteService.getCandidateList()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (candidates) in
                self?.candidates.accept(candidates)
            }, onError: { error in
                print(error)
            }, onCompleted: { [weak self] in
                self?.loading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
}
