//
//  ViewController.swift
//  Personio
//
//  Created by David Canavan on 01/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

/// Tableview section
fileprivate struct Section {
    var header: String
    var items: [CandidateGeneralCellViewModel]
}

extension Section: AnimatableSectionModelType {
    
    var identity: String {
        return self.header
    }

    init(original: Section, items: [CandidateGeneralCellViewModel]) {
        self = original
        self.items = items
    }
    
}

public class CandidateListViewController: UIViewController {
    
    // MARK: - Instance vars
    
    /// The view model for this view
    internal var viewModel: CandidateListViewModel!
    
    /// Dispose bag for Rx subsriptions
    internal let disposeBag = DisposeBag()
    
//    internal var diffableDataSource: DataSource?
    
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
        let toggle = UISwitch()
        return refreshControl
    }()
    
    lazy var tableHeaderView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
//        let titleLabel = UILabel()
//        titleLabel.text = "Title"
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "I am your leader and here's some really long text that should just expand like a boss"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
        headerView.addSubview(subtitleLabel)
        subtitleLabel.fillToSuperview(margins: true)
        headerView.backgroundColor = .lightGray
        return headerView
    }()
    
    /// Tableview for the main interface
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "candidate_list.list"
        GeneralCell.register(to: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // Add the footer view
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        
        tableView.delegate = self
        
        self.bindTableView(tableView)
        
        return tableView
    }()
    
    internal func bindTableView(_ tableView: UITableView) {
        tableView.rx.contentOffset.asDriver()
            .withLatestFrom(self.viewModel.pageLoadingStatus.driver)
            .skip(1)
            .filter({ loadingStatus -> Bool in
                return loadingStatus != .loading && tableView.isNearBottomEdge()
            })
            .map({ _ in () })
            .drive(onNext: { [weak self] () in
                self?.viewModel.didScrollNearEnd()
            }).disposed(by: self.disposeBag)
        
        // Handle page loading
        self.viewModel.pageLoadingStatus.driver
            .skip(1) // Skip the default value so we don't get a cycle
            .drive(onNext: { [weak self] (loadingStatus) in
                switch loadingStatus {
                case .loaded, .loadingError, .pending:
                    self?.tableView.tableFooterView = UIView()
                case .loading:
                    let activityIndicator = UIActivityIndicatorView()
                    activityIndicator.startAnimating()
                    self?.tableView.tableFooterView = activityIndicator
                }
            }).disposed(by: self.disposeBag)
        
        // Handle main data
        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(configureCell: { (dataSource, tableView, indexPath, viewModel) -> UITableViewCell in
            let cell = GeneralCell.deque(from: tableView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        })

        self.viewModel.candidateViewModels.driver
            .skip(1) // Skip the default value so we don't get a cycle
            .map({ [Section(header: "None", items: $0)] })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
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
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateTableViewHeaderHeight()
    }
    
    func updateTableViewHeaderHeight() {
            
        if let tableHeaderView = self.tableView.tableHeaderView {

            let newHeight = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerViewFrame = tableHeaderView.frame
            
            if headerViewFrame.size.height != newHeight {
                headerViewFrame.size.height = 200
                tableHeaderView.frame = headerViewFrame
                self.tableView.tableHeaderView = tableHeaderView
            }
        }
    }
    
    internal func show(errorMessage message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
//    internal func createTableViewDataSource(tableView: UITableView) -> DataSource {
//        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, cellViewModel) -> UITableViewCell? in
//            let cell = GeneralCell.deque(from: tableView, for: indexPath)
//            print("Dequeing: \(indexPath.row)")
//            cell.viewModel = cellViewModel
//            return cell
//        }
////        dataSource.defaultRowAnimation = .fade
//        return dataSource
//    }
    
    /// Loads UI, layout and bindings
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white

        self.view.addSubview(self.loadingManagerView)
        self.loadingManagerView.fillToSuperview(margins: true)
        
        // Add the header view
        self.tableView.tableHeaderView = self.tableHeaderView
        
    }
    
}

// MARK: - UITableViewDelegate

extension CandidateListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? GeneralCell else {
            return
        }
        
        // Open the route
        self.viewModel.openCandidateDetail(for: cell.viewModel, in: self)
    }
}


