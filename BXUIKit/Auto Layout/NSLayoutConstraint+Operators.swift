//**********************************************************************************************************************
//
//  NSLayoutConstraint+Operators.swift
//	Adds custom operators for creating NSLayoutConstraints
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import UIKit


//----------------------------------------------------------------------------------------------------------------------


infix operator •==• : ComparisonPrecedence
infix operator •>=• : ComparisonPrecedence
infix operator •<=• : ComparisonPrecedence


//----------------------------------------------------------------------------------------------------------------------


extension NSLayoutXAxisAnchor
{
	@discardableResult public static func •==• (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(equalTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •>=• (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •<=• (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension NSLayoutYAxisAnchor
{
	@discardableResult public static func •==• (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(equalTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •>=• (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •<=• (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}
}


//----------------------------------------------------------------------------------------------------------------------


extension NSLayoutDimension
{
	@discardableResult public static func •==• (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(equalToConstant: rhs)
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult public static func •>=• (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult public static func •<=• (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •==• (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(equalTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •>=• (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}

	@discardableResult public static func •<=• (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint
	{
		let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
		constraint.isActive = true
		return constraint
	}
}


//----------------------------------------------------------------------------------------------------------------------
