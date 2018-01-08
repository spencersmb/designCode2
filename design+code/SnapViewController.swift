//
//  SnapViewController.swift
//  design+code
//
//  Created by Teela Bigum on 1/5/18.
//  Copyright © 2018 Spencer Bigum. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var snapViewController: UICollectionView!
    private var indexOfCellBeforeDragging = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        snapViewController.delegate = self
        snapViewController.dataSource = self
        // Set spacing between cells to zero and cell spacing is done with UIEdgeInsets + in the UIVIEW design
        collectionViewLayout.minimumLineSpacing = 0
        // On init - create the cell spacing + size
        configureCollectionViewLayoutItemSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SnapViewController: UIScrollViewDelegate {
    
}

extension SnapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "snapCell", for: indexPath) as! ChaptersCell
        let section = sections[indexPath.row]
        cell.backgroundImage.image = UIImage(named: section["image"]!)
        
        
        return cell
    }
    
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
        // collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        // our original cell width is 300, but when we configure it to have cell spacing inside
        // the cell width is actually 330
        collectionViewLayout.itemSize = CGSize(width: (collectionViewLayout.collectionView!.frame.size.width) - inset * 3, height: collectionViewLayout.collectionView!.frame.size.height)
        
        collectionViewLayout.collectionView!.reloadData()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        
        if ((scrollView as? UICollectionView) != nil) {
            snapToCell(velocity: velocity, targetContentOffset:targetContentOffset, scrollView: scrollView)
        }
        
        
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
        let swipeVelocityThreshold: CGFloat = 0.2
        
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
            let toValue = (self.collectionViewLayout.itemSize.width * CGFloat(snapToIndex))
//            print("swipe")
//            print(toValue)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue - 45, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
//            print("scroll")
            // once we know what cell we are needing to snap to - we tell the collectionViewLayout
            // to slide to that item with animations = true and centered
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
}

































