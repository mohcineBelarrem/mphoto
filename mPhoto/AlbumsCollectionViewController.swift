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
    
}


private let reuseIdentifier = "Cell"

class AlbumsCollectionViewController: UICollectionViewController {
    
    var selectedPhoto : Photo!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(dataReady), name:Notification.Name("dataReady") , object: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return PhotoManager.shared.albums().count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionCell
    
        
        DispatchQueue.global().async {
        
        let albumID = PhotoManager.shared.albums()[indexPath.section]
        let photo = PhotoManager.shared.photos(albumID)[indexPath.row]
    
        let url = URL(string:photo.thumbnailUrl)
            
        if let imageData = try? Data.init(contentsOf: url!),
            let image = UIImage(data: imageData)  {
            
            DispatchQueue.main.async {
            cell.imageView.image = image
            cell.titleLabel.text = "Album \(photo.albumId)"
            cell.countLabel.text = "\(PhotoManager.shared.photos(albumID).count)"
            }
        }
        
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPhoto = PhotoManager.shared.photos("\(indexPath.section)")[indexPath.row]
        self.performSegue(withIdentifier: "showPhotoDetail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoDetail" {
            let dest = segue.destination as! PhotoDetailViewController
            dest.photo = selectedPhoto
        }
    }
    
    @objc func dataReady() {
        
        DispatchQueue.main.async {
        self.collectionView.reloadData()
        }
    }

}
