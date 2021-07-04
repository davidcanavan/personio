//
//  GenericServerErrorResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

public class GenericServerErrorResponse: Codable {
    public var error: [ServerErrorResponse]
}
