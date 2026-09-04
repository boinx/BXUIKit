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
		
		// Resolved through the shared, retrying lookup - see NSFont.resolve(family:face:traits:size:) at the end of
		// this file for why asking once is not enough, and why a font from another family is treated as a failure.
		//
		// Failing is the honest answer: this is init?, and a caller that asked for a family it cannot have is better
		// served by a nil it can react to than by a font that merely looks right.
		
		guard let font = NSFont.resolve(family:family, face:face, traits:nil, size:size) else { return nil }
		
		self.init(descriptor:font.fontDescriptor, size:size)

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
		
		// Descriptor matching on macOS is not dependable. It can return nil where the API promises a value, and -
		// worse, because it is silent - it can SUCCEED and hand back a font from a different family altogether.
		// The old code accepted any non-nil result and otherwise dropped to Helvetica, so both failures looked the
		// same from outside: text quietly reverting to Helvetica with no error anywhere.
		//
		// So every strategy below is CHECKED against the family that was asked for, and the next one is tried when
		// it does not match. The failure is transient rather than a font that is genuinely absent, which is why
		// simply asking a second way is nearly always enough.
		
		if let font = NSFont.resolve(family:family, face:nil, traits:traits, size:size)
		{
			return font
		}
		
		// The family really is unavailable. Keep the SIZE, which is the facet the caller did not ask to change.
		
		return NSFont(family:"Helvetica", face:"Regular", size:size) ?? NSFont.systemFont(ofSize:size)

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

		// Changing the FACE must never change the family, so the face is requested first and the family alone is the
		// fallback - both through the same retrying resolver as everything else here.
		
		if let font = NSFont.resolve(family:family, face:face, traits:nil, size:size)
		{
			return font
		}
		
		if let font = NSFont.resolve(family:family, face:nil, traits:nil, size:size)
		{
			return font
		}
		
		return NSFont(family:"Helvetica", face:"Regular", size:size) ?? NSFont.systemFont(ofSize:size)

		#endif
	}

	
//----------------------------------------------------------------------------------------------------------------------


	/// Creates a new font with the specified point size
	
	#if os(macOS)
	
//	@available(macOS, obsoleted:10.16)

	public func legacy_withSize(_ size:CGFloat) -> NSUIFont
	{
		return
			NSFont(name:self.fontName, size:size) ??
			NSFont(family:"Helvetica", face:"Regular", size:size) ??
			NSFont.systemFont(ofSize:size)
	}
	
	#endif
}


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

public extension NSFont
{
	/// Resolves a font in the given family, retrying briefly, and never returning one from a different family.
	///
	/// Descriptor matching on macOS intermittently answers nil for a family that IS installed. That is measured rather than suspected: at the moment
	/// of a failure both descriptor lookups returned nil while NSFont(name:) returned the right font a fraction of a millisecond later, with the family
	/// present in availableFontFamilies throughout. The outage is brief and takes every lookup with it, which is why ordering the strategies differently
	/// does not help and asking again does.
	///
	/// Callers used to accept whatever came back, so an outage showed up as text silently reverting to Helvetica or to the system font - a wrong answer
	/// with nothing anywhere to say so. Every candidate is now checked against the family that was asked for, and nil means the family really is unavailable.
	
	static func resolve(family:String, face:String?, traits:NSFontDescriptor.SymbolicTraits?, size:CGFloat) -> NSFont?
	{
		for attempt in 0 ..< 3
		{
			var attributes:[NSFontDescriptor.AttributeName:Any] = [ .family:family ]
			if let face = face { attributes[.face] = face }
			
			// Most specific first: family plus face, then family plus traits, then family alone, then by name -
			// which reaches the font through a different path than descriptor matching
			
			var descriptors = [NSFontDescriptor(fontAttributes:attributes)]
			
			if let traits = traits
			{
				descriptors.append(NSFontDescriptor().withFamily(family).withSymbolicTraits(traits))
			}
			
			descriptors.append(NSFontDescriptor().withFamily(family))
			
			for descriptor in descriptors
			{
				if let font = NSFont(descriptor:descriptor, size:size), font.familyName == family
				{
					return font
				}
			}
			
			if let font = NSFont(name:family, size:size), font.familyName == family
			{
				return font.withSize(size)
			}
			
			// Everything failed at once, which is what the outage looks like. Give it a moment and ask again -
			// this costs nothing on the path that succeeds, and only ever runs when the answer would be wrong.
			
			if attempt < 2 { Thread.sleep(forTimeInterval:0.001) }
		}
		
		return nil
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
