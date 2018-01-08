//
//  ChaptersViewController.swift
//  design+code
//
//  Created by Teela Bigum on 1/7/18.
//  Copyright © 2018 Spencer Bigum. All rights reserved.
//

import UIKit

class ChaptersViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // change status bar color
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    // dark or light text for statusbar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
