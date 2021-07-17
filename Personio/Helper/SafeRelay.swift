//
//  SafeRelay.swift
//  Personio
//
//  Created by David Canavan on 16/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

public class SafeRelay<T>: ObservableConvertibleType {
    
    public typealias Element = T
    
    internal var relay: BehaviorRelay<T>
    
    public func asObservable() -> Observable<T> {
        return relay.asObservable()
    }
    
    private(set) public lazy var driver: Driver<T> = {
        return relay.asDriver()
    }()
    
    public var value: T {
        set {
            relay.accept(newValue)
        } get {
            relay.value
        }
    }
    
    public init(value: T) {
        self.relay = BehaviorRelay(value: value)
    }
}

public extension ObservableType {
    
    func bind(to safeRelay: SafeRelay<Self.Element>) -> RxSwift.Disposable {
        return self.bind(to: safeRelay.relay)
    }
}
