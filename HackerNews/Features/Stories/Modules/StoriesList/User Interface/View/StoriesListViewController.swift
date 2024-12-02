//
//  StoriesListViewController.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import UIKit
import HackerNewsUI

class StoriesListViewController: UIViewController {

    var output: StoriesListViewOutput!
    
    private var customView: CustomView {
        guard let view = view as? CustomView else {
            fatalError("Could not load Custom View")
        }
        return view
    }
    
    let refreshControl = UIRefreshControl()
    var tableView: UITableView { customView.tableView }

    // MARK: Life cycle
    
    override func loadView() {
        view = CustomView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureMainNavigation()
        setupRefreshControl()
        output.viewIsReady()
    }
    
    func configureMainNavigation() {
        title = StoriesStrings.List.title
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshStoriesAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshStoriesAction() {
        output.didTriggerRefresh()
    }
}


// MARK: StoriesListViewInput Methods

extension StoriesListViewController: StoriesListViewInput {

    func setUpInitialState() {
    }

    func moduleInput() -> StoriesListModuleInput {
        return output as! StoriesListModuleInput
    }
    
    func reloadStories() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension StoriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.storiesListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as StoriesListViewCell
        cell.configure(with: output.getStory(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didTapStory(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reject = UIContextualAction(style: .normal, title: StoriesStrings.List.delete) { [weak self] _, _, completion in
            self?.output.didTapDeleteStory(at: indexPath.row)
        }
        
        reject.backgroundColor = HNColors.error
        let config = UISwipeActionsConfiguration(actions: [reject])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
}
