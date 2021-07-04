//
//  RemoteService.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

///
public protocol RemoteNetworkService {
    
    /// Makes a network call with the given parameters
    /// - Parameters:
    ///   - method: One of the standard http methods
    ///   - urlString: The url to query
    /// - Returns: An observable sequence with the given response object of type `T`
    func request<T: Codable>(_ method: Alamofire.HTTPMethod, _ urlString: String) -> Observable<T>
}

public class LiveRemoteNetworkService: RemoteNetworkService {
    

    public func request<T: Codable>(_ method: HTTPMethod, _ urlString: String) -> Observable<T> {
        
        return RxAlamofire.request(method, urlString)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData().map { (responseTuple: (HTTPURLResponse, Data)) -> T in
                let (_, data) = responseTuple // Get the data from the response
                do { // Parse the object into
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let error {
                    throw error
                }
            }
    }
    
    
}
