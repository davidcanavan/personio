//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    internal let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let observable: Observable<String> = Observable.create { observer in
            print("Create thread -----> \(Thread.current)")
            observer.onNext("Hello")
            sleep(2)
            observer.onNext("Hello again")
            sleep(2)
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribe(on: MainScheduler.instance)
        observable.subscribe(onNext: { (value: String) in
            print("onNext thread -----> \(Thread.current)")
            print(value)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        .disposed(by: disposeBag)
    }
    
    private func printSomething(_ value: String) {
        print(value)
    }
    
    @IBAction func didPressActionButton(_ sender: Any) {
        
//        Observable<String>.just("Hello").subscribe(onNext: { value in
//            print(value)
//        }, onCompleted: {
//            print("Completed")
//        }, onDisposed: {
//            print("Disposed")
//        })//.disposed(by: self.disposeBag)
        
//        self.testObservable.subscribe { (value: String) in
//            print(value)
//        } onError: { (error) in
//            print(error)
//        } onCompleted: {
//            print("completed")
//        } onDisposed: {
//            print("disposed")
//        }.disposed(by: disposeBag)
        
        
    }
    

}

