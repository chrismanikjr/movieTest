//
//  MovieDetailCollectionViewCell.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import UIKit

class MovieDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieDetailCell"
    private lazy var containerView = UIView()
    
    private lazy var movieImage : ReusableImage = ReusableImage(styleImg: .big)
    private lazy var titleLabel: ReusableLabel = ReusableLabel(labelText: "", color: .black, type: .title)
    private lazy var topStack : ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .center, distributionStack: .fill, spacingStack: 10)
    
    private lazy var ratingImage: ReusableImage = ReusableImage(styleImg: .rating)
    private lazy var ratingLabel: ReusableLabel = ReusableLabel(labelText: "", color: .black, type: .title)
    private lazy var ratingStack: ReusableStackView = ReusableStackView(type: .horizontal, alignmentStack: .fill, distributionStack: .fill, spacingStack: 5)

    private lazy var descLabel: ReusableLabel = ReusableLabel(labelText: "Desc", color: .black, type: .desc)

    private lazy var releasedLabel: ReusableLabel = ReusableLabel(labelText: "ReleasedDate", color: .systemGray, type: .desc)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(movieDetail: MovieDetail){
        if movieDetail.posterPath != nil{
            movieImage.changeImageUrl(urlString: movieDetail.imgURL, isCircle: false)
        }
        descLabel.numberOfLines = 0
        titleLabel.text = movieDetail.title
        ratingLabel.text = movieDetail.rating
        descLabel.text = movieDetail.overview
        releasedLabel.text = movieDetail.releaseDate
    }
    
    func setupUI(){
        self.backgroundColor = .white
        setupConstraint()
        
    }
    
    func setupConstraint(){
        
        let padding = 20.0
        let spacing = 10.0
        
        [movieImage, topStack, descLabel, releasedLabel].forEach{self.addSubview($0)}
        [ratingImage, ratingLabel].forEach{ratingStack.addArrangedSubview($0)}

        [titleLabel, ratingStack, releasedLabel].forEach{topStack.addArrangedSubview($0)}
        
        movieImage.anchor(top: self.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, width: 0, height: 0)
        
        topStack.anchor(top: movieImage.bottomAnchor, paddingTop: padding, bottom: nil, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: padding, right: self.trailingAnchor, paddingRight: -padding, width: 0, height: 0)
        
        
        descLabel.anchor(top: topStack.bottomAnchor, paddingTop: spacing, bottom: self.bottomAnchor, paddingBottom: -spacing, left: self.leadingAnchor, paddingLeft: padding, right: self.trailingAnchor, paddingRight: -padding, width: 0, height: 0)
        

    }
}
