//**********************************************************************************************************************
//
//  NSLayoutConstraint+Manage.swift
//	Adds convenience methods to NSLayoutConstraint
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import UIKit


//----------------------------------------------------------------------------------------------------------------------


extension NSLayoutConstraint
{

	/// This convenience method activates a NSLayoutConstraint and returns it again, so method chaining is possible.
	///
	/// 	self.labelConstraint = label.leadingAnchor.constraint(equalTo:self.leadingAnchor,constant:minOffset).activate()
	///
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained

	@discardableResult public func activate() -> NSLayoutConstraint
	{
		self.isActive = true
		return self
	}


	/// This convenience method activates a NSLayoutConstraint and returns it again, so method chaining is possible.
	///
	/// 	self.labelConstraint = label.leadingAnchor.constraint(equalTo:self.leadingAnchor,constant:minOffset).activate(true)
	///
	/// - parameter active: The new isActive state of the NSLayoutConstraint
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained
	
	@discardableResult public func activate(_ active: Bool) -> NSLayoutConstraint
	{
		self.isActive = active
		return self
	}


	/// Deactivates a constraint and removes it from the specified view.
	///
	/// - parameter view: If the NSLayoutConstraint is attached to this view, then it will be removed
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained

	@discardableResult public func remove(from view: NSUIView?) -> NSLayoutConstraint
	{
		self.isActive = false
		view?.removeConstraint(self)
		return self
	}

}


//----------------------------------------------------------------------------------------------------------------------

