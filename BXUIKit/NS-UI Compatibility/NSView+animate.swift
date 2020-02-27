//**********************************************************************************************************************
//
//  NSView+animate.swift
//	Animation convenience APIs
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension NSView
{
	/// Convenience function that provides the same easy to use animation API as is available for for UIView on iOS.
	
	@available(macOS 10.12, *)
	
	public static func animate(withDuration duration:TimeInterval = 0.25, animations:@escaping ()->Void)
	{
		NSAnimationContext.runAnimationGroup()
		{
			context in
			
			context.duration = duration
			context.allowsImplicitAnimation = true
			
			animations()
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
