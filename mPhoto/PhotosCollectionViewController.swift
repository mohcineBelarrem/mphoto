//
//  PhotosCollectionViewController.swift
//  mPhoto
//
//  Created by Mohcine Belarrem on 10/05/2019.
//  Copyright © 2019 mohcine. All rights reserved.
//

import UIKit

private let reuseIdentifier = "photoCell"


class PhotoCollectionCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}

class PhotosCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    public var album : [Photo]!
    public var albumTitle : String!
    public var secondaryTitle : String!
    var selectedIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .always
        navigationItem.title = albumTitle
        navigationItem.prompt = secondaryTitle
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionCell
        
        DispatchQueue.main.async {
            cell.activityIndicator.startAnimating()
            cell.imageView.isHidden = true
            cell.activityIndicator.isHidden = false
        }
        
        DispatchQueue.global().async {
            
            let photo = self.album[indexPath.row]
            
            let url = URL(string:photo.thumbnailUrl)
            
            if let imageData = try? Data.init(contentsOf: url!),
                let image = UIImage(data: imageData)  {
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.isHidden = false
                    cell.activityIndicator.isHidden = true
                }
            }
            
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "showPhotoDetail", sender: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showPhotoDetail" {
                    let dest = segue.destination as! PhotoDetailViewController
                    dest.currentIndex = selectedIndex
                    dest.album = album
                }
       
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 75.0, height: 75.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}
