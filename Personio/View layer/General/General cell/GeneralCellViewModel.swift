//
//  GeneralCellViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation

/// View model for the `GeneralCell` type
public protocol GeneralCellViewModel {
    var title: String { get }
    var subtitle: String? { get }
}

/// Default implementation of the `GeneralCellViewModel` returning basic strings
public class DefaultGeneralCellViewModel: GeneralCellViewModel {
    
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    
}
