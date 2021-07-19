//
//  CandidateGeneralCellViewModel.swift
//  Personio
//
//  Created by David Canavan on 06/07/2021.
//

import Foundation

/// View model that binds the `Candidate` model to a `GeneralCell`
public struct CandidateGeneralCellViewModel: GeneralCellViewModel {
    
    public var title: String {
        return "\(index). \(self.candidate.name)"
    }
    public var subtitle: String? {
        return self.candidate.positionApplied
    }
    
    public let index: Int
    public var candidate: Candidate
    
    init(index: Int, candidate: Candidate) {
        self.index = index
        self.candidate = candidate
    }
}

extension CandidateGeneralCellViewModel: Hashable, IdentifiableType {
    public typealias Identity = Int

    public var identity : Identity {
        return candidate.id
    }

    public static func == (lhs: CandidateGeneralCellViewModel, rhs: CandidateGeneralCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
            && lhs.title == rhs.title
            && lhs.subtitle == rhs.subtitle
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
        hasher.combine(title)
        hasher.combine(subtitle)
    }
}


//extension CandidateGeneralCellViewModel: Hashable, IdentifiableType {
//    public typealias Identity = Int
//
//    public var identity : Identity {
//        return candidate.id
//    }
//
//    public static func == (lhs: CandidateGeneralCellViewModel, rhs: CandidateGeneralCellViewModel) -> Bool {
//        return lhs.candidate == rhs.candidate
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(candidate)
//    }
//}
