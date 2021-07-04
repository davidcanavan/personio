//
//  GenericServerErrorResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

/// Server model class to handle Personio specific error responses
/// These models crop up even though the API response status is 200
public class GenericServerErrorResponse: Codable {
    public var error: [ServerErrorResponse]
}
