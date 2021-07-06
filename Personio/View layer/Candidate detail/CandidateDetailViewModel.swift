//
//  CandidateDetailViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

/// Convenience type for sections
public typealias CandidateInfoSectionViewModel = (title: String, items: [GeneralCellViewModel])

/// View model representing the detail of a candidate
public protocol CandidateDetailViewModel {
    
    // MARK: - Outputs
    
    /// Outputs the list of position and personal models
    var sectionViewModels: PublishRelay<[CandidateInfoSectionViewModel]> { get }
    
    /// Returns the screen title
    var title: String { get }
    
    // MARK: - Inputs
    
    /// Loads the data for this view model
    func loadData()
}

public class DefaultCandidateDetailViewModel: CandidateDetailViewModel {
    
    
    // MARK: - Outputs
    
    /// Outputs the list of position and personal models
    public var sectionViewModels: PublishRelay<[CandidateInfoSectionViewModel]> = PublishRelay()
    
    /// Returns the screen title
    public var title: String {
        return self.candidate.name
    }
    
    // MARK: - Internal vars
    
    internal var candidate: Candidate
    
    // MARK: - Initialisers
    
    public init(candidate: Candidate) {
        self.candidate = candidate
    }
    
    // MARK: - Inputs
    
    /// Loads the data for this view model
    public func loadData() {
        
        let sections: [CandidateInfoSectionViewModel] = [
            (title: "Application details", items: self.getCandidateApplicationDetails()),
            (title: "Personal details", items: self.getCandidatePersonalDetails())
        ]
        self.sectionViewModels.accept(sections)
    }
    
    /// Convenience function to produce a dynamic list of candidate personal details
    internal func getCandidatePersonalDetails() -> [GeneralCellViewModel] {
        var items: [GeneralCellViewModel] = [
            DefaultGeneralCellViewModel(
                title: "Email",
                subtitle: self.candidate.email
            ),
            DefaultGeneralCellViewModel(
                title: "Birth date",
                subtitle: self.candidate.birthDate
            )
        ]
        // Add the age if there's no error in calculating it
        if let age = self.calculateAge(from: self.candidate.birthDate) {
            items.append(DefaultGeneralCellViewModel(title: "Age", subtitle: String(age)))
        }
        return items
    }
    
    /// Convenience function to produce a dynamic list of application details
    internal func getCandidateApplicationDetails() -> [GeneralCellViewModel] {
        return [
           DefaultGeneralCellViewModel(
               title: "Position applied",
               subtitle: self.candidate.positionApplied
           ),
           DefaultGeneralCellViewModel(
               title: "Date applied",
               subtitle: self.candidate.applicationDate
           ),
           DefaultGeneralCellViewModel(
               title: "Years of experience",
               subtitle: String(self.candidate.yearsOfExperience)
           ),
           DefaultGeneralCellViewModel(
               title: "Application status",
               subtitle: self.candidate.status
           ),
       ]
    }
    
    /// Calculates the age of a person from the given date string
    /// The date must be in the format "YYYY-MM-DD" or else nil will be returned
    /// - Parameters:
    ///   - string: The date string
    ///   - currentDate: The current date, default is now
    /// - Returns: The age of the person or nil ir and error or not born
    /// - Note: This is not locale aware as the date objects are very basic
    internal func calculateAge(from string: String, at currentDate: Date = Date()) -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: string), date <= currentDate else {
            return nil
        }
        
        return Calendar.current.dateComponents([.year], from: date, to: currentDate).year
    }
}
