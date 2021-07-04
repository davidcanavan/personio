//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift
import Alamofire

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
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Candidates"
        
        PersonioServiceFactory.personioRemoteService
            .getCandidateList().subscribe { [weak self] (candidates: [Candidate]) in
                self?.candidates = candidates
                self?.tableView.reloadData()
            } onError: { (error) in
                print(error)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.disposed(by: self.disposeBag)
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.tableView)
        self.tableView.fillToSuperviewMargins()
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
