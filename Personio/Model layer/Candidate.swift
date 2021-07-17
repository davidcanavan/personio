//
//  Candidate.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

/// Server model object `Candidate`
public class Candidate: Codable {
    
    public var id: Int
    public var name: String
    public var email: String
    public var birthDate: String
    public var yearsOfExperience: Int
    public var positionApplied: String
    public var applicationDate: String
    public var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case birthDate = "birth_date" // Note: weird format "1997-09-07"
        case yearsOfExperience = "year_of_experience" // Note: incorrect spelling
        case positionApplied = "position_applied"
        case applicationDate = "application_date" // Note: weird format "2018-07-02"
        case status
    }
    
}

//extension Candidate: Hashable {
//    
//    public static func == (lhs: Candidate, rhs: Candidate) -> Bool {
//        return lhs.id == rhs.id &&
//            lhs.name == rhs.name &&
//            lhs.email == rhs.email &&
//            lhs.birthDate == rhs.birthDate &&
//            lhs.yearsOfExperience == rhs.yearsOfExperience &&
//            lhs.positionApplied == rhs.positionApplied &&
//            lhs.applicationDate == rhs.applicationDate &&
//            lhs.status == rhs.status
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
