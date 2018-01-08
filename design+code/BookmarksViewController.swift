//
//  BookmarksViewController.swift
//  design+code
//
//  Created by Teela Bigum on 1/7/18.
//  Copyright © 2018 Spencer Bigum. All rights reserved.
//

import UIKit


class BookmarksTableViewController: UITableViewController {
    
    static var allBookmarks = BookmarkMocks()
    
    var bookmarks : BookmarkMocks = BookmarksTableViewController.allBookmarks
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bookmarks[indexPath.row].content
        return cell
    }
    
}
