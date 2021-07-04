//
//  RemoteService.swift
//  Personio
//
//  Created by David Canavan on 04/07/2021.
//

import Foundation
import Alamofire
import RxSwift

/// Generic service that handles remote network calls
public protocol RemoteNetworkService {
    
    /// Generic function that calls an endpoint and converts the results from json to the typed model object
    /// - Parameters:
    ///   - method: The HTTP method to use
    ///   - urlString: The string URL of the resource
    func request<T: Codable>(_ method: Alamofire.HTTPMethod, _ urlString: String) -> Observable<T>
}

/// Default implementation for the generic service that handles remote network calls
public class LiveRemoteNetworkService: RemoteNetworkService {
    
    public func request<T: Codable>(_ method: HTTPMethod, _ urlString: String) -> Observable<T> {
        
        return Observable.create { (observer) -> Disposable in
            AF.request(urlString, method: method)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { (response) in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let data = response.data {
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                            observer.onCompleted()
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                }
            return Disposables.create()
        }
    }
}
