//
//  GoogleApiResponse.swift
//  BookStore_Eduardo
//
//  Created by itsector on 31/01/2020.
//  Copyright © 2020 itsector. All rights reserved.
//

import UIKit

struct GoogleApiResponse: Codable {

    var items: [book]
    
    struct book: Codable {
        var id: String
        var volumeInfo: bookInfo
        var saleInfo: buyInfo
    }
    
    struct bookInfo: Codable {
        var title: String
        var authors: [String]?
        var description: String?
        var imageLinks: images
    }
    
    struct buyInfo: Codable {
        var buyLink: String?
    }
    
    struct images: Codable {
        var smallThumbnail: String
        var thumbnail: String
    }
}
