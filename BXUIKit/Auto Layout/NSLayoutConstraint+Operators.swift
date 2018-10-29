//**********************************************************************************************************************
//
//  NSLayoutConstraint+Operators.swift
//	Adds custom operators for creating NSLayoutConstraints
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
	// Provide a closure based API on UIView that let us define auto-layout constraints for a single view

    public func defineLayout(using closure: (NSUIView)->Void)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        closure(self)
    }
	
    // Provide shorter names for common anchors
	
    public var leading : NSLayoutXAxisAnchor	{ return self.leadingAnchor	 }
    public var trailing : NSLayoutXAxisAnchor 	{ return self.trailingAnchor }
    public var left : NSLayoutXAxisAnchor		{ return self.leftAnchor 	 }
    public var centerX : NSLayoutXAxisAnchor	{ return self.centerXAnchor  }
    public var right : NSLayoutXAxisAnchor		{ return self.rightAnchor 	 }
    public var top : NSLayoutYAxisAnchor		{ return self.topAnchor 	 }
    public var centerY : NSLayoutYAxisAnchor	{ return self.centerYAnchor  }
    public var bottom : NSLayoutYAxisAnchor		{ return self.bottomAnchor 	 }
    public var width : NSLayoutDimension		{ return self.widthAnchor 	 }
    public var height : NSLayoutDimension		{ return self.heightAnchor 	 }
}


//----------------------------------------------------------------------------------------------------------------------


extension NSUILayoutGuide
{
    // Provide shorter names for common anchors
	
    public var leading : NSLayoutXAxisAnchor	{ return self.leadingAnchor	 }
    public var trailing : NSLayoutXAxisAnchor 	{ return self.trailingAnchor }
    public var left : NSLayoutXAxisAnchor		{ return self.leftAnchor 	 }
    public var centerX : NSLayoutXAxisAnchor	{ return self.centerXAnchor  }
    public var right : NSLayoutXAxisAnchor		{ return self.rightAnchor 	 }
    public var top : NSLayoutYAxisAnchor		{ return self.topAnchor 	 }
    public var centerY : NSLayoutYAxisAnchor	{ return self.centerYAnchor  }
    public var bottom : NSLayoutYAxisAnchor		{ return self.bottomAnchor 	 }
    public var width : NSLayoutDimension		{ return self.widthAnchor 	 }
    public var height : NSLayoutDimension		{ return self.heightAnchor 	 }
}


//----------------------------------------------------------------------------------------------------------------------


// Since Objective-C generics are not quite as powerful as Swift generics, define a protocol that will let us
// treat NSLayoutAnchor as if it was a native Swift type.


public protocol LayoutAnchor
{
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}


//----------------------------------------------------------------------------------------------------------------------


// Combine an anchor and a constant into a tuple, which can be used by the ==, >=, <= operators defined below

public func + <A:LayoutAnchor> (lhs:A, rhs:CGFloat) -> (A,CGFloat)
{
	return (lhs, rhs)
}

public func - <A:LayoutAnchor> (lhs:A, rhs:CGFloat) -> (A,CGFloat)
{
	return (lhs, -rhs)
}


//----------------------------------------------------------------------------------------------------------------------


// Define equal relationships

@discardableResult public func == <A:LayoutAnchor> (lhs:A, rhs:(A,CGFloat)) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( equalTo:rhs.0, constant:rhs.1)
	constraint.isActive = true
	return constraint
}

@discardableResult public func == (lhs:NSLayoutXAxisAnchor, rhs:NSLayoutXAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( equalTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func == (lhs:NSLayoutYAxisAnchor, rhs:NSLayoutYAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( equalTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func == (lhs:NSLayoutDimension, rhs:NSLayoutDimension) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( equalTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func == (lhs:NSLayoutDimension, rhs:CGFloat) -> NSLayoutConstraint
{
	let constraint = lhs.constraint(equalToConstant: rhs)
	constraint.isActive = true
	return constraint
}


//----------------------------------------------------------------------------------------------------------------------


// Define greater or equal relationships

@discardableResult public func >= <A:LayoutAnchor> (lhs:A, rhs:(A,CGFloat)) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( greaterThanOrEqualTo:rhs.0, constant:rhs.1)
	constraint.isActive = true
	return constraint
}

@discardableResult public func >= (lhs:NSLayoutXAxisAnchor, rhs:NSLayoutXAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( greaterThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func >= (lhs:NSLayoutYAxisAnchor, rhs:NSLayoutYAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( greaterThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func >= (lhs:NSLayoutDimension, rhs:NSLayoutDimension) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( greaterThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func >= (lhs:NSLayoutDimension, rhs:CGFloat) -> NSLayoutConstraint
{
	let constraint = lhs.constraint( greaterThanOrEqualToConstant:rhs )
	constraint.isActive = true
	return constraint
}


//----------------------------------------------------------------------------------------------------------------------


// Define smaller or equal relationships

@discardableResult public func <= <A:LayoutAnchor> (lhs:A, rhs:(A,CGFloat)) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( lessThanOrEqualTo:rhs.0, constant:rhs.1)
	constraint.isActive = true
	return constraint
}

@discardableResult public func <= (lhs:NSLayoutXAxisAnchor, rhs:NSLayoutXAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( lessThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func <= (lhs:NSLayoutYAxisAnchor, rhs:NSLayoutYAxisAnchor) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( lessThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func <= (lhs:NSLayoutDimension, rhs:NSLayoutDimension) -> NSLayoutConstraint
{
    let constraint = lhs.constraint( lessThanOrEqualTo:rhs, constant:0.0)
	constraint.isActive = true
	return constraint
}

@discardableResult public func <= (lhs:NSLayoutDimension, rhs:CGFloat) -> NSLayoutConstraint
{
	let constraint = lhs.constraint( lessThanOrEqualToConstant:rhs )
	constraint.isActive = true
	return constraint
}


//----------------------------------------------------------------------------------------------------------------------


/// Store a NSLayoutConstraint reference in a property

@discardableResult public func => (lhs: NSLayoutConstraint, rhs: inout NSLayoutConstraint?) -> NSLayoutConstraint
{
	rhs = lhs
	return lhs
}

/// Store a NSLayoutConstraint reference in an array

@discardableResult public func => (lhs: NSLayoutConstraint, rhs: inout [NSLayoutConstraint]) -> NSLayoutConstraint
{
	rhs.append(lhs)
	return lhs
}


//----------------------------------------------------------------------------------------------------------------------
