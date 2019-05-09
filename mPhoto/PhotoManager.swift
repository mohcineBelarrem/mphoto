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
