//
//  NSUIVIew+RoundedCorners.swift
//  BXUIKit-macOS
//
//  Created by Stefan Fochler on 16.10.18.
//  Copyright © 2018 Boinx Software Ltd. All rights reserved.
//

import QuartzCore.CoreAnimation
import BXSwiftUtils

#if os(macOS)
import AppKit
#else
import UIKit
#endif


public extension NSUIView
{
    #if os(macOS)
    
    @objc func roundCorners(_ corners: CACornerMask, radius: CGFloat)
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
    
    @objc func roundCorners(_ corners: CACornerMask, radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    #endif
}
