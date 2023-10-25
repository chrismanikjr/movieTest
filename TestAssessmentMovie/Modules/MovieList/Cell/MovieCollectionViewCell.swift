//
//  MovieCollectionViewCell.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell{
    static let identifier = "MovieCell"
    private lazy var containerView = UIView()
    
    private lazy var movieImage : ReusableImage = ReusableImage(styleImg: .medium)
    private lazy var titleLabel: ReusableLabel = ReusableLabel(labelText: "Title", color: .black, type: .title, alignment: .left)
    private lazy var ratingImage: ReusableImage = ReusableImage(styleImg: .rating)
    private lazy var ratingLabel: ReusableLabel = ReusableLabel(labelText: "Rating", color: .black, type: .rating)
    private lazy var releasedLabel: ReusableLabel = ReusableLabel(labelText: "ReleasedDate", color: .systemGray, type: .desc)

    private lazy var ratingStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)

    private lazy var contentStack: ReusableStackView = ReusableStackView(type: .vertical, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)
    private lazy var fullStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 20)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(movie: Movie){
            self.movieImage.changeImageUrl(urlString: movie.imgURL, isCircle: false)
        
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage)"
        releasedLabel.text = movie.releaseDate
        
    }
    
    func setupUI(){
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        movieImage.clipsToBounds = true
        movieImage.layer.cornerRadius = 5
        setupConstraint()

    }
    
    private func setupConstraint(){
        contentView.addSubview(containerView)
        containerView.addSubview(fullStack)
        [movieImage, contentStack].forEach{fullStack.addArrangedSubview($0)}
        [titleLabel, ratingStack, releasedLabel].forEach{contentStack.addArrangedSubview($0)}
        [ratingImage, ratingLabel].forEach{ratingStack.addArrangedSubview($0)}
        
        fullStack.anchor(top: containerView.topAnchor, paddingTop: 10, bottom: containerView.bottomAnchor, paddingBottom: -10, left: containerView.leadingAnchor, paddingLeft: 20, right: containerView.trailingAnchor, paddingRight: -20, width: 0, height: 0)
        
        containerView.anchor(top: contentView.topAnchor, paddingTop: 0, bottom: contentView.bottomAnchor, paddingBottom: 0, left: contentView.leadingAnchor, paddingLeft: 0, right: contentView.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
    }
    
   
}
