//
//  GeneralCellViewModel.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import Foundation

public protocol GeneralCellViewModel {
    var title: String { get }
    var subtitle: String? { get }
}

public class DefaultGeneralCellViewModel: GeneralCellViewModel {
    
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    
}
