//**********************************************************************************************************************
//
//  NSLayoutConstraint+Chaining.swift
//	Adds convenience methods to NSLayoutConstraint
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)
import UIKit
public typealias NSUILayoutPriority = UILayoutPriority
#else
import AppKit
public typealias NSUILayoutPriority = NSLayoutConstraint.Priority
#endif


//----------------------------------------------------------------------------------------------------------------------


infix operator => : AssignmentPrecedence


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
		return activate(true)
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


	/// Convenience function that sets the constraint priority and returns the constraint itself for easy function chaining
	
	@discardableResult public func priority(_ prio:NSUILayoutPriority) -> NSLayoutConstraint
	{
		self.priority = prio
		return self
	}


	/// This convenience method sets the constant of a NSLayoutConstraint and returns it again, so method chaining is possible.
	/// - parameter c: The new constant value
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained
	
	@discardableResult public func constant(_ c: CGFloat) -> NSLayoutConstraint
	{
		self.constant = c
		return self
	}


	/// This convenience method appends a NSLayoutConstraint to an array and returns it again, so method chaining is possible.
	///
	/// 	label.leadingAnchor.constraint(equalTo:self.leadingAnchor,constant:minOffset).activate().append(to:&array)
	///
	/// - parameter array: The NSLayoutConstraint will be appended to this array
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained
	
	@discardableResult public func append(to array:inout [NSLayoutConstraint]) -> NSLayoutConstraint
	{
		array.append(self)
		return self
	}


	/// This convenience method assigns a NSLayoutConstraint to a property and returns it again, so method chaining is possible.
	///
	/// 	label.leadingAnchor.constraint(equalTo:self.leadingAnchor,constant:minOffset).activate().assign(to:&labelConstraint)
	///
	/// - parameter property: The NSLayoutConstraint will be assigned to this property
	/// - returns: The NSLayoutConstraint (self) is returned again so that methods can be chained
	
	@discardableResult public func assign(to property:inout NSLayoutConstraint?) -> NSLayoutConstraint
	{
		property = self
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

