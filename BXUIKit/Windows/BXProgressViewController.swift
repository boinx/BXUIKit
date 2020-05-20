//**********************************************************************************************************************
//
//  BXProgressViewController.swift
//	A progress bar window that can be presented modally or as a sheet
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


#if os(macOS)

open class BXProgressViewController : NSViewController
{
	@IBOutlet weak var titleField:NSTextField? = nil
	@IBOutlet weak var progressBar:NSProgressIndicator? = nil
	@IBOutlet weak var messageField:NSTextField? = nil
	

	override open func viewDidLoad()
	{
		super.viewDidLoad()
		self.progressBar?.usesThreadedAnimation = true
	}
}

#endif

	
//----------------------------------------------------------------------------------------------------------------------
