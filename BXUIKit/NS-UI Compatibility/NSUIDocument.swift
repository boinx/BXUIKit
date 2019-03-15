//**********************************************************************************************************************
//
//  NSUIDocument.swift
//	This file should help to make shared framework code compatible with macOS and iOS platforms
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


// iOS and macOS provide many classes that are equivalent in usage, but have different names and API. Since
// we want to use shared framework code that doesn't have a lot of conditional compiles, we introduce metatypes
// that abstract away the specific platform version of the type. The new prefix is 'NSUI' to indicate the 
// instance is either a NS or a UI type instance.

#if os(macOS)
	
import AppKit

public typealias NSUIDocument = NSDocument

#elseif os(iOS)

import UIKit

public typealias NSUIDocument = UIDocument

#endif


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

extension NSUIDocument
{

	/// Returns the URL where a document (package) is located in the file system.
	///
	/// On macOS a document may not have been saved by the user yet, but autosave already created a file on disk,
	/// so fileURL still returns nil while autosavedContentsFileURL already returns a valid URL.
	
	public var baseURL : URL?
	{
		#if os(iOS)
		return self.fileURL
		#else
 		return self.fileURL ?? self.autosavedContentsFileURL
		#endif
	}

}


//----------------------------------------------------------------------------------------------------------------------
