//**********************************************************************************************************************
//
//  NSUIView.swift
//	This file should help to make shared framework code compatible with macOS and iOS platforms
//  Copyright ©2017-2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the 
// instance is either a NS or a UI type instance.

#if os(macOS)
	
import AppKit

public typealias NSUIView = NSView

#elseif os(iOS)

import UIKit

public typealias NSUIView = UIView

#endif


//----------------------------------------------------------------------------------------------------------------------

// FIXME: Should this be its own file?
public extension NSLayoutConstraint
{
	/// Removes a NSLayoutConstraint from the specified view
	
	public func remove(from view:NSUIView?)
	{
		self.isActive = false
		view?.removeConstraint(self)
	}
}


//----------------------------------------------------------------------------------------------------------------------
