//
//  ViewController.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 22/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, HUDRenderer {

    @IBOutlet weak var searchResultTableView: UITableView!
    var viewModel = ViewModel()
    private var isApiFailed: Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        self.searchResultTableView.delegate = self
        self.searchResultTableView.delegate = self
        self.searchResultTableView.estimatedRowHeight = 85

        viewModel.pages.bind { [unowned self] (pages) in
            guard pages != nil else {
                DispatchQueue.main.async {
                    if self.isApiFailed {
                        self.isApiFailed = false
                        self.navigationItem.title = "NO RESULT"
                    }
                    self.hideActivityIndicator()
                    self.searchResultTableView.reloadData()
                }
                return
            }
            DispatchQueue.main.async {
                self.isApiFailed = false
                self.hideActivityIndicator()
                self.searchResultTableView.reloadData()
            }
        }
        
        viewModel.apiFailed.bind { [unowned self] (status) in
            guard let status = status else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.navigationItem.title = "SEARCH"
                }
                return
            }
            if status == "YES" {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.navigationItem.title = "NO RESULT"
                }
            }
        }
    }
    
    fileprivate func setupNavigationUI() {
        navigationItem.title = "SEARCH"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkGray,NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 20.0)!]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let title = viewModel.getTitle(indexPath.row) {
            let wikiPath = "https://en.wikipedia.org/wiki/\(title)"
            if let wikiPage = wikiPath.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                let wikiPageVC = storyboard.instantiateViewController(withIdentifier: "wikiPageVC") as! WikiPageViewController
                wikiPageVC.urlString = wikiPage
                self.navigationController?.pushViewController(wikiPageVC, animated: true)
            }
        }
        else {
            let alertController = UIAlertController(title: "No link available", message: "Extra information is not available for this result", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            alertController.show(self, sender: nil)
        }
        
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let customCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        if let pages = viewModel.getPages(indexPath.row) {
            customCell.configureCell(pages)
        }
        cell = customCell
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText =  searchBar.text, searchText.count != 0{
            let count = viewModel.fetchLocalSearch(text: searchText)
            
            if count == 0 {
                self.showActivityIndicator()
            }
            viewModel.fetchSearch(text: searchText)
            setupNavigationUI()
            self.navigationItem.title = searchText.uppercased()
        } else {
            print("Please enter search text...")
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



