//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift

class CandidateListViewController: UIViewController {
    
    // MARK: - Instance vars
    
    /// The view model for this view
    internal var viewModel: CandidateListViewModel!
    
    /// Candidate view models for this view
    internal var candidateViewModels: [GeneralCellViewModel]?
    
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
        
        self.viewModel.candidateViewModels.bind { [weak self] (candidateViewModels) in
            self?.candidateViewModels = candidateViewModels
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        return tableView
    }()
    
    lazy var loadingManagerView: LoadingManagerView = {
        let loadingManagerViewModel = DefaultLoadingManagerViewModel(loadingStatus: self.viewModel.loadingStatus)
        loadingManagerViewModel.reloadRequested.bind { [weak self] in
            self?.viewModel.loadData()
        }.disposed(by: self.disposeBag)
        let loadingManagerView = LoadingManagerView(
            viewModel: loadingManagerViewModel,
            loadedView: self.tableView
        )
        loadingManagerView.translatesAutoresizingMaskIntoConstraints = false
        loadingManagerView.preservesSuperviewLayoutMargins = true
        loadingManagerView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return loadingManagerView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Candidates"
        self.viewModel.loadData()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        self.view.addSubview(self.loadingManagerView)
        self.loadingManagerView.fillToSuperviewMargins()
    }
    
}

extension CandidateListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candidateViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GeneralCell.deque(from: tableView, for: indexPath)
        guard let candidateViewModel = self.candidateViewModels?[indexPath.row] else {
            return cell
        }
        cell.viewModel = candidateViewModel
        return cell
    }
    
}

extension CandidateListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.openCandidateDetail(at: indexPath.row, in: self)
    }
}
