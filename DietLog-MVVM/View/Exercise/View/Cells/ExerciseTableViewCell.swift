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
        }
        titleLabel.configure(text: exercise.title, font: .body)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        
        memoLabel.configure(text: exercise.memo ?? "", font: .smallBody)
        memoLabel.numberOfLines = 0
        memoLabel.lineBreakMode = .byCharWrapping
        
        optionButton.setImage(UIImage(named: "OptionMenu"), for: .normal)
        optionButton.addTarget(self, action: #selector(didTappedOptionbutton), for: .touchUpInside)
        
        backgroundWhiteView.addSubviews([thumbnailImageView, titleLabel, memoLabel, optionButton])
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(Padding.leftRightSpacing.rawValue)
            make.trailing.lessThanOrEqualTo(optionButton.snp.leading).offset(-8)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
            make.width.height.equalTo(20)
        }
        
        backgroundWhiteView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    @objc func didTappedOptionbutton() {
        delegate?.didTappedOptionButton(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
