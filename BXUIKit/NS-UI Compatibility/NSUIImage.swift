//**********************************************************************************************************************
//
//  NSUIImage.swift
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

public typealias NSUIImage = NSImage

#elseif os(iOS)

import UIKit

public typealias NSUIImage = UIImage

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(iOS)

public extension Bundle
{
	/// Returns a named image from the bundle
	
	func image(named name:String) -> NSUIImage?
	{
		return UIImage(named:name,in:self,compatibleWith:nil)
	}
}

#elseif os(macOS)

public extension Bundle
{
	/// Returns a named image from the bundle
	
	func image(named name:String) -> NSUIImage?
	{
        return self.image(forResource:NSImage.Name(name))
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
