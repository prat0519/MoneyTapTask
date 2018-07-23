//
//  WikiPageViewController.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit
import WebKit

class WikiPageViewController: UIViewController, WKNavigationDelegate, HUDRenderer {

    var urlString: String?
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showActivityIndicator()
        
        wkWebView.isHidden = true
        wkWebView.navigationDelegate = self
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideActivityIndicator()
        webView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
