//**********************************************************************************************************************
//
//  NSUILabel.swift
//	Provides a common API for labels on iOS and macOS
//  Copyright ©2017-2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the 
// instance is either a NS or a UI type instance.

#if os(macOS)
	
import AppKit

public typealias NSUILabel = NSTextField

#elseif os(iOS)

import UIKit

public typealias NSUILabel = UILabel

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension NSUILabel
{

	#if os(macOS)

	public var text : String
	{
		set
		{
			self.stringValue = newValue
		}
		
		get
		{
			return self.stringValue
		}
	}

	#endif

}


//----------------------------------------------------------------------------------------------------------------------
