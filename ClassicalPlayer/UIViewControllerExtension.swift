//
//  UIViewControllerExtension.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func setProgressIndicatorVisibility(_ visible: Bool) {
        if visible {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
        else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
