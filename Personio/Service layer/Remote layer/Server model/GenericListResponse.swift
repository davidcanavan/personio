//
//  GenericListResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

/// Server model class to handle json response arrays
public class GenericListResponse<T: Codable>: Codable {
    public var data: [T]
}
