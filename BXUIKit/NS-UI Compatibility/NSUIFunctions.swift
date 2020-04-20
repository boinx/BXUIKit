//**********************************************************************************************************************
//
//  NSUICompatibility.swift
//	This file should help to make shared framework code compatible with macOS and iOS platforms
//  Copyright ©2017-2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)
import UIKit
#else
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the
// instance is either a NS or a UI type instance.


#if os(iOS)

public func NSUIRectFill(_ rect:CGRect)
{
	UIRectFillUsingBlendMode(rect,.normal)
}

//public func NSUIRectFillUsingOperation(_ rect:CGRect, _ op:NSCompositingOperation)
//{
//		#warning("TODO: implement")
//}

public func NSUIRectFrame(_ rect:CGRect)
{
	UIRectFrame(rect)
}

public func NSUIRectFrameWithWidth(_ rect:CGRect,_ width:CGFloat)
{
	let d = 0.5 * width
	let frame = rect.insetBy(dx:d, dy:d)
	
	let path = NSUIBezierPath(rect:frame)
	path.lineWidth = width
	path.lineJoinStyle = .miter
	path.lineCapStyle = .square
	path.stroke()
}

public func NSUIRectClip(_ rect: CGRect)
{
	UIRectClip(rect)
}

//public func NSUIFrameRectWithWidthUsingOperation(_ rect:CGRect,_ frameWidth:CGFloat,_ op:NSCompositingOperation)
//{
//	#warning("TODO: implement")
//}

#else
   
public func NSUIRectFill(_ rect:CGRect)
{
    __NSRectFillUsingOperation(rect,NSCompositingOperationSourceOver)
}
 
public func NSUIRectFillUsingOperation(_ rect:CGRect, _ op:NSCompositingOperation)
{
    __NSRectFillUsingOperation(rect, op)
}
    
public func NSUIRectFrame(_ rect:CGRect)
{
    __NSFrameRect(rect)
}

public func NSUIRectFrameWithWidth(_ rect:CGRect,_ frameWidth:CGFloat)
{
    __NSFrameRectWithWidth(rect, frameWidth)
}

public func NSUIRectFrameWithWidthUsingOperation(_ rect:CGRect,_ frameWidth:CGFloat,_ op:NSCompositingOperation)
{
    __NSFrameRectWithWidthUsingOperation(rect, frameWidth, op)
}

public func NSUIRectClip(_ rect: CGRect)
{
	__NSRectClip(rect)
}
    
#endif


//----------------------------------------------------------------------------------------------------------------------
