//
//  NSUIVIew+RoundedCorners.swift
//  BXUIKit-macOS
//
//  Created by Stefan Fochler on 16.10.18.
//  Copyright © 2018 Boinx Software Ltd. All rights reserved.
//

import BXSwiftUtils

public extension NSUIView
{
    #if os(macOS)
    
    @objc public func roundCorners(_ corners: CACornerMask, radius: CGFloat)
    {
        self.wantsLayer = true
        
        if #available(macOS 10.13, *)
        {
            self.layer?.cornerRadius = radius
            self.layer?.maskedCorners = corners
            
            return
        }
        
        let mask = CAShapeLayer()
        mask.path = CGPath.roundedRect(inBounds: self.bounds, corners: corners, radius: radius)
        self.layer?.mask = mask
    }
    
    #elseif os(iOS)
    
    @objc public func roundCorners(_ corners: CACornerMask, radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    #endif
}
