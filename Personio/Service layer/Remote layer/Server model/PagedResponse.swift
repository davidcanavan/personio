//
//  GenericListResponse.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import Foundation

/// Model class to handle paged json responses
public class PagedResponse<T: Codable>: Codable {
    public var page: Int
    public var items: [T]
    public var hasMore: Bool
    
    public init(page: Int, items: [T], hasMore: Bool) {
        self.page = page
        self.items = items
        self.hasMore = hasMore
    }
}
