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
        
        
        // Set spacing between cells to zero and cell spacing is done with UIEdgeInsets + in the UIVIEW design
//        collectionViewLayout.minimumLineSpacing = 0
        // On init - create the cell spacing + size
//        configureCollectionViewLayoutItemSize()
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
    
    private func indexOfMajorCell() -> Int {
         // get index of the CELL we need to Snap to(the next cell)
        let itemWidth = collectionViewLayout.itemSize.width

        // offset from left
        // collectionViewLayout.collectionView is the width of the whole collectionView Width
        // divided by each items width gives the offset just like the menu bar
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    private func calculateSectionInset() -> CGFloat {
        //        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        //        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        //        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 300
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth) / 5
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        //        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        // our original cell width is 300, but when we configure it to have cell spacing inside
        // the cell width is actually 330
        collectionViewLayout.itemSize = CGSize(width: (collectionViewLayout.collectionView!.frame.size.width) - inset * 3, height: collectionViewLayout.collectionView!.frame.size.height)
        
        collectionViewLayout.collectionView!.reloadData()
    }
    
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
    
    // start draging
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // set the index of the cell when user first starts dragging so we know what cell is in view
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func snapToCell(velocity: CGPoint, targetContentOffset:UnsafeMutablePointer<CGPoint>, scrollView: UIScrollView){
        
        // Stop scrollView sliding for X height only: we do this because by default the phone will try to add DRAG to each movement
        targetContentOffset.pointee.x = scrollView.contentOffset.x
        
        // get the index of the CELL we want to sanp to after the user stops dragging/swiping
        // this tells us what cell to snap to
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // ===================================
        // Gesture reconition SWIPE:
        // ===================================
        // calculate conditions for swiping:
        let swipeVelocityThreshold: CGFloat = 0.5
        
        // If the user used a swipe gesture then, on dragging end, the scrollView will have velocity different then zero.
        // The velocity is always greater then 0.5 or smaller then -0.5 (depends on the direction of movement)
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < sections.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = (indexOfCellBeforeDragging - 1 >= 0) && (velocity.x < -swipeVelocityThreshold)
        
        // make sure the cell user starts to drag is also the same cell calculated are the same
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        
        // to determin if user is swiping we make sure:
        // 1 - the cell in view is the cell user is starting to drag
        // 2 - AND that either there is enough veloctiy to slide left or right
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        
        if didUseSwipeToSkipCell {
            
            // Here we’ll add the code to snap the next cell
            // or to the previous cell
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            
            // item width * index = offset of item
            // not sure why -40 centers the item
            let toValue = (self.collectionViewLayout.itemSize.width * CGFloat(snapToIndex)) - 42.5
            print("swipe")
            print(toValue)
            //
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            print("scroll")
            // once we know what cell we are needing to snap to - we tell the collectionViewLayout
            // to slide to that item with animations = true and centered
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    // at the end of the user drag we will snap to the right image
    // this function watches for both X AND Y
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        
        if ((scrollView as? UICollectionView) != nil) {
//            snapToCell(velocity: velocity, targetContentOffset:targetContentOffset, scrollView: scrollView)
        }
        
        
    }
    
    
}

