//
//  VideosCollectionViewCell.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrailerCell"
    private lazy var containerView = UIView()
    
    private lazy var trailerImage : ReusableImage = ReusableImage(styleImg: .medium)
    private lazy var titleLabel: ReusableLabel = ReusableLabel(labelText: "Title", color: .black, type: .title, alignment: .left)
    private lazy var sitedLabel: ReusableLabel = ReusableLabel(labelText: "ReleasedDate", color: .systemGray, type: .desc)

    private lazy var contentStack: ReusableStackView = ReusableStackView(type: .vertical, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    private lazy var fullStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 20)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(video: Video){
        print("Video \(video.imgURL)")
        if video.imgURL != ""{
            self.trailerImage.changeImageUrl(urlString: video.imgURL, isCircle: false)
        }
        
        titleLabel.text = video.name
        sitedLabel.text = video.site
        
    }
    
    func setupUI(){
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        trailerImage.clipsToBounds = true
        trailerImage.layer.cornerRadius = 5
        setupConstraint()

    }
    
    private func setupConstraint(){
        self.addSubview(containerView)
        containerView.addSubview(fullStack)
        [trailerImage, contentStack].forEach{fullStack.addArrangedSubview($0)}
        [titleLabel, sitedLabel].forEach{contentStack.addArrangedSubview($0)}
        
        fullStack.anchor(top: containerView.topAnchor, paddingTop: 5, bottom: containerView.bottomAnchor, paddingBottom: -5, left: containerView.leadingAnchor, paddingLeft: 20, right: containerView.trailingAnchor, paddingRight: -20, width: 0, height: 0)
        
        containerView.anchor(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
}
