//
//  ExerciseTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit
import RxSwift

protocol ExerciseTableViewCellDelegate: AnyObject {
    func didTappedOptionButton(_ cell: ExerciseTableViewCell)
}

class ExerciseTableViewCell: UITableViewCell {
    
    static let identifier = "ExerciseTableViewCell"
    
    weak var delegate: ExerciseTableViewCellDelegate?
    
    private let backgroundWhiteView = UIView()
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let memoLabel = UILabel()
    let optionButton = UIButton()
    
    func configure(exercise: Exercise) {
        
        selectionStyle = .none
    
        backgroundWhiteView.applyRadius()
        backgroundWhiteView.applyShadow()
        backgroundWhiteView.backgroundColor = .white
        
        contentView.addSubview(backgroundWhiteView)
        contentView.backgroundColor = .customGray
        
        backgroundWhiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        thumbnailImageView.applyRadius()
        thumbnailImageView.layer.masksToBounds = true
        
        titleLabel.configure(text: exercise.title, font: .body)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakStrategy = .hangulWordPriority

        memoLabel.configure(text: exercise.memo ?? "", font: .smallBody)
        memoLabel.numberOfLines = 0
        memoLabel.lineBreakMode = .byCharWrapping
        
        optionButton.setImage(UIImage(named: "OptionMenu"), for: .normal)
        optionButton.addTarget(self, action: #selector(didTappedOptionbutton), for: .touchUpInside)
        
        backgroundWhiteView.addSubviews([thumbnailImageView, titleLabel, memoLabel, optionButton])
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.width.equalTo(160)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(9.0/16.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thumbnailImageView)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(optionButton.snp.leading).offset(-4)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
        }
    }
    
    @objc func didTappedOptionbutton() {
        delegate?.didTappedOptionButton(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
