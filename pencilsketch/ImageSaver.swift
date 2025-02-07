//
//  Untitled.swift
//  pencilsketch
//
//  Created by SS-MAC-005 on 07/02/25.
//
import UIKit

class ImageSaver {
    
    static func saveToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

