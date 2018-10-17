//**********************************************************************************************************************
//
//  NSUIWindow.swift
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

public typealias NSUIWindow = NSWindow

#elseif os(iOS)

import UIKit

public typealias NSUIWindow = UIWindow

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension NSUIWindow
{
	#if os(iOS)

	// Provides an accessor with the same signature as on macOS
	
	public var backingScaleFactor:CGFloat
	{
		return self.screen.scale
	}

	#endif
}


//----------------------------------------------------------------------------------------------------------------------
