//
//  TitleSupplementaryView.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 25/10/23.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    let label = ReusableLabel(labelText: "Title", color: .black, type: .header)
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

extension TitleSupplementaryView {
    func configure() {
        addSubview(label)
        let inset = CGFloat(10)
        
        label.anchor(top: topAnchor, paddingTop: inset, bottom: bottomAnchor, paddingBottom: -inset, left: leadingAnchor, paddingLeft: 0, right: trailingAnchor, paddingRight: -inset, width: 0, height: 0)
    }
}
