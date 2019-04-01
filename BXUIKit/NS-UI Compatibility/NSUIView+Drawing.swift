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

    // Provides the macOS style needsDisplay/needsLayout/needsUpdateConstraints property to UIView.
    // That way the same code can be used on both platforms.
    
    var needsDisplay:Bool
    {
        set { if newValue { self.setNeedsDisplay() } }
        get { return false }
    }

    var needsLayout:Bool
    {
        set { if newValue { self.setNeedsLayout() } }
        get { return false }
    }

    var needsUpdateConstraints:Bool
    {
        set { if newValue { self.setNeedsUpdateConstraints() } }
        get { return false }
    }

    #endif

    #if os(macOS)

    // Provides the iOS style setNeedsDisplay()/setNeedsLayout()/setNeedsUpdateConstraints() method to NSView.
    // That way the same code can be used on both platforms.
    
    func setNeedsDisplay()
    {
        self.needsDisplay = true
    }

    func setNeedsLayout()
    {
        self.needsLayout = true
    }

    func setNeedsUpdateConstraints()
    {
        self.needsUpdateConstraints = true
    }

    #endif

    /// Returns the current CGContext for drawing
    
    var currentCGContext : CGContext?
    {
        #if os(iOS)
        return UIGraphicsGetCurrentContext()
        #else
        return NSGraphicsContext.current?.cgContext
        #endif
    }
    
    
    /// Saves the current graphics state, then executes the drawing block and then restores the state again.

    func drawPreservingGraphicsState(_ block:()->Void)
    {
        guard let context = self.currentCGContext else { return }

        context.saveGState()
        block()
        context.restoreGState()
    }
	
	
    #if os(macOS)

	/// Provides the same convenience API as on iOS
	
	var alpha:CGFloat
	{
		set { self.layer?.opacity = Float(newValue) }
		get { return CGFloat(self.layer?.opacity ?? 0.0)  }
	}

	#endif

}
