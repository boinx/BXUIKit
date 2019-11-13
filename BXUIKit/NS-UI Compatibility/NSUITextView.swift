//**********************************************************************************************************************
//
//  NSUITextView.swift
//	This file should help to make shared framework code compatible with macOS and iOS platforms
//  Copyright ©2017-2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the 
// instance is either a NS or a UI type instance.

#if os(macOS)
	
import AppKit

public typealias NSUITextView = NSTextView

#elseif os(iOS)

import UIKit

public typealias NSUITextView = UITextView

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension NSUITextView
{
	/// In macOS and iOS the NSUITextView has a textStorage property. The problem is that it's type is
	/// slightly different. On macOS the property is defined as NSTextStorage? (optional) whereas on iOS
	/// it is defined as NSTextStorage (non-optional). This makes writing shared code needlessly difficult.
	/// To help in this situation this helper method always returns an optional, which can then be used
	/// consistently in shared code.
	
	public var optionalTextStorage : NSTextStorage?
	{
		return self.textStorage
	}
	
	
	#if os(iOS)
	
	/// This method is also available on NSTextView (macOS). It sends out a notification to the delegate
	/// after changes have been made to the text. Since the same method is now available on both platforms,
	/// it can be used in shared code.
	
	public func didChangeText()
	{
		self.delegate?.textViewDidChange?(self)
	}
	
	#endif


	#if os(macOS)

	/// Adds a convenience accessor to NSTextView (macOS) with the same signature as available on UITextView (iOS)
	
	open var attributedText : NSAttributedString!
	{
		set
		{
			let len = self.textStorage?.length ?? 0
			let range = NSMakeRange(0,len)
			self.textStorage?.replaceCharacters(in:range,with:newValue)
		}
		
		get
		{
			return self.textStorage?.copy() as? NSAttributedString
		}
	}

	#endif


	#if os(macOS)

	/// Adds a convenience accessor to NSTextView (macOS) with the same signature as available on UITextView (iOS)
	
	public var textAlignment : NSTextAlignment
	{
		set
		{
			if let text = textStorage
			{
				let all = NSMakeRange(0,text.length)
				text.beginEditing()
				
				text.enumerateAttributes(in:all,options:[])
				{
					(attributes,range,outStop) in
					
					if let style = (attributes[.paragraphStyle] as? NSObject)?.mutableCopy() as? NSMutableParagraphStyle
					{
						style.alignment = newValue
						text.removeAttribute(.paragraphStyle, range:range)
						text.addAttribute(.paragraphStyle, value:style, range:range)
					}
				}
				
				text.endEditing()
			}
		}
	
		get
		{
			var alignment:NSTextAlignment? = nil
			var n = 0
			
			if let text = textStorage
			{
				let all = NSMakeRange(0,text.length)
				
				text.enumerateAttributes(in:all,options:[])
				{
					(attributes,range,outStop) in
					
					if let style = attributes[.paragraphStyle] as? NSParagraphStyle
					{
						if n == 0
						{
							alignment = style.alignment
						}
						else if alignment != style.alignment
						{
							alignment = nil
						}

						n += 1
					}
				}
			}
			
			return alignment ?? .center
		}
	}

	#endif


	// The following convenienve methods for setting and getting typingAttributes provide the same signature on
	// iOS and macOS. Unfortunately Apple messed up and didn't do it right, so we'll have to fix it here so we
	// can write platform independent code.
	
	#if os(macOS) && !swift(>=4.2)
	
	public func setTypingAttribute(_ value:Any,forKey key:NSAttributedStringKey)
	{
		self.typingAttributes[key] = value
	}

	public func typingAttribute(forKey key:NSAttributedStringKey) -> Any?
	{
		return self.typingAttributes[key]
	}
	
	#else
	
	public func setTypingAttribute(_ value:Any,forKey key:NSAttributedString.Key)
	{
		self.typingAttributes[key] = value
	}

	public func typingAttribute(forKey key:NSAttributedString.Key) -> Any?
	{
		return self.typingAttributes[key]
	}
	
	#endif

}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

#if os(iOS)

public extension NSTextContainer
{
    var containerSize:CGSize
	{
		set
		{
			self.size = newValue
		}
		
		get
		{
			return self.size
		}
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

// On macOS and iOS NSTextAlignment is defined differently. iOS based the enum on Int, while macOS based it
// on UInt instead. In addition the order of center and right alignment are switched on macOS.

// The following extensions provide a common API for both platforms that can be used in shared code. Please
// note that the intValue order follow iOS conventions, i.e. left, center, right, justified.

#if os(iOS)

extension NSTextAlignment
{
	/// The order of intValue follows iOS conventions, i.e. left, center, right, justified.
	
	public init?(intValue:Int)
	{
		self.init(rawValue:intValue)
	}
	
	/// The order of intValue follows iOS conventions, i.e. left, center, right, justified.
	
	public var intValue:Int
	{
		return self.rawValue
	}
}

#endif


#if os(macOS)

extension NSTextAlignment
{
	/// The order of intValue follows iOS conventions, i.e. left, center, right, justified.
	
	public init?(intValue:Int)
	{
		var value = UInt(intValue)
		value = NSTextAlignment.swapRightAndCenter(value)
		self.init(rawValue:value)
	}
	
	/// The order of intValue follows iOS conventions, i.e. left, center, right, justified.
	
	public var intValue:Int
	{
		var value = self.rawValue
		value = NSTextAlignment.swapRightAndCenter(UInt(value))
		return Int(value)
	}
	
	private static func swapRightAndCenter(_ value:UInt) -> UInt
	{
		if value == NSTextAlignment.right.rawValue
		{
            return UInt(NSTextAlignment.center.rawValue)
		}
		else if value == NSTextAlignment.center.rawValue
		{
            return NSTextAlignment.right.rawValue
		}
		
		return value
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
