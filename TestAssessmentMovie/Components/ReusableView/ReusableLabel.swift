//
//  ReusableLabel.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit


class ReusableLabel: UILabel{
    enum LabelType{
        case header
        case title
        case desc
        case rating
    }

    public private(set) var labelText: String
    public private(set) var color: UIColor
    public private(set) var type: LabelType
    public private(set) var alignment: NSTextAlignment?
    
    init(labelText: String, color: UIColor, type: LabelType, alignment: NSTextAlignment? = .left) {
        self.labelText = labelText
        self.color = color
        self.type = type
        self.alignment = alignment
        super.init(frame: .zero)
        self.configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(){
        self.text = labelText
        self.textColor = color
        self.textAlignment = alignment ?? .left
        configureLabelStyle()
    }
    
    func configureLabelStyle(){
        switch type {
        case .header:
            self.font = UIFont.boldSystemFont(ofSize: 20)
        case .title:
            self.font = UIFont.boldSystemFont(ofSize: 17)
        case .desc:
            self.font = UIFont.systemFont(ofSize: 13)
        case .rating:
            self.font = UIFont.boldSystemFont(ofSize: 15)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0

    }
    
}
