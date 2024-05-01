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
    
    func loadImage(with imagePath: String) -> UIImage? {
        guard let documentDirectory = documentDirectory else {
            return UIImage(named: "FoodBasicImage")
        }
        
        let imageDirectory = documentDirectory.appendingPathComponent(imagePath)
        
        return UIImage(contentsOfFile: imageDirectory.path)
    }
    
    func removeImage(with imageName: String) {
        guard let documentDirectory = documentDirectory else { return }
        
        let imagePath = imageName + ".png"
        let imageDirectory = documentDirectory.appendingPathComponent(imagePath)
        
        do {
            try fileManager.removeItem(at: imageDirectory)
        } catch {
            print("Error removing file: \(error)")
        }
    }
}
