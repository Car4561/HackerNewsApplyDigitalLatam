//
//  StoriesListView.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import UIKit
import HackerNewsUI

extension StoriesListViewController {
    
    final class CustomView: UIView {
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.register(StoriesListViewCell.self)
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .black
            tableView.separatorInset = .zero
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initializeView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initializeView()
        }
        
        private func initializeView() {
            backgroundColor = HNColors.viewBackground1
            addSubview(tableView)
            tableView.pinToSafeAreaSuperview()
        }

    }
    
}
