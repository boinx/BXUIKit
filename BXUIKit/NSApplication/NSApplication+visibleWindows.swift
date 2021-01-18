//**********************************************************************************************************************
//
//  NSApplication+visibleWindows.swift
//	Adds convenience methods
//  Copyright ©2016 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSApplication
{
	/// Checks if we have any visible windows. Note that floating panels are ignored.
	
	func hasVisibleWindows() -> Bool
	{
		for window in self.windows
		{
			if window.isVisible && window.isOnActiveSpace && !window.isFloatingPanel
			{
				return true
			}
		}
		
		return false
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif

