//
//  CandidateDetailViewController.swift
//  Personio
//
//  Created by David Canavan on 05/07/2021.
//

import UIKit
import RxSwift

public class CandidateDetailViewController: UIViewController {
    
    // MARK: - Instance vars
    
    /// The view model for this view
    internal var viewModel: CandidateDetailViewModel!
    
    internal var candidatesCellModels: [GeneralCellViewModel]?
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
        
//        self.viewModel.candidates.bind { [weak self] (candidatesCellModels) in
//            self?.candidatesCellModels = candidatesCellModels
//            self?.tableView.reloadData()
//        }.disposed(by: disposeBag)
        
        return tableView
    }()
    
    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "{candidate name}"
        self.viewModel.loadData()
    }
    
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        self.view.addSubview(self.tableView)
        self.tableView.fillToSuperviewMargins()
    }
}

extension CandidateDetailViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0// self.candidateViewModels?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GeneralCell.deque(from: tableView, for: indexPath)
//        guard let candidateViewModel = self.candidateViewModels?[indexPath.row] else {
            return cell
//        }
//        cell.viewModel = candidateViewModel
//        return cell
    }
    
}
