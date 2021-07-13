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
    
    internal var sectionViewModels: [CandidateInfoSectionViewModel]?
    
    /// Dispose bag for Rx subsriptions
    internal let disposeBag = DisposeBag()
    
    // MARK: - User interface
    
    /// The main tableview for the interface
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "candidate_detail.list"
        GeneralCell.register(to: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        
        self.viewModel.sectionViewModels.bind { [weak self] (sectionViewModels) in
            self?.sectionViewModels = sectionViewModels
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        return tableView
    }()
    
    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
        self.viewModel.loadData()
    }
    
    /// Loads UI, layout and bindings
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        self.view.addSubview(self.tableView)
        self.tableView.fillToSuperview(margins: false)
    }
}

// MARK: - UITableViewDataSource

extension CandidateDetailViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionViewModels?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionViewModels?[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionViewModels?[section].items.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GeneralCell.deque(from: tableView, for: indexPath)
        
        guard let viewModel = self.sectionViewModels?[indexPath.section].items[indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
        cell.subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        cell.contentStackView.axis = .horizontal
        cell.accessoryType = .none
        cell.viewModel = viewModel
        return cell
    }
    
}
