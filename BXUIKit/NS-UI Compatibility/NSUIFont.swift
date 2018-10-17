//**********************************************************************************************************************
//
//  NSUIFont.swift
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

public typealias NSUIFont = NSFont

#elseif os(iOS)

import UIKit

public typealias NSUIFont = UIFont

#endif


//----------------------------------------------------------------------------------------------------------------------


extension NSUIFont
{
	/// Returns the font face name
	
	public var faceName : String
	{
		#if os(iOS)
		
		return self.fontDescriptor.object(forKey:.face) as? String ?? ""
		
		#else

		#warning("TODO: implement")
		return ""
		
		#endif
	}
}


//----------------------------------------------------------------------------------------------------------------------
