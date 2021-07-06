//
//  CandidateListViewModel.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol CandidateListViewModel {
    
    // MARK: - Outputs
    
    /// Outputs the `LoadingStatus`
    var loadingStatus: PublishRelay<LoadingStatus> { get }
    
    // Outputs the list of candidate models
    var candidateViewModels: PublishRelay<[GeneralCellViewModel]> { get }
    
    /// Loads the data for this view model
    func loadData()
    
    /// Opens the candidate detail at the given index
    /// - Parameter viewModel: The index of the candidate in the source array
    /// - Parameter container: The view controller to navigate from
    func openCandidateDetail(for viewModel: GeneralCellViewModel, in container: UIViewController)
}

public class DefaultCandidateListViewModel: CandidateListViewModel {
    
    // MARK: - Internal vars
    
    internal let personioRemoteService: PersonioRemoteService
    
    /// Dispose bag for Rx subsriptions
    internal let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    
    private(set) public var loadingStatus: PublishRelay<LoadingStatus> = PublishRelay()
    private(set) public var candidateViewModels: PublishRelay<[GeneralCellViewModel]> = PublishRelay()
    
    // MARK: - Initialisers
    
    public init(personioRemoteService: PersonioRemoteService) {
        self.personioRemoteService = personioRemoteService
    }
    
    public func loadData() {
        self.loadingStatus.accept(.loading)
        
        self.personioRemoteService.getCandidateList()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (candidates) in
                let candidateCellModels = candidates.map({ candidate -> GeneralCellViewModel in
                    return CandidateGeneralCellViewModel(candidate: candidate)
                })
                self?.candidateViewModels.accept(candidateCellModels)
            }, onError: { [weak self] error in
                self?.loadingStatus.accept(.loadingError(error: error))
            }, onCompleted: { [weak self] in
                self?.loadingStatus.accept(.loaded)
            })
            .disposed(by: self.disposeBag)
    }
    
    public func openCandidateDetail(for viewModel: GeneralCellViewModel, in container: UIViewController) {
        
        guard let viewModel = viewModel as? CandidateGeneralCellViewModel else {
            return
        }
        let candidate = viewModel.candidate
        let newViewModel = DefaultCandidateDetailViewModel(candidate: candidate)
        let viewController = CandidateDetailViewController()
        viewController.viewModel = newViewModel
        container.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
