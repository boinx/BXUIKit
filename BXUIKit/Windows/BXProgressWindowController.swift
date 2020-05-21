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
		let controller = storyboard.instantiateInitialController() as! BXProgressWindowController
		
		_ = controller.window
		
		return controller
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
			guard let progressViewController = self.progressViewController else { return }
			
			progressViewController.titleField?.text = self.title
			progressViewController.messageField?.text = self.message
			progressViewController.progressBar?.doubleValue = self.value
			progressViewController.progressBar?.isIndeterminate = self.isIndeterminate
			
			if self.isIndeterminate
			{
				progressViewController.progressBar?.startAnimation(nil)
			}
			else
			{
				progressViewController.progressBar?.stopAnimation(nil)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
