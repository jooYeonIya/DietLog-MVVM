//
//  UIimage+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 5/8/24.
//

import UIKit

extension UIImage {
    
    func fixOrientation() -> UIImage? {
        // 이미지 방향이 up이면 그대로 반환
        if ( imageOrientation == .up ) { return self }
        
        // 변환을 위한 기본 행렬(아이덴티티 행렬) 생성
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .left, .leftMirrored:
            // 원점을 이미지의 너비만큼 오른쪽으로 이동시키고, 90도 회전
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            // 원점을 이미지의 높이만큼 아래로 이동시키고, -90도 회전
            transform = transform.translatedBy(x: 0.0, y: size.height)
            transform = transform.rotated(by: -.pi / 2.0)
        case .down, .downMirrored:
            // 원점을 이미지의 너비와 높이만큼 이동시키고, 180도 회전
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        default:
            // 기타 방향에 대해서는 변환 없음
            break
        }
        
        // 이미지가 거울상으로 반사되어야 할 경우 적용
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            // 가로축을 중심으로 이미지를 반전
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .leftMirrored, .rightMirrored:
            // 세로축을 중심으로 이미지를 반전
            transform = transform.translatedBy(x: size.height, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        default:
            // 기타 방향에 대해서는 변환 없음
            break
        }
        
        // CGImage가 없으면 nil을 반환합니다.
        guard let cgImg = cgImage else { return nil }
        
        // CGContext를 생성하여 이미지 데이터를 변환
        if let context = CGContext(data: nil,
                                   width: Int(size.width), height: Int(size.height),
                                   bitsPerComponent: cgImg.bitsPerComponent,
                                   bytesPerRow: 0, space: cgImg.colorSpace!,
                                   bitmapInfo: cgImg.bitmapInfo.rawValue) {
            // 설정된 변환을 컨텍스트에 적용
            context.concatenate(transform)
            
            // 회전 방향에 따라 그리는 영역의 크기를 조절합니다.
            if imageOrientation == .left || imageOrientation == .leftMirrored ||
                imageOrientation == .right || imageOrientation == .rightMirrored {
                context.draw(cgImg, in: CGRect(x: 0.0, y: 0.0, width: size.height, height: size.width))
            } else {
                context.draw(cgImg, in: CGRect(x: 0.0 , y: 0.0, width: size.width, height: size.height))
            }
            
            // 변환된 이미지를 생성
            if let contextImage = context.makeImage() {
                return UIImage(cgImage: contextImage)
            }
        }
        
        return nil
    }
}
