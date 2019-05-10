//
//  AlbumsCollectionViewController.swift
//  mPhoto
//
//  Created by Mohcine Belarrem on 09/05/2019.
//  Copyright © 2019 mohcine. All rights reserved.
//

import UIKit


class AlbumCollectionCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}


private let reuseIdentifier = "Cell"

class AlbumsCollectionViewController: UICollectionViewController {
    
    var selectedAlbum : [Photo]!
    var selectedTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataReady), name:Notification.Name("dataReady") , object: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return PhotoManager.shared.albums().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionCell
        
        DispatchQueue.main.async {
            cell.activityIndicator.startAnimating()
            cell.imageView.isHidden = true
            cell.activityIndicator.isHidden = false
            cell.titleLabel.isHidden = true
            cell.countLabel.isHidden = true
        }
        
        DispatchQueue.global().async {
            
            let albumID = PhotoManager.shared.albums()[indexPath.row]
            let photo = PhotoManager.shared.photos(albumID)[indexPath.section]
            
            let url = URL(string:photo.thumbnailUrl)
            
            if let imageData = try? Data.init(contentsOf: url!),
                let image = UIImage(data: imageData)  {
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.titleLabel.text = "Album \(photo.albumId)"
                    cell.countLabel.text = "\(PhotoManager.shared.photos(albumID).count)"
                    cell.activityIndicator.stopAnimating()
                    cell.imageView.isHidden = false
                    cell.activityIndicator.isHidden = true
                    cell.titleLabel.isHidden = false
                    cell.countLabel.isHidden = false
                }
            }
            
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let albumID =   PhotoManager.shared.albums()[indexPath.row]
        selectedAlbum = PhotoManager.shared.photos("\(albumID)")
        
        selectedTitle = "Album \(albumID)"
        
        self.performSegue(withIdentifier: "showPhotos", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotos" {
            let dest = segue.destination as! PhotosCollectionViewController
            dest.album = selectedAlbum
            dest.albumTitle = selectedTitle
        }
    }
    
    @objc func dataReady() {
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
