//**********************************************************************************************************************
//
//  NSUIView+Bugfixes.swift
//	Sharing UI for custom export params
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit

#elseif os(iOS)

import UIKit

#endif


//----------------------------------------------------------------------------------------------------------------------


public extension NSUIView
{
	/// This custom version of the isHidden property provides more robust (correct) behavior in certain scenarios
	/// where Apple's implementation is broken. One specific example is setting isHidden of subviews of UIStackView
	/// to true/false when also doing animation. In this case setting subview.isHidden = false only a single time
	/// often fails. One has to repeat this until it succeeds.
	///
	///	This custom implementation tries up to 1000 times before giving up.
	
	public var isHidden_workaround : Bool
	{
		set
		{
			for _ in 1...1000
			{
				self.isHidden = newValue
				if self.isHidden == newValue { break }
			}
		}
		
		get
		{
			return self.isHidden
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------
