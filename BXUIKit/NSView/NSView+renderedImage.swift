//**********************************************************************************************************************
//
//  NSView+renderedImage.swift
//	Functions to render an NSView to an image
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension NSView
{

	/// Helper to get the current CGContext
	
	public static var currentContext:CGContext?
	{
		return NSGraphicsContext.current?.cgContext
	}


	/// Renders an image from this view
	
	public var renderedImage:NSImage
	{
		let image = NSImage(size:self.bounds.size)
		image.lockFocus()
		
		if let context = Self.currentContext
		{
			self.layer?.render(in: context)
		}
		
		image.unlockFocus()
		return image
	}
	
	
	/// Create a compound image from multiple views
	
	public static func renderedImage(from views:[NSView]) -> NSImage
	{
		// Get enclosing bounds of all views
		
		var frame = CGRect.zero
		for view in views
		{
			frame = NSUnionRect(frame, view.frame)
		}
		
		// Create an image of this size and draw views into the image
		
		let image = NSImage(size:frame.size)
		image.lockFocus()
		
		for view in views
		{
			let rect = view.frame
			view.renderedImage.draw(in:rect)
		}

		image.unlockFocus()
		
		return image
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Returns the enclosing rect for a list of subviews
	
	public func enclosingRect(for subviews:[NSView]) -> CGRect
	{
		var enlosingFrame = CGRect.zero
		
		for subview in subviews
		{
			let frame = self.convert(subview.bounds, from:subview)
			enlosingFrame = NSUnionRect(enlosingFrame, frame)
		}
		
		return enlosingFrame
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


}

#endif
