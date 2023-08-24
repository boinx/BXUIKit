//**********************************************************************************************************************
//
//  BXFadingTextField.swift
//	Subclass that provides visually pleasing text truncation
//  Copyright ©2023 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


open class BXFadingTextField : NSTextField
{
	var fadeMargin:CGFloat = 20.0
	
	public var isTruncated:Bool
	{
		intrinsicContentSize.width > frame.width
	}
	
	override open func setFrameSize(_ newSize:NSSize)
	{
		super.setFrameSize(newSize)
		
		if isTruncated
		{
			let white = NSColor.white.cgColor
			let clear = NSColor.clear.cgColor
			let x2 = bounds.width
			let x1 = x2 - fadeMargin
			
			let mask = CAGradientLayer()
			mask.frame = self.bounds
			mask.colors = [white,white,clear]
			mask.locations = [NSNumber(value:0.0),NSNumber(value:x1/x2),NSNumber(value:(x2-4)/x2)]
			mask.startPoint = CGPoint(0.0,0.0)
			mask.endPoint = CGPoint(1.0,0.0)
 
 			self.layer?.mask = mask
		}
		else
		{
			self.layer?.mask = nil
		}
	}
	
//	override open func draw(_ rect:NSRect)
//	{
//		super.draw(rect)
//	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif


/*

        gradient = CAGradientLayer()
        gradient.frame = label.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.9, 1]
        label.layer.mask = gradient

*/
