//**********************************************************************************************************************
//
//  NSUICompatibility.swift
//	This file should help to make shared framework code compatible with macOS and iOS platforms
//  Copyright ©2017-2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import CoreGraphics


//----------------------------------------------------------------------------------------------------------------------


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the 
// instance is either a NS or a UI type instance.

#if os(macOS)
	
import AppKit

public typealias NSUIBezierPath = NSBezierPath
	
#elseif os(iOS)

import UIKit

public typealias NSUIBezierPath = UIBezierPath

#endif


//----------------------------------------------------------------------------------------------------------------------


public extension NSUIBezierPath
{

	/// Creates a path from an array of CGPoints
	
	public convenience init(with points:[CGPoint])
	{
		self.init()

		for (i,p) in points.enumerated()
		{
			if i == 0
			{
				self.move(to:p)
			}
			else
			{
				self.line(to:p)
			}
		}
		
		self.close()
	}


	/// Clips drawing to the inside of the path
	
	public func clipToInside()
	{
		self.addClip()
	}
	
	
	/// Clips drawing to the outside of the path (with the specified rect as the maximum bounds of drawing).
	/// The rect has thus to be sigificantly largers then the bounds of the path.
	
	public func clipToOutside(with frame:CGRect)
	{
		let clipPath = NSUIBezierPath(rect:frame)
		clipPath.usesEvenOddFillRule = true
		clipPath.append(self.reversed)
		clipPath.addClip()
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(iOS)

public extension UIBezierPath
{
	public func line(to point:CGPoint)
	{
		self.addLine(to:point)
	}

	public func curve(to endPoint:CGPoint,controlPoint1:CGPoint,controlPoint2:CGPoint)
	{
		self.addCurve(to:endPoint,controlPoint1:controlPoint1,controlPoint2:controlPoint2)
	}
	
	public convenience init(roundedRect rect:CGRect,xRadius:CGFloat,yRadius:CGFloat)
	{
//		self.init(roundedRect:rect,byRoundingCorners:.allCorners,cornerRadii:CGSize(width:xRadius,height:yRadius))
		
		let TL = rect.topLeft
		let TR = rect.topRight
		let BR = rect.bottomRight
		let BL = rect.bottomLeft
		let rx = min(xRadius,0.5*rect.width)
		let ry = min(yRadius,0.5*rect.height)

		self.init()
		
		self.move(to:CGPoint(x:TL.x+rx,y:TL.y+0.0))
		self.line(to:CGPoint(x:TR.x-rx,y:TR.y+0.0))
		self.addQuadCurve(to:CGPoint(x:TR.x+0.0,y:TR.y-ry),controlPoint:TR)
		self.line(to:CGPoint(x:BR.x+0.0,y:BR.y+ry))
    	self.addQuadCurve(to:CGPoint(x:BR.x-rx,y:BR.y+0.0),controlPoint:BR)
		self.line(to:CGPoint(x:BL.x+rx,y:BL.y+0.0))
    	self.addQuadCurve(to:CGPoint(x:BL.x+0.0,y:BL.y+ry),controlPoint:BL)
		self.line(to:CGPoint(x:TL.x+0.0,y:TL.y-ry))
    	self.addQuadCurve(to:CGPoint(x:TL.x+rx,y:TL.y+0.0),controlPoint:TL)
		
    	self.close()
	}
	
	public func appendOval(in rect:CGRect)
	{
		self.append(UIBezierPath(ovalIn:rect))
	}

   	public var reversed:NSUIBezierPath
   	{
		return self.reversing()
   	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(macOS)

public extension NSBezierPath
{
	/// Add iOS like convenience init
	
    public convenience init(roundedRect rect:CGRect,cornerRadius:CGFloat)
	{
		self.init(roundedRect:rect,xRadius:cornerRadius,yRadius:cornerRadius)
	}
	
	/// iOS like convenience accessor on macOS for shared platform code
	
	public var usesEvenOddFillRule:Bool
	{
		set
		{
			#if swift(>=4.2)
			self.windingRule = newValue ? .evenOdd : .nonZero
			#else
			self.windingRule = newValue ? .evenOddWindingRule : .nonZeroWindingRule
			#endif
 		}
		
		get
		{
			#if swift(>=4.2)
			return self.windingRule == .evenOdd
			#else
			return self.windingRule == .evenOddWindingRule
			#endif
			
		}
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
