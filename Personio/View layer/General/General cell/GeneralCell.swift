//
//  GeneralCell.swift
//  Personio
//
//  Created by David Canavan on 02/07/2021.
//

import UIKit

public class GeneralCell: UITableViewCell {
    
    // MARK: Instance fields
    
    var viewModel: GeneralCellViewModel! {
        didSet {
            self.titleLabel.text = viewModel.title
            self.subtitleLabel.text = viewModel.subtitle
            self.subtitleLabel.isHidden = viewModel.subtitle == nil
        }
    }
    
    // MARK: Views
    
    /// Larger label for title text
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "title"
        return label
    }()
    
    /// Smaller label for subtitle text
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "subtitle"
        return label
    }()
    
    /// Vertical stack view that lays out `titleLabel` and `subtitleLabel`
    public lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: Lifecycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Helper functions
    
    public class func register(to tableView: UITableView) {
        tableView.register(GeneralCell.self, forCellReuseIdentifier: Self.cellIdenfier)
    }
    
    public class func deque(from tableView: UITableView, for indexPath: IndexPath) -> GeneralCell {
        return tableView.dequeueReusableCell(withIdentifier: Self.cellIdenfier, for: indexPath) as! GeneralCell
    }
    
    public class var cellIdenfier: String {
        return String(describing: type(of: self))
    }
    
    // MARK:- Setup
    
    private func setupView() {
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(self.contentStackView)
        self.contentStackView.fillToSuperviewMargins()
    }
    
}
