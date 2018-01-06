//
//  File.swift
//  design+code
//
//  Created by Teela Bigum on 1/6/18.
//  Copyright © 2018 Spencer Bigum. All rights reserved.
//

import UIKit

class TesitimonialViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension TesitimonialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "testimonialCell", for: indexPath) as! TestimonialCell
        cell.quoteLabel.text = testimonials[indexPath.row]["text"]
        cell.jobTitle.text = testimonials[indexPath.row]["job"]
        cell.name.text = testimonials[indexPath.row]["name"]
        cell.avatarImage.image = UIImage(named: testimonials[indexPath.item]["avatar"]! )
        return cell
    }
    
    
    
    
}
