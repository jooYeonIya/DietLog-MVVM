//
//  ImageFileManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import Foundation
import UIKit

class ImageFileManager {
    static let shared = ImageFileManager()
    
    private let fileManager = FileManager.default
    private var documentDirectory: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentDirectory = documentDirectory else { return }
        
        let imageDirectory = documentDirectory.appendingPathComponent(imageName)
        
        guard let imageData = image.pngData() else {
            print("이미지 압축 실패")
            return
        }
        
        do {
            try imageData.write(to: imageDirectory, options: [.atomic])
        } catch {
            print("이미지 저장 실패 \(error)")
        }
    }
}
