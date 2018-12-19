//**********************************************************************************************************************
//
//  NSLayoutConstraint+Multiplier.swift
//	Adds changeable multiplier to NSLayoutConstraint
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)
import UIKit
#else
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


extension NSLayoutConstraint
{

	/// Since the multiplier property of NSLayoutConstraint cannot be changed, this function creates
	/// a new constraint with exactly the same parameters as self, but with the new multiplier value.
	/// - parameter multiplier: The value for the multiplier
	/// - returns: The new constraint
	
	@discardableResult public func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint
	{
		let newConstraint = NSLayoutConstraint(
			item: self.firstItem as Any,
			attribute: self.firstAttribute,
			relatedBy: self.relation,
			toItem: self.secondItem,
			attribute: self.secondAttribute,
			multiplier: multiplier,
			constant: self.constant)
		
			newConstraint.priority = self.priority
    		newConstraint.identifier = self.identifier
			newConstraint.shouldBeArchived = self.shouldBeArchived
		
			NSLayoutConstraint.deactivate([self])
			NSLayoutConstraint.activate([newConstraint])
			return newConstraint
	}

}


//----------------------------------------------------------------------------------------------------------------------

