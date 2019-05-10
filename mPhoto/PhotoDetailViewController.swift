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
    
    public var photo : Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(photo.id)"
        
        let url = URL(string:self.photo.url)
        
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
    

    

}
