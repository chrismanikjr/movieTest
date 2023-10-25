//
//  ReusableStackView.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import UIKit
class ReusableStackView: UIStackView{
    enum typeStack{
        case horizontal
        case vertical
    }
    public private(set) var type: typeStack
    public private(set) var alignmentStack: UIStackView.Alignment
    public private(set) var distributionStack: UIStackView.Distribution
    public private(set) var spacingStack: CGFloat
    
    init(type: typeStack, alignmentStack: UIStackView.Alignment, distributionStack: UIStackView.Distribution, spacingStack: CGFloat) {
        self.type = type
        self.alignmentStack = alignmentStack
        self.distributionStack = distributionStack
        self.spacingStack = spacingStack
        super.init(frame: .zero)
        self.configureStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureStack(){
        switch type{
        case .horizontal:
            self.axis = .horizontal
        case .vertical:
            self.axis = .vertical
        }
        self.alignment = alignmentStack
        self.distribution = distributionStack
        self.spacing = spacingStack
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
