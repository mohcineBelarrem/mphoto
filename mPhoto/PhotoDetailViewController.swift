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
    
    public var photo : Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailLabel.isHidden = true

        self.title = "\(photo.id)"
        
        let url = URL(string:self.photo.url)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        DispatchQueue.global().async {
            
            if let imageData = try? Data.init(contentsOf: url!),
                let image = UIImage(data: imageData)  {
                
                DispatchQueue.main.async {
                    self.imageVIew.image = image
                    self.photoDetailLabel.text = self.photo.title
                }
            }
            
        }
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        switch gesture.direction {
        case .up:
            hideShowDetailLabel(true)
        case .down:
             hideShowDetailLabel(false)
        default:
            return
        }
        
    }
    
    func hideShowDetailLabel(_ show: Bool){
        
        UIView.animate(withDuration: 0.5) {
            self.photoDetailLabel.isHidden = !show
            let height = self.view.frame.height
            self.detailViewHeightConstraint.constant = show ? 0.5 * height : 0.02 * height
            self.view.layoutIfNeeded()
        }
    }

}
