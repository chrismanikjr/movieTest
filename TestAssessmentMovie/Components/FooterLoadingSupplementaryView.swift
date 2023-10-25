//
//  FooterLoadingSupplementaryView.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 25/10/23.
//

import UIKit

class FooterLoadingSupplementaryView: UICollectionReusableView {
    
    let refreshControl = UIActivityIndicatorView()
    static let reuseIdentifier = "footer-loading-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

extension FooterLoadingSupplementaryView {
    func configure() {
        addSubview(refreshControl)
        refreshControl.center(centerX: centerXAnchor, centerY: centerYAnchor)
    }
}
