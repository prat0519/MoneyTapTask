//
//  SearchApiManager.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation

struct SearchApiManager {
    
    //call api request to server and get data of search category
    func fetchSearch(text searchText: String, completionBlock block: @escaping(_ resultModel: ResultModel?, _ error: String?)-> Void) {
        
        let path = UrlExtension.queryPath + searchText
        NetworkCall.shared.apiRequest(path, requestType: .get) { (data, error) in
            if error == nil {
                guard let data = data  else {
                    block(nil, "No Data")
                    return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ResultModel.self, from: data)
                    block(searchResult, nil)
                } catch let exception {
                    print(exception.localizedDescription)
                    block(nil, "No Data")
                }
            }
        }
    }
}
