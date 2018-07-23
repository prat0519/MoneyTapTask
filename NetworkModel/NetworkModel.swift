//
//  NetworkModel.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation

enum ResuestType: String {
    case get = "GET"
    case post = "POST"
}

struct UrlExtension {
    static let queryPath = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages|pageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize= 200&pilimit=20&wbptterms=description&gpslimit=20&gpssearch="
}

struct NetworkCall {
    
    static let shared = NetworkCall()
    
    //make server request and catch the response in completion handler
    func apiRequest(_ path: String, requestType type: ResuestType, completionBlock block: @escaping(_ data: Data?, _ error: Error?)-> Void) {
        guard let request = prepareRequest(path, .get) else {return}
        let urlSession = URLSession.shared
        let dataTask =  urlSession.dataTask(with: request) { (data, responseHeader, error) in
            guard let header = responseHeader else {
                block(nil, nil)
                return
            }
            
            let httpResponse = header as! HTTPURLResponse
            print(httpResponse.statusCode)
            if httpResponse.statusCode ==  200 {
                guard let d = data else {
                    block(nil, nil)
                    return
                }
                print(d)
                block(d, nil)
            } else {
                block(nil, error)
            }
        }
        dataTask.resume()
    }
    
    //method to generate URL reuest
    private func prepareRequest(_ path: String, _ type: ResuestType) -> URLRequest? {
        
        guard let urlPath = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {return nil}
        guard let url = URL(string: urlPath) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = type.rawValue
        print(type.rawValue)
        return urlRequest
    }
}
