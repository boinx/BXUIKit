//**********************************************************************************************************************
//
//  NSUIFont+Creating.swift
//	Adds convenience methods create fonts
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif


//----------------------------------------------------------------------------------------------------------------------


extension NSUIFont
{

	/// Creates a font with the specified family, face, and size params
	
	public convenience init?(family:String,face:String,size:CGFloat)
	{
		#if os(iOS)
		
		// Build font with all three specified parameters
		
		var attributes:[UIFontDescriptor.AttributeName:Any] = [ .family:family, .face:face, .size:CGFloat(size) ]
		var desc = UIFontDescriptor(fontAttributes:attributes)
		let font = UIFont(descriptor:desc,size:size)
		
		if font.familyName == family
		{
			self.init(descriptor:desc,size:size)
		}
		
		// If this failed, then fallback to using just two params as the font family is the most important one
		
		else
		{
			attributes = [ .family:family ]
			desc = UIFontDescriptor(fontAttributes:attributes)
			self.init(descriptor:desc,size:size)
		}
		
		#else
		
		var attributes:[NSFontDescriptor.AttributeName:Any] = [ .family:family, .face:face, .size:CGFloat(size) ]
		var desc = NSFontDescriptor(fontAttributes:attributes)
		
		if let font = NSFont(descriptor:desc,size:size), font.familyName == family
		{
			self.init(descriptor:desc,size:size)
		}
		else
		{
			attributes = [ .family:family ]
			desc = NSFontDescriptor(fontAttributes:attributes)
			self.init(descriptor:desc,size:size)
		}

		#endif
	}


//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified family name, while trying to keep the face and size intact
	
	public func withFamily(_ family:String) -> NSUIFont
	{
		#if os(iOS)
		
		let traits = self.fontDescriptor.symbolicTraits
		
		var desc = UIFontDescriptor()
	 	desc = desc.withFamily(family)
	 	if let d = desc.withSymbolicTraits(traits) { desc = d }
		return UIFont(descriptor:desc, size:self.pointSize)
		
		#else
		
		var desc = self.fontDescriptor
		desc = desc.withFamily(family)
		let size = self.pointSize
		return NSFont(descriptor:desc,size:size) ?? NSFont.systemFont(ofSize:size)

		#endif
	}


//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified face name, while trying to keep the family and size intact
	
	public func withFace(_ face:String) -> NSUIFont
	{
		#if os(iOS)
		
		let family = self.familyName
		let size = self.pointSize
		
		var desc = UIFontDescriptor()
		desc = desc.withFamily(family)
		desc = desc.withFace(face)
		return UIFont(descriptor:desc,size:size)
		
		#else
		
		var desc = self.fontDescriptor
		desc = desc.withFace(face)
		let size = self.pointSize
		return NSFont(descriptor:desc,size:size) ?? NSFont.systemFont(ofSize:size)

		#endif
	}

	
//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified point size
	
	#if os(macOS)

	public func withSize(_ size:CGFloat) -> NSUIFont
	{
		let desc = self.fontDescriptor
		return NSFont(descriptor:desc,size:size) ?? NSFont.systemFont(ofSize:size)
	}

	#endif
}


//----------------------------------------------------------------------------------------------------------------------
