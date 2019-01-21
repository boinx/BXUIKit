//**********************************************************************************************************************
//
//  NSUIView+Constraints.swift
//	Adds constraint management functions
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)
import UIKit
#else
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


extension NSUIView
{
	// Remove all constraints from this view

    public func removeAllConstraints()
    {
		self.removeConstraints(self.constraints)
    }
	
	// Convenience function that takes an optional and automatically unwraps it before removing the constraint
	
    public func removeConstraint(_ constraint:NSLayoutConstraint?)
    {
		if let constraint = constraint
		{
			self.removeConstraint(constraint)
		}
    }
}


//----------------------------------------------------------------------------------------------------------------------
