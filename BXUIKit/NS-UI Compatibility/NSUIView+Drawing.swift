//
//  NSUIView+Drawing.swift
//  BXUIKit
//
//  Created by Stefan Fochler on 16.10.18.
//  Copyright © 2018 Boinx Software Ltd. All rights reserved.
//

#if os(macOS)

import AppKit

#elseif os(iOS)

import UIKit

#endif


public extension NSUIView
{
    #if os(iOS)

    // Provides the macOS style needsDisplay property to UIView. That way the same code can be used on both platforms.
    
    public var needsDisplay:Bool
    {
        set { if newValue { self.setNeedsDisplay() } }
        get { return false }
    }

    #endif

    #if os(macOS)

    // Provides the iOS style setNeedsDisplay() method to UIView. That way the same code can be used on both platforms.
    
    public func setNeedsDisplay()
    {
        self.needsDisplay = true
    }

    #endif

    /// Returns the current CGContext for drawing
    
    public var currentCGContext : CGContext?
    {
        #if os(iOS)
        return UIGraphicsGetCurrentContext()
        #else
        return NSGraphicsContext.current?.cgContext
        #endif
    }
    
    
    /// Saves the current graphics state, then executes the drawing block and then restores the state again.

    public func drawPreservingGraphicsState(_ block:()->Void)
    {
        guard let context = self.currentCGContext else { return }

        context.saveGState()
        block()
        context.restoreGState()
    }
	
	
    #if os(macOS)

	/// Provides the same convenience API as on iOS
	
	public var alpha:CGFloat
	{
		set { self.layer?.opacity = Float(newValue) }
		get { return CGFloat(self.layer?.opacity ?? 0.0)  }
	}

	#endif

}
