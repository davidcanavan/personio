//
//  UITableView+.swift
//  Personio
//
//  Created by David Canavan on 19/07/2021.
//

import UIKit

public extension UITableView {

    func setTableHeaderView(headerView: UIView?) {
        // set the headerView
        tableHeaderView = headerView

        // check if the passed view is nil
        guard let headerView = headerView else { return }

        // check if the tableHeaderView superview view is nil just to avoid
        // to use the force unwrapping later. In case it fail something really
        // wrong happened
        guard let tableHeaderViewSuperview = tableHeaderView?.superview else {
            assertionFailure("This should not be reached!")
            return
        }

        // force updated layout
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        // set tableHeaderView width
        tableHeaderViewSuperview.addConstraint(headerView.widthAnchor.constraint(equalTo: tableHeaderViewSuperview.widthAnchor, multiplier: 1.0))

        // set tableHeaderView height
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableHeaderViewSuperview.addConstraint(headerView.heightAnchor.constraint(equalToConstant: height))
    }

    func setTableFooterView(footerView: UIView?) {
        // set the footerView
        tableFooterView = footerView

        // check if the passed view is nil
        guard let footerView = footerView else { return }

        // check if the tableFooterView superview view is nil just to avoid
        // to use the force unwrapping later. In case it fail something really
        // wrong happened
        guard let tableFooterViewSuperview = tableFooterView?.superview else {
            assertionFailure("This should not be reached!")
            return
        }

        // force updated layout
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()

        // set tableFooterView width
        tableFooterViewSuperview.addConstraint(footerView.widthAnchor.constraint(equalTo: tableFooterViewSuperview.widthAnchor, multiplier: 1.0))

        // set tableFooterView height
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableFooterViewSuperview.addConstraint(footerView.heightAnchor.constraint(equalToConstant: height))
    }
}
