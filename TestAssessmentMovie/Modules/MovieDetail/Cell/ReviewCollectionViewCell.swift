//
//  ReviewCollectionViewCell.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewCell"
    private lazy var containerView = UIView()
    
    private lazy var profileImage : ReusableImage = ReusableImage(styleImg: .small)
    private lazy var nameLabel: ReusableLabel = ReusableLabel(labelText: "Name", color: .black, type: .title, alignment: .left)
    private lazy var ratingImage: ReusableImage = ReusableImage(styleImg: .rating)
    private lazy var ratingLabel: ReusableLabel = ReusableLabel(labelText: "Rating", color: .black, type: .rating)
    private lazy var ratingStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)


    private lazy var releasedLabel: ReusableLabel = ReusableLabel(labelText: "ReleasedDate", color: .systemGray, type: .desc)

    private lazy var contentLabel: ReusableLabel = ReusableLabel(labelText: "Content Label", color: .systemGray, type: .desc, alignment: .justified)

    private lazy var profilStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 10)

    private lazy var fullStack: ReusableStackView = ReusableStackView(type: .vertical, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(review: MovieReview){
        if review.authorDetails.avatarPath != nil{
            self.profileImage.changeImageUrl(urlString: review.authorDetails.imgURL, isCircle: true)
        }else{
            self.profileImage.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = review.authorDetails.username
        
        ratingLabel.text = "\(review.authorDetails.rating ?? 0)"
        releasedLabel.text = review.createdAt
        contentLabel.attributedText = self.attributedText(text: review.content)
        contentLabel.sizeToFit()
        contentLabel.numberOfLines = 0
    }
    
    func attributedText(text: String) -> NSMutableAttributedString {
        // Paragraph Style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = 1
        // Attributed Text
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func setupUI(){
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 5
        setupConstraint()

    }
    
    private func setupConstraint(){
        self.addSubview(containerView)
        containerView.addSubview(fullStack)
        [profileImage, nameLabel].forEach{profilStack.addArrangedSubview($0)}
        [ratingImage, ratingLabel, releasedLabel].forEach{ratingStack.addArrangedSubview($0)}

        [profilStack,ratingStack, contentLabel].forEach{fullStack.addArrangedSubview($0)}        
        fullStack.anchor(top: containerView.topAnchor, paddingTop: 10, bottom: containerView.bottomAnchor, paddingBottom: -10, left: containerView.leadingAnchor, paddingLeft: 20, right: containerView.trailingAnchor, paddingRight: -20, width: 0, height: 0)
        
        containerView.anchor(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        ratingLabel.setSize(width: 40, height: 0)
    }
}
