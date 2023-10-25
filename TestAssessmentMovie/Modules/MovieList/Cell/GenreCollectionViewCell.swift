//
//  GenreCell.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell{
    static let identifier = "GenreCell"
    private lazy var containerView = UIView()
    private var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var titleLabel: ReusableLabel = ReusableLabel(labelText: "Title", color: .black, type: .title, alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(genre: Genre){
        titleLabel.text = genre.name
        setupUI()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: titleLabel.sizeThatFits(size).width + 40, height: 40)
    }
    
    private func setupUI(){
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        setupConstraint()

        selectedView.frame = self.bounds
        self.selectedBackgroundView = selectedView

    }
    
    private func setupConstraint(){
        self.addSubview(titleLabel)
//        containerView.addSubview(titleLabel)
        
        titleLabel.anchor(top: self.topAnchor, paddingTop: 5, bottom: self.bottomAnchor, paddingBottom: -5, left: self.leadingAnchor, paddingLeft: 10, right: self.trailingAnchor, paddingRight: -10, width: 0, height: 0)
        
//        containerView.anchor(top: self.topAnchor, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, left: self.leadingAnchor, paddingLeft: 0, right: self.trailingAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
   
}
