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
    
    // MARK: - Inputs
    
    /// Loads data for the view
    func viewDidLoad()
    func didScrollNearEnd()
    func didPullToRefresh()
    
    // MARK: - Outputs
    
    /// Outputs the `LoadingStatus`
    var screenLoadingStatus: SafeRelay<LoadingStatus> { get }
    var pageLoadingStatus: SafeRelay<LoadingStatus> { get }
    var pullToRefreshLoadingStatus: SafeRelay<LoadingStatus> { get }
    
    // Outputs the list of candidate models
    var candidateViewModels: SafeRelay<[CandidateGeneralCellViewModel]> { get }
    
    /// Opens the candidate detail at the given index
    /// - Parameter viewModel: The index of the candidate in the source array
    /// - Parameter container: The view controller to navigate from
    func openCandidateDetail(for viewModel: GeneralCellViewModel, in container: UIViewController)
}

public class DefaultCandidateListViewModel: CandidateListViewModel {
    
    
    // MARK: - Internal vars
    internal let personioRemoteService: PersonioRemoteService
    internal let disposeBag = DisposeBag()
    internal var currentPage: Int = 0
    
    // MARK: - Outputs
    private(set) public var screenLoadingStatus = SafeRelay<LoadingStatus>(value: .loading)
    private(set) public var pageLoadingStatus = SafeRelay<LoadingStatus>(value: .pending)
    private(set) public var pullToRefreshLoadingStatus = SafeRelay<LoadingStatus>(value: .pending)
    private(set) public var candidateViewModels = SafeRelay<[CandidateGeneralCellViewModel]>(value: [])
    
    // MARK: - Initialisers
    public init(personioRemoteService: PersonioRemoteService) {
        self.personioRemoteService = personioRemoteService
    }
    
    // MARK: - CandidateListViewModel Inputs
    public func viewDidLoad() {
        print("View did load")
        self.loadData(initial: true, loadingStatusStream: self.screenLoadingStatus)
    }
    
    public func didScrollNearEnd() {
        print("Did scroll near end")
        self.loadData(initial: false, loadingStatusStream: self.pageLoadingStatus)
    }
    
    public func didPullToRefresh() {
        print("Did pull to refresh")
        self.loadData(initial: true, loadingStatusStream: self.pullToRefreshLoadingStatus)
    }
    
    // MARK: - Business logic
    // TODO: Check that this loading stream will unbind once the loading is completed
    internal func loadData(initial: Bool, loadingStatusStream: SafeRelay<LoadingStatus>) {
        // Reset the current page if we're going from scratch
        self.currentPage = initial ? 0 : self.currentPage
        
        // Network request stream
        let candidateListStream = self.personioRemoteService.getCandidateList(page: currentPage).share()
        
        // Loading status stream
        candidateListStream
            .getLoadingStatusStream()
            .do(onNext: { [weak self] loadingStatus in
                print(loadingStatus)
                if loadingStatus == .loaded {
                    self?.currentPage += 1
                }
            })
            .bind(to: loadingStatusStream).disposed(by: self.disposeBag)
        
        // Candidate view models stream, add the new page of data
        candidateListStream
            .materialize()
            .filter({ $0.error == nil }) // Filter out errors
            .dematerialize()
            .withLatestFrom(self.candidateViewModels, resultSelector: { (pagedResponse, viewModels) -> [CandidateGeneralCellViewModel] in
                
                var mergedViewModels: [CandidateGeneralCellViewModel] = []
                if !initial {
                    mergedViewModels.append(contentsOf: viewModels)
                }
                let count = mergedViewModels.count
                let newViewModels = pagedResponse.items.enumerated().map({ (index, candidate) -> CandidateGeneralCellViewModel in
                    return CandidateGeneralCellViewModel(index: index + count, candidate: candidate)
                })
                mergedViewModels.append(contentsOf: newViewModels)
                return mergedViewModels
            })
            .bind(to: self.candidateViewModels).disposed(by: self.disposeBag)
        
        // Subscribe
        candidateListStream.subscribe().disposed(by: self.disposeBag)
    }
    
    // MARK: - Navigation
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
