//
//  CandidateGeneralCellViewModel.swift
//  Personio
//
//  Created by David Canavan on 06/07/2021.
//

import Foundation

/// View model that binds the `Candidate` model to a `GeneralCell`
public class CandidateGeneralCellViewModel: GeneralCellViewModel {
    
    public var title: String {
        return self.candidate.name
    }
    public var subtitle: String? {
        return self.candidate.positionApplied
    }
    
    public let candidate: Candidate
    
    init(candidate: Candidate) {
        self.candidate = candidate
    }
}
