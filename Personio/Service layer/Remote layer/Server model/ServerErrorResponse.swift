//
//  ServerErrorResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

public class ServerErrorResponse: Codable {
    public var code: Int
    public var message: String
}
