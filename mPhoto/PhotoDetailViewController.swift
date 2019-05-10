//
//  PhotoDetailViewController.swift
//  mPhoto
//
//  Created by Mohcine Belarrem on 09/05/2019.
//  Copyright © 2019 mohcine. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var photoDetailLabel: UILabel!
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicatorYConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //public var photo : Photo!
    
    public var album : [Photo]!
    public var currentIndex : Int!
    
    fileprivate func showPhotoAtCurrentIndex() {
        let photo = album[currentIndex]
        self.title = "\(photo.id)"
        let url = URL(string:photo.url)
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.imageVIew.isHidden = true
            self.activityIndicator.isHidden = false
            }
                
            if let imageData = try? Data.init(contentsOf: url!),
                let image = UIImage(data: imageData)  {
                
                DispatchQueue.main.async {
                    self.imageVIew.image = image
                    self.photoDetailLabel.text = photo.title
                    self.activityIndicator.stopAnimating()
                    self.imageVIew.isHidden = false
                    self.activityIndicator.isHidden = true
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailLabel.isHidden = true

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        showPhotoAtCurrentIndex()
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        switch gesture.direction {
        case .up:
            hideShowDetailLabel(true)
        case .down:
             hideShowDetailLabel(false)
        case .left:
            showNextPreviousImage(true)
        case .right:
            showNextPreviousImage(false)
        default:
            return
        }
        
    }
    
    func showNextPreviousImage(_ next: Bool){
        
        let newIndex = currentIndex + ( next ? 1 : -1)
        
        if newIndex < 0 || newIndex >= album.count {
            return
        } else {
            currentIndex = newIndex
        }
        
        self.showPhotoAtCurrentIndex()
        
    }
    
    func hideShowDetailLabel(_ show: Bool){
        
        UIView.animate(withDuration: 0.5) {
            self.photoDetailLabel.isHidden = !show
            let height = self.view.frame.height
            self.detailViewHeightConstraint.constant = show ? 0.5 * height : 0.02 * height
            self.activityIndicatorYConstraint.constant = show ? -0.25 * height : 0
            self.view.layoutIfNeeded()
        }
    }

}
