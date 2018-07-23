//
//  HUDRenderer.swift
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

protocol HUDRenderer{}

extension HUDRenderer where Self : UIViewController{
    
    func showAlert(title:String = "",message:String, okButtonText:String = "OK",cancelButtonText:String? = nil, presentOnRootVC:Bool = false, handler: @escaping (_ succeeded:Bool)->() = {_ in  }){
        
        DispatchQueue.main.async {

            var alertController : UIAlertController
            alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            
            if let cancelText = cancelButtonText{
                alertController.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.default, handler: { finished in
                    
                    handler(false)
                }))
            }
            
            alertController.addAction(UIAlertAction(title: okButtonText, style: UIAlertActionStyle.default, handler: { finished in
                
                handler(true)
            }))
            
            if presentOnRootVC { //If this is called from any place other than a view controller
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alertController, animated: true, completion: nil)
            } else {
                
                //Present alert on a conforming viewcontroller
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func showActivityIndicator(){
        
        self.hideActivityIndicator()
        
        let delegate = (UIApplication.shared.delegate as! AppDelegate)
        
        DispatchQueue.main.async {
            
            if delegate.activityIndicatorView == nil {
                
                if let window = UIApplication.shared.keyWindow{
                    
                    let bgView = UIView(frame: window.frame)
                    bgView.backgroundColor = .black
                    bgView.alpha = 0.5
                    
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
                    activityIndicator.center = window.center
                    bgView.addSubview(activityIndicator)
                    
                    delegate.activityIndicatorView = bgView
                    
                    activityIndicator.startAnimating()
                    
                    window.addSubview(delegate.activityIndicatorView!)
                }
                
            }
        }
    }
    
    func hideActivityIndicator(){
        let delegate = (UIApplication.shared.delegate as! AppDelegate)
        DispatchQueue.main.async {
            
            if delegate.activityIndicatorView != nil {
                delegate.activityIndicatorView?.removeFromSuperview()
                delegate.activityIndicatorView = nil
            }
        }
    }
    
}

