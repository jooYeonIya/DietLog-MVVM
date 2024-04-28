//
//  ExerciseTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    static let identifier = "ExerciseTableViewCell"
    
    func configure() {
        
        let backgroundView = UIView()
        backgroundView.applyRadius()
        backgroundView.applyShadow()
        backgroundView.backgroundColor = .white
        
        contentView.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        
        let titleLable = UILabel()
        titleLable.configure(text: "타이틀 테스트", font: .body)
        
        let memoLable = UILabel()
        memoLable.configure(text: "메모 테스트", font: .smallBody)
        memoLable.numberOfLines = 0
        memoLable.lineBreakMode = .byCharWrapping
        
        let button = UIButton()
        button.setImage(UIImage(named: "OptionMenu"), for: .normal)
        
        backgroundView.addSubviews([imageView, titleLable, memoLable, button])
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            
            // 나중에 섬네일 높이를 화면 너비로 나눠서 스케일 지정해줘야함
            make.height.equalTo(200)
        }
        
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(Padding.leftRightSpacing.rawValue)
        }
        
        memoLable.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(titleLable)
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
            make.width.height.equalTo(20)
        }
    }
}
