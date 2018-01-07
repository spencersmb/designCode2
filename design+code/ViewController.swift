//
//  ViewController.swift
//  design+code
//
//  Created by Teela Bigum on 12/25/17.
//  Copyright © 2017 Spencer Bigum. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class ViewController: UIViewController {
    var player : AVPlayer?
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    
    @IBOutlet weak var heroBg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heroView: UIView!
    @IBOutlet weak var bookView: UIView!
    private var indexOfCellBeforeDragging = 0
    var isStatusBarHidden = false
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        guard let url = URL(string: "https://player.vimeo.com/external/235468301.hd.mp4?s=e852004d6a46ce569fcf6ef02a7d291ea581358e&profile_id=175") else {
            return
        }
        
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player

        present(playerController, animated: true) {
            player.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.alpha = 0
        deviceImageView.alpha = 0
        playVisualEffectView.alpha = 0

        scrollView.delegate = self
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
        
        UIView.animate(withDuration: 1) {
            self.titleLabel.alpha = 1
            self.deviceImageView.alpha = 1
            self.playVisualEffectView.alpha = 1
        }
        
        setStatusBarBackgroundColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Parralax
extension ViewController: UIScrollViewDelegate {
    
    func animateCell(cellFrame: CGRect) -> CATransform3D {
        // Animation code
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)

        
        return CATransform3DConcat(rotation, scale)
    }
    
    // Put Scroll functionalities to ViewController
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            // stop hero from bouncing at the top be default
            heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
            heroBg.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
        }
        
        //parallax and transform
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [ChaptersCell] {
                // Do something with the cell
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)

                let translationX = cellFrame.origin.x / 5
                cell.backgroundImage.transform = CGAffineTransform(translationX: translationX, y: 0)
                
                //First, we’re using the X position to convert that into the perspective degrees. The lower the number, the sharper the angle.
                
                cell.layer.transform = animateCell(cellFrame: cellFrame)

            }
        }
    }
    
}

// Cell Snapping
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! ChaptersCell
        let section = sections[indexPath.row]
        cell.title.text = section["title"]
        cell.subTitle.text = section["caption"]
        cell.backgroundImage.image = UIImage(named: section["image"]!)
        
        // paralax background image
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
        let cellFrame = collectionView.convert(attributes.frame, to: view)
        let translationX = cellFrame.origin.x / 5
        cell.backgroundImage.transform = CGAffineTransform(translationX: translationX, y: 0)
        
        
        cell.layer.transform = animateCell(cellFrame: cell.frame)
        return cell
    }

    // CollectionView way to do something on Item click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToSection", sender: indexPath)
    }
    
    // send data to controller we are navigating to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomeToSection" {
            
            // specifically define what controller is the destination
            // so we have acess to the variables on it
            let toViewController = segue.destination as! SectionViewController
            
            // When we called performSegue, we sent indexPath as the sender. With indexPath.row, we can get a specific section.
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            
            // set the data
            toViewController.section = section
            toViewController.sections = sections
            toViewController.indexPath = indexPath
            
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.5){
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        
    }
    
}

extension ViewController {
    
    // change status bar color
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    // dark or light text for statusbar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // when we’re coming back from the Section screen, we need to show the status bar again. Use viewWillAppear, since it runs before viewDidAppear and viewDidLoad.
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isStatusBarHidden = false
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // update the status bar
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    // setting the type of animation to slide
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

