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


extension NSWindow
{
	public func printScreenInfo()
	{
		guard let screen = self.screen else { return  }
		let desc = screen.deviceDescription
		guard let id = desc[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else { return  }
		guard let mode = CGDisplayCopyDisplayMode(id) else { return  }
		
		Swift.dump(desc)
		Swift.dump(mode)
		
		var info = ""
		info += "\(desc)\n"
		info += "\(mode)\n"
		
		let screenSize = CGDisplayScreenSize(id)
		Swift.dump("screenSize in mm = \(screenSize)\n")

		let bounds = CGDisplayBounds(id)
		Swift.dump("bounds = \(bounds)\n")
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
