//**********************************************************************************************************************
//
//  NSView+isEnabled.swift
//	Adds isEnabled to view hierarchies
//  Copyright ©2021 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSView
{
	func setEnabled(_ enabled:Bool)
	{
		if let view = self as? NSControl
		{
			view.isEnabled = enabled
		}
		else if let view = self as? NSTableView
		{
			view.isEnabled = enabled
		}
		else
		{
			for subview in self.subviews
			{
				subview.setEnabled(enabled)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


#endif
