//
//  PhotoManager.swift
//  mPhoto
//
//  Created by Mohcine Belarrem on 09/05/2019.
//  Copyright © 2019 mohcine. All rights reserved.
//

import Foundation

///This will be our base struct, following the JSon Pattern
struct Photo : Decodable {
    let albumId : Int
    let id : Int
    let title : String
    let url : String
    let thumbnailUrl : String
    
}

final class PhotoManager {
    private init() {}
    static let shared = PhotoManager()
    
    private var photosDictionary: [String:[Photo]] = [:]

    func albums () -> [String] {
        return Array(photosDictionary.keys).sorted{$0.localizedStandardCompare($1) == .orderedAscending}
    }
    
    func photos (_ albumId : String) -> [Photo] {
        return photosDictionary[albumId] ?? [Photo]()
    }
    
    func addPhoto(_ photo: Photo) {
        
        let albumID = "\(photo.albumId)"
        
        if photosDictionary.keys.contains(albumID) {
            var photosArray = photosDictionary[albumID]
            photosArray?.append(photo)
            photosDictionary[albumID] = photosArray
        } else {
            photosDictionary[albumID] = [photo]
        }
        
    }
    
    func getPhotosData() {
        
        //Backup url for low size data
        //https://my-json-server.typicode.com/mohcinebelarrem/photosdb/photos
        
        let stringUrl = "https://jsonplaceholder.typicode.com/photos"
        guard let Url = URL(string: stringUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: Url) {[weak self] (data,response,error) in
            
            do {
                
                let photos = try JSONDecoder().decode([Photo].self, from: data!)
                for photo in photos {
                    self?.addPhoto(photo)
                }
                
                let notification = Notification(name: Notification.Name("dataReady"))
                
                NotificationCenter.default.post(notification)
                
            } catch {
                print("Something Went wrong while parsing data.")
            }
            
            }.resume()
    }
    
    
    func printAlbums() {
        
        for albumId in photosDictionary.keys {
            
            let array = photosDictionary[albumId]
            
            print("\(albumId) \(array!.count)")
            
        }
    }
    
}
