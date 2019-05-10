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
    
}

class PhotosCollectionViewController: UICollectionViewController {

    public var album : [Photo]!
    public var albumTitle : String!
    var selectedIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = albumTitle
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionCell
        
        
        DispatchQueue.global().async {
            
            let photo = self.album[indexPath.row]
            
            let url = URL(string:photo.thumbnailUrl)
            
            if let imageData = try? Data.init(contentsOf: url!),
                let image = UIImage(data: imageData)  {
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
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
    

}
