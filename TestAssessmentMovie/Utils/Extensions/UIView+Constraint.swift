//
//  UIView+Constraint.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom : NSLayoutYAxisAnchor? , paddingBottom : CGFloat ,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setSize( width : CGFloat ,  height : CGFloat)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
    }
    
    func center(centerX: NSLayoutXAxisAnchor?, paddingX: CGFloat, centerY: NSLayoutYAxisAnchor?, paddingY: CGFloat){
        translatesAutoresizingMaskIntoConstraints =  false
        if let centerX = centerX{
            centerXAnchor.constraint(equalTo: centerX, constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: paddingY).isActive = true
        }
    }
    func center(centerX : NSLayoutXAxisAnchor? , centerY : NSLayoutYAxisAnchor?)  {
        translatesAutoresizingMaskIntoConstraints = false
        self.center(centerX: centerX, paddingX: 0, centerY: centerY, paddingY: 0)
        
    }
}
