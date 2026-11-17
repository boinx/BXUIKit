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
		let size = self.pointSize

		#if os(iOS)
		
		// TIERS, most specific first - the same ladder the macOS branch climbs, see NSFont.resolve(family:face:traits:size:)
		// at the end of this file. Each tier asks for strictly less than the one above it.
		//
		// The WHOLE traits dictionary first. Weight is not a symbolic trait - `.bold` is, but Light, Medium, Semibold and
		// the rest are a `.weight` number - so carrying only the symbolic traits drops every one of them.
		
		let traits = self.fontDescriptor.object(forKey:.traits) as? [UIFontDescriptor.TraitKey:Any]
		
		if let traits = traits, !traits.isEmpty
		{
			let desc = UIFontDescriptor(fontAttributes:[ .family:family, .traits:traits ])
			if let font = Self.matching(desc, family:family, size:size) { return font }
		}
		
		// The symbolic traits alone, so a family that cannot match the exact weight still keeps bold or italic
		
		if let symbolic = (traits?[.symbolic] as? UInt32).map({ UIFontDescriptor.SymbolicTraits(rawValue:$0) }), !symbolic.isEmpty,
		   let desc = UIFontDescriptor().withFamily(family).withSymbolicTraits(symbolic)
		{
			if let font = Self.matching(desc, family:family, size:size) { return font }
		}
		
		// The family alone, which is the least the caller will accept. Nothing is checked here because there is nowhere
		// left to go: the SIZE is kept, which is the facet the caller did not ask to change.
		
		return UIFont(descriptor:UIFontDescriptor().withFamily(family), size:size)
		
		#else
		
		// Descriptor matching on macOS is not dependable. It can return nil where the API promises a value, and -
		// worse, because it is silent - it can SUCCEED and hand back a font from a different family altogether.
		// The old code accepted any non-nil result and otherwise dropped to Helvetica, so both failures looked the
		// same from outside: text quietly reverting to Helvetica with no error anywhere.
		//
		// So every strategy below is CHECKED against the family that was asked for, and the next one is tried when
		// it does not match. The failure is transient rather than a font that is genuinely absent, which is why
		// simply asking a second way is nearly always enough.
		
		if let font = NSFont.resolve(family:family, face:nil, traits:self.fontDescriptor.object(forKey:.traits) as? [NSFontDescriptor.TraitKey:Any], size:size)
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


#if os(iOS)

extension UIFont
{
	/// Matches a descriptor, treating a font from any OTHER family as a failure rather than a result.
	///
	/// UIFont(descriptor:size:) cannot fail - when nothing matches it substitutes a font without a word - so every
	/// candidate has to be checked against the family that was asked for.
	
	fileprivate static func matching(_ descriptor:UIFontDescriptor, family:String, size:CGFloat) -> UIFont?
	{
		let font = UIFont(descriptor:descriptor, size:size)
		return font.familyName == family ? font : nil
	}
}

#endif


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
	
	static func resolve(family:String, face:String?, traits:[NSFontDescriptor.TraitKey:Any]?, size:CGFloat) -> NSFont?
	{
		// TIERS, most specific first. Each one asks for strictly less than the one above it, so reaching a lower tier
		// means giving the caller less than it asked for - a Light layer coming back Regular, say.
		
		var tiers:[NSFontDescriptor] = []
		
		if let face = face
		{
			tiers.append(NSFontDescriptor(fontAttributes:[ .family:family, .face:face ]))
		}
		
		// The WHOLE traits dictionary. Weight is not a symbolic trait - `.bold` is, but Light, Medium, Semibold and
		// the rest are a `.weight` number - so carrying only the symbolic traits drops every one of them.
		
		if let traits = traits, !traits.isEmpty
		{
			tiers.append(NSFontDescriptor(fontAttributes:[ .family:family, .traits:traits ]))
		}
		
		// The symbolic traits alone, so a family that cannot match the exact weight still keeps bold or italic
		
		if let symbolic = (traits?[.symbolic] as? UInt32).map({ NSFontDescriptor.SymbolicTraits(rawValue:$0) }), !symbolic.isEmpty
		{
			tiers.append(NSFontDescriptor().withFamily(family).withSymbolicTraits(symbolic))
		}
		
		// The family alone, which is the least the caller will accept
		
		tiers.append(NSFontDescriptor().withFamily(family))
		
		// EVERY TIER IS RETRIED BEFORE THE NEXT ONE IS TRIED. A transient matching failure and a family that
		// genuinely has no such face both answer nil, so asking again is the only way to tell them apart - and
		// dropping to the next tier on a first failure is exactly how a requested weight or trait goes missing.
		// The cost is a few milliseconds on a family switch that really cannot be honoured, which nobody sees.
		
		for tier in tiers
		{
			for attempt in 0 ..< 3
			{
				if let font = Self.matching(tier, family:family, size:size) { return font }
				
				if attempt < 2 { Thread.sleep(forTimeInterval:0.001) }
			}
		}
		
		// Looking the family up by name goes through a different path than descriptor matching, so it is worth
		// asking even when all of that has failed
		
		for attempt in 0 ..< 3
		{
			if let font = NSFont(name:family, size:size), font.familyName == family
			{
				return font.withSize(size)
			}
			
			if attempt < 2 { Thread.sleep(forTimeInterval:0.001) }
		}
		
		return nil
	}
	
	
	/// Matches a descriptor, treating a font from any OTHER family as a failure rather than a result.
	
	private static func matching(_ descriptor:NSFontDescriptor, family:String, size:CGFloat) -> NSFont?
	{
		guard let font = NSFont(descriptor:descriptor, size:size), font.familyName == family else { return nil }
		
		return font
	}
}

#endif


//----------------------------------------------------------------------------------------------------------------------
