//
//  SectionViewController.swift
//  design+code
//
//  Created by Teela Bigum on 12/29/17.
//  Copyright © 2017 Spencer Bigum. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    var section: [String: String]!
    
    // Progress variables
    var sections: [[String: String]]!
    var indexPath: IndexPath!
    var isStatusBarHidden = false
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = section["title"]
        captionLabel.text = section["caption"]
        bodyLabel.text = section["body"]
        coverImageView.image = UIImage(named: section["image"]!)
        
        // since array starts at 0 - we add 1
        progressLabel.text = "\(indexPath.row+1) / \((sections.count))"
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
