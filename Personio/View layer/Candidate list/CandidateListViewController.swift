//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

public class CandidateListViewController: UIViewController {
    
    // MARK: - Helpers
    public enum Section {
        case main
    }
    typealias DataSource = UITableViewDiffableDataSource<Section, CandidateGeneralCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CandidateGeneralCellViewModel>
    
    // MARK: - Instance vars
    
    /// The view model for this view
    internal var viewModel: CandidateListViewModel!
    
    /// Dispose bag for Rx subsriptions
    internal let disposeBag = DisposeBag()
    
    internal var diffableDataSource: DataSource?
    
    // MARK: - User interface
    
    lazy var resultsLabel: UILabel = {
        let resultsLabel = UILabel()
        self.viewModel.candidateViewModels.driver
            .map({ "\($0.count) results"})
            .drive(resultsLabel.rx.text)
            .disposed(by: self.disposeBag)
        return resultsLabel
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.rx.controlEvent(.valueChanged)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                let isRefreshing = self?.refreshControl.isRefreshing ?? false
                if isRefreshing {
                    self?.viewModel.didPullToRefresh()
                }
            }).disposed(by: self.disposeBag)
        self.viewModel.pullToRefreshLoadingStatus.driver
            .map({ $0 == .loading }) // It's only refreshing while loading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        return refreshControl
    }()
    
//    lazy var loadingFooterView:
    
    /// Tableview for the main interface
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "candidate_list.list"
        GeneralCell.register(to: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        // Handle page loading
        self.viewModel.pageLoadingStatus.driver
            .skip(1) // Skip the default value so we don't get a cycle
            .drive(onNext: { [weak self] (loadingStatus) in
                switch loadingStatus {
                case .loaded, .loadingError:
                    self?.tableView.tableFooterView = UIView()
                case .loading:
                    let activityIndicator = UIActivityIndicatorView()
                    activityIndicator.startAnimating()
                    self?.tableView.tableFooterView = activityIndicator
                }
            }).disposed(by: self.disposeBag)
        
        // Handle main data
        self.viewModel.candidateViewModels.driver
            .skip(1) // Skip the default value so we don't get a cycle
            .delay(.seconds(2))
            .drive { [weak self] (candidateViewModels) in
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(candidateViewModels, toSection: .main)
                self?.diffableDataSource?.apply(snapshot, animatingDifferences: true)
            }.disposed(by: disposeBag)
        
        return tableView
    }()
    
    lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView(
            arrangedSubviews: [self.tableView, self.resultsLabel]
        )
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        return contentStackView
    }()
    
    /// View to handle screen loading states
    lazy var loadingManagerView: LoadingManagerView = {
        let loadingManagerViewModel = DefaultLoadingManagerViewModel(loadingStatus: self.viewModel.screenLoadingStatus.driver)
        loadingManagerViewModel.reloadRequested.bind(onNext: { [unowned self] _ in
            self.viewModel.viewDidLoad()
        })
            .disposed(by: self.disposeBag)
        let loadingManagerView = LoadingManagerView(
            viewModel: loadingManagerViewModel,
            loadedView: self.contentStackView
        )
        loadingManagerView.translatesAutoresizingMaskIntoConstraints = false
        loadingManagerView.preservesSuperviewLayoutMargins = true
        loadingManagerView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return loadingManagerView
    }()
    
    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Candidates"
        
        // Create the table view data source
        self.diffableDataSource = self.createTableViewDataSource(tableView: self.tableView)
        
        // Handle the errors
        Driver<LoadingStatus>.merge([
            self.viewModel.pageLoadingStatus.driver,
            self.viewModel.pullToRefreshLoadingStatus.driver
        ]).debounce(.milliseconds(300)) // Make sure we don't get a million of these
        .drive(onNext: { [weak self] (loadingStatus) in
            if case let .loadingError(error) = loadingStatus {
                self?.show(errorMessage: error.localizedDescription)
            }
        }).disposed(by: self.disposeBag)
        
        self.viewModel.viewDidLoad()
    }
    
    internal func show(errorMessage message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    internal func createTableViewDataSource(tableView: UITableView) -> DataSource {
        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, cellViewModel) -> UITableViewCell? in
            let cell = GeneralCell.deque(from: tableView, for: indexPath)
            print("Dequeing: \(indexPath.row)")
            cell.viewModel = cellViewModel
            return cell
        }
//        dataSource.defaultRowAnimation = .fade
        return dataSource
    }
    
    /// Loads UI, layout and bindings
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        self.view.addSubview(self.loadingManagerView)
        self.loadingManagerView.fillToSuperview(margins: true)
    }
    
}

// MARK: - UITableViewDelegate

extension CandidateListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Null check, but can never be null if this method can be called
        guard let viewModel = self.diffableDataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        // Open the route
        self.viewModel.openCandidateDetail(for: viewModel, in: self)
    }
}

extension CandidateListViewController: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
//        print("Prefetch: \(indexPaths.reduce("", { "\($0), \($1.row)" }))")
        
//        if indexPaths.last!.row >= self.candidateViewModels!.count {
//            self.viewModel.didScrollNearEnd()
//        }
    }
    
}
