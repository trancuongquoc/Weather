//
//  SearchTableViewController.swift
//  Weather
//
//  Created by quoccuong on 7/23/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit

protocol Delegate {
    func passSearchResult(with result: String)
}
class SearchTableViewController: UITableViewController {

    let data = ["Hanoi","New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var filteredData = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var delegate: Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.placeholder = "Search cities.."
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredData.count
        }
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if searchController.isActive {
            cell.textLabel?.text = filteredData[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = data[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = self.data[indexPath.row]
        if searchController.isActive {
             data = filteredData[indexPath.row]
        }
        delegate?.passSearchResult(with: data)
        navigationController?.popViewController(animated: true)
    }
}
extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData.removeAll(keepingCapacity:  false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (data as NSArray).filtered(using: searchPredicate)
        filteredData = array as! [String]
        tableView.reloadData()
    }
}
