//
//  UIViewController+Extension.swift
//  CAssignment
//
//  Created by Optimum  on 20/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

extension UIViewController
{
    
    func showErrorAlert(with message: String , titile : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titile, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showActivityIndicator(activityView:UIActivityIndicatorView) {
        DispatchQueue.main.async {
            
            activityView.color = UIColor.gray
            activityView.center = self.view.center
            self.view.addSubview(activityView)
            self.view.bringSubviewToFront( activityView)
            activityView.startAnimating()
        }
    }
    
    func hideActivityIndicator(activityView:UIActivityIndicatorView){
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
}
