//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift
import Alamofire

class CandidateListViewController: UIViewController {
    
    // MARK: - Vars
    
    /// The view model for this view
    internal var viewModel: CandidateListViewModel!
    
    internal var candidates: [Candidate]?
    /// Bag for disposed subuscriptions
    internal let disposeBag = DisposeBag()
    
    // MARK: - User interface
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        GeneralCell.register(to: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Candidates"
        
        self.viewModel.loadData()
        
        self.viewModel.candidates.bind { [weak self] (candidates) in
            self?.candidates = candidates
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
        self.tableView.fillToSuperviewMargins()
    }
    
}

extension CandidateListViewController: UITableViewDataSource {
    
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

extension CandidateListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
