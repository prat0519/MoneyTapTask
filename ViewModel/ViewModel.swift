//
//  ViewModel.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation
import UIKit

class ViewModel  {
    
    private let apiManager = SearchApiManager()
    private var batchcomplete: Bool!
    
    // usege of CustomLsitener of type pages.
    var pages: DataRouter<[Pages]?> = DataRouter(nil)
    var apiFailed: DataRouter<String?> = DataRouter(nil)
    
    //locally calling for search text
    func fetchLocalSearch(text searchText: String) -> Int {
        
        self.pages.value = nil
        SearchResultDB.shared().getResults(text: searchText) { (resultModel, errorMessage) in
            guard let result = resultModel else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            self.batchcomplete = result.batchcomplete
            guard let query = result.query else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }

            guard let pages = query.pages else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            self.apiFailed.value = "NO"
            self.pages.value = pages
        }
        return numberOfRows()
    }
    
    //api calling for the search text
    func fetchSearch(text searchText: String) {
        
        //self.pages.value = nil
        
        apiManager.fetchSearch(text: searchText) { (resultModel, errorMessage) in
            guard let result = resultModel else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            self.batchcomplete = result.batchcomplete
            guard let query = result.query else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            
            guard let pages = query.pages else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            
            self.apiFailed.value = "NO"
            self.pages.value = pages
            // Save result model in CoreData.
            // Need handle data for handling offline case.
            SearchResultDB.shared().saveResults(result,searchText)
            
        }
    }
    
    //returns no of rows
    func numberOfRows() -> Int {
        if self.pages.value == nil {
            return 0
        }
        return (self.pages.value?.count)!
    }
    
   //return page object model
    func getPages(_ index: Int) -> Pages? {
        if let page = self.pages.value?[index] {
            return page
        }
        return nil
    }
    
    //return title based on page index object
    func getTitle(_ index: Int) -> String? {
        if let page = self.pages.value?[index] {
            if let title = page.title {
                return title.replacingOccurrences(of: " ", with: "_")
            }
            return nil
        }
        return nil
    }
}
