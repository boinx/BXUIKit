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
		let traits = self.fontDescriptor.symbolicTraits
		let size = self.pointSize

		#if os(iOS)
		
		var desc = UIFontDescriptor()
	 	desc = desc.withFamily(family)
	 	if let d = desc.withSymbolicTraits(traits) { desc = d }
	 	
		return UIFont(descriptor:desc, size:self.pointSize)
		
		#else
		
		// On macOS there seems to be a bug with NSFontDescriptor.withSymbolicTraits(). It should return the type
		// NSFontDescriptor (non-optional), but sometimes we get nil (0x0) - how can that even be possible ?!?
		// Creating an NSFont with this uninitialized descriptor fails. For this reason we need a robust fallback
		// strategy: First try the descriptor with the desired family and traits, if that fails then just use the
		// family, finally just use Helvetica.
		
		let font0 = NSFont(family:"Helvetica", face:"Regular", size:size)
		
		let desc1 = NSFontDescriptor().withFamily(family)
		let font1 = NSFont(descriptor:desc1, size:size)
		
		let desc2 = desc1.withSymbolicTraits(traits)
		let font2 = NSFont(descriptor:desc2, size:size)
		
		return font2 ?? font1 ?? font0 ?? NSFont.systemFont(ofSize:size)

		#endif
	}


//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified face name, while trying to keep the family and size intact
	
	public func withFace(_ face:String) -> NSUIFont
	{
		let size = self.pointSize
		
		#if os(iOS)
		
		let family = self.familyName 

		var desc = UIFontDescriptor()
		desc = desc.withFamily(family)
		desc = desc.withFace(face)
		return UIFont(descriptor:desc,size:size)
		
		#else
		
		let family = self.familyName ?? "Helvetica"

		var desc = NSFontDescriptor()
		desc = desc.withFamily(family)
		desc = desc.withFace(face)

		return
			NSFont(descriptor:desc, size:size) ??
			NSFont(family:"Helvetica", face:"Regular", size:size) ??
			NSFont.systemFont(ofSize:size)

		#endif
	}

	
//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified point size
	
	#if os(macOS)
	
//	@available(macOS, obsoleted:10.16)

	public func _withSize(_ size:CGFloat) -> NSUIFont
	{
		return
			NSFont(name:self.fontName, size:size) ??
			NSFont(family:"Helvetica", face:"Regular", size:size) ??
			NSFont.systemFont(ofSize:size)
	}

	#endif
}


//----------------------------------------------------------------------------------------------------------------------
