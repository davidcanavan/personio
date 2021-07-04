//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift
import RxAlamofire

class ViewController: UIViewController {
    
    internal var candidates: [Candidate]?
    
    internal let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        GeneralCell.register(to: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
//
//        Observable.of(["Helo", "Goodby"])
//            .bind(to: tableView.rx.items).disposed(by: disposeBag)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Urgh"
        
        let candidatesObservable: Observable<[Candidate]> = MockPersonioRemoteService().getCandidateList()
        candidatesObservable.subscribe(onNext: { [weak self] (candidates) in
            self?.candidates = candidates
            self?.tableView.reloadData()
        }).disposed(by: self.disposeBag)
        
//        RxAlamofire.json(.get, PersonioRemoteServiceSupportedURLs.candidates)
//            .observe(on: MainScheduler.instance)
//            .subscribe { print($0) }
//            .disposed(by: disposeBag)
        
        
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.tableView)
        self.tableView.fillToSuperviewMargins()
    }
    
    @IBAction func didPressActionButton(_ sender: Any) {
        
        let url = URL(string: PersonioRemoteServiceSupportedURLs.candidates)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Check for any unexpected error
            if let error = error {
                print(error)
                return
            }
            
            // Check that we've gotten some data and a http response
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                return
            }
            
            // So this can return weird data
            if 200..<300 ~= response.statusCode {
                let decoder = JSONDecoder()
                
                if let serverError = try? decoder.decode(GenericServerErrorResponse.self, from: data) {
                    print(serverError)
                } else if let candidates = try? decoder.decode(GenericListResponse<Candidate>.self, from: data) {
                    print(candidates)
                }
                
                
            } else {
                print(response.statusCode)
            }
        }).resume()
    }
    

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candidates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GeneralCell.deque(from: tableView, for: indexPath)
        guard let candidate = self.candidates?[indexPath.row] else { return cell }
        cell.titleLabel.text = candidate.name
        cell.subtitleLabel.text = candidate.positionApplied
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
