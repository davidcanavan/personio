//
//  GenericListResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

public class GenericListResponse<T: Codable>: Codable {
    public var data: [T]
}
