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
        return "\(index). \(self.candidate.name)"
    }
    public var subtitle: String? {
        return self.candidate.positionApplied
    }
    
    public let index: Int
    public let candidate: Candidate
    
    init(index: Int, candidate: Candidate) {
        self.index = index
        self.candidate = candidate
    }
}

extension CandidateGeneralCellViewModel: Hashable {
    
    public static func == (lhs: CandidateGeneralCellViewModel, rhs: CandidateGeneralCellViewModel) -> Bool {
        
        return lhs.candidate.id == rhs.candidate.id //&&
//            lhs.candidate.name == rhs.candidate.name &&
//            lhs.candidate.email == rhs.candidate.email &&
//            lhs.candidate.birthDate == rhs.candidate.birthDate &&
//            lhs.candidate.yearsOfExperience == rhs.candidate.yearsOfExperience &&
//            lhs.candidate.positionApplied == rhs.candidate.positionApplied &&
//            lhs.candidate.applicationDate == rhs.candidate.applicationDate &&
//            lhs.candidate.status == rhs.candidate.status
        
//        return lhs.candidate == rhs.candidate
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(candidate.id)
    }
}
