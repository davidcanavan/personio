//
//  CandidateDetailViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol CandidateDetailViewModel {
    
    // MARK: - Outputs
    
    // Outputs the list of position and personal models
    var detailViewModels: PublishRelay<(position: [GeneralCellViewModel], personal: [GeneralCellViewModel])> { get }
    
    /// Loads the data for this view model
    func loadData()
}

public class DefaultCandidateDetailViewModel: CandidateDetailViewModel {
    
    // MARK: - Outputs
    
    public var detailViewModels: PublishRelay<(position: [GeneralCellViewModel], personal: [GeneralCellViewModel])> = PublishRelay()
    
    // MARK: - Internal vars
    
    internal var candidate: Candidate
    
    // MARK: - Initialisers
    
    public init(candidate: Candidate) {
        self.candidate = candidate
    }
    
    public func loadData() {
        
    }
}
