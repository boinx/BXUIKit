//**********************************************************************************************************************
//
//  BXProgressWindowController.swift
//	A progress bar window that can be presented modally or as a sheet
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


open class BXProgressWindowController : NSWindowController
{
	public static let shared:BXProgressWindowController =
	{
		let bundle = Bundle(for:BXProgressWindowController.self)
		let storyboard = NSStoryboard(name:"BXProgressViewController", bundle:bundle)
		return storyboard.instantiateInitialController() as! BXProgressWindowController
	}()


	var progressViewController:BXProgressViewController?
	{
		self.contentViewController as? BXProgressViewController
	}


//----------------------------------------------------------------------------------------------------------------------


	open var title:String = ""
	{
		didSet { self.update() }
	}
	
	open var message:String = ""
	{
		didSet { self.update() }
	}
	
	open var value:Double = 0.0
	{
		didSet { self.update() }
	}
	
	open var isIndeterminate = false
	{
		didSet { self.update() }
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	open func show()
	{
		DispatchQueue.main.asyncIfNeeded
		{
			self.window?.center()
			self.showWindow(nil)
			self.window?.orderFront(nil)
		}
	}
	
	
	open func hide()
	{
		DispatchQueue.main.asyncIfNeeded
		{
			self.close()
		}
	}


	func update()
	{
		DispatchQueue.main.asyncIfNeeded
		{
			self.progressViewController?.titleField?.text = self.title
			self.progressViewController?.messageField?.text = self.message
			self.progressViewController?.progressBar?.doubleValue = self.value
			self.progressViewController?.progressBar?.isIndeterminate = self.isIndeterminate
			
			if self.isIndeterminate
			{
				self.progressViewController?.progressBar?.startAnimation(nil)
			}
			else
			{
				self.progressViewController?.progressBar?.stopAnimation(nil)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
