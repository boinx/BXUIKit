//**********************************************************************************************************************
//
//  BXMenuItemHandler.swift
//	A declarative approach to validate and handle NSMenuItems
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import AppKit
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


/// BXMenuItemHandler bundles everything that is needed to validate and execute menu items. Except for the identifier, values are provided by closures,
/// so that they can change dynamically at runtime. Closures that are not needed can be omitted and default values will be used.

public struct BXMenuItemHandler
{
	/// The unique identifier of the corresponding NSMenuItem
	
	var identifier:String
	
	/// A closure that returns the title for the NSMenuItem. Default is nil, which means that the title will not be modified.
	
	var title:(NSMenuItem)->String? = { _ in nil }
	
	/// A closure that returns an optional icon image for the NSMenuItem. Default is nil.
	
	var image:(NSMenuItem)->NSImage? = { _ in nil }
	
	/// A closure that returns the state (.off, .on, .mixed) for the NSMenuItem. Default is on.
	
	var state:(NSMenuItem)->NSControl.StateValue = { _ in .off }
	
	/// A closure that returns the enabled state for the NSMenuItem. Default is true.
	
	var isEnabled:(NSMenuItem)->Bool = { _ in true }
	
	/// The action closure is executed when the menu item is selected.
	
	var action:(NSMenuItem)->Void = { _ in }
	
	/// Creates a BXMenuItemHandler
	/// - parameter identifier: The unique identifier of the corresponding NSMenuItem
	/// - parameter title: A closure that returns the title for the NSMenuItem. Default is nil, which means that the title will not be modified.
	/// - parameter image: A closure that returns an optional icon image for the NSMenuItem. Default is nil.
	/// - parameter state: A closure that returns the state (.off, .on, .mixed) for the NSMenuItem. Default is on.
	/// - parameter isEnabled: A closure that returns the enabled state for the NSMenuItem. Default is true.
	/// - parameter action: The action closure is executed when the menu item is selected.
	
	public init(identifier:String , title:@escaping (NSMenuItem)->String? = {_ in nil}, image:@escaping (NSMenuItem)->NSImage? = {_ in nil}, state:@escaping (NSMenuItem)->NSControl.StateValue = {_ in .off}, isEnabled:@escaping (NSMenuItem)->Bool = {_ in true}, action:@escaping (NSMenuItem)->Void)
	{
		self.identifier = identifier
		self.title = title
		self.image = image
		self.state = state
		self.isEnabled = isEnabled
		self.action = action
		
		// If the menu item doesn't have an action yet, then automatically set it to executeMenuItem
		
		NSMenu.main?.menuItems(forIdentifier:identifier).forEach
		{
			if $0.action == nil
			{
				$0.action = #selector(BXProxyObject.executeMenuItem)
			}
		}
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

/// NSResponders that want to handle menu actions can implement this protocol. They need to provide the menuItemHandlers array and two short
/// generic implementations of validateMenuItem(_:) and executeMenuItem(_:)

public protocol BXMenuItemHandlerMixin : class
{
	// REQUIREMENTS
	
	/// The list of available BXMenuItemWrapper for an object in the responder chain
	
	var menuItemHandlers:[BXMenuItemHandler] { set get }
	
	/// Must be provided by NSResponders in the chain. Call validate(_:with:) from this implementation.
	
	func validateMenuItem(_ menuItem:NSMenuItem) -> Bool
	
	/// Must be provided by NSResponders in the chain. Call execute(_:with:) from this implementation.
	
	func executeMenuItem(_ menuItem:NSMenuItem!)


	// API
	
	/// Returns the BXMenuItemHandler for the identifier of the specified NSMenuItem
	
	func handler(for menuItem:NSMenuItem) -> BXMenuItemHandler?
	
	/// Validates the menu item with the specified wrapper
	
	func validate(_ menuItem:NSMenuItem, with handler:BXMenuItemHandler) -> Bool
	
	/// Calls the action of the specified wrapper
	
	func execute(_ menuItem:NSMenuItem, with handler:BXMenuItemHandler)
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension BXMenuItemHandlerMixin
{
	func handler(for menuItem:NSMenuItem) -> BXMenuItemHandler?
	{
		guard let identifier = menuItem.identifier?.rawValue else { return nil }
		
		for handler in self.menuItemHandlers
		{
			let id = handler.identifier
			
			if id.hasSuffix("*")
			{
				let prefix = id.replacingOccurrences(of:"*", with:"")
				
				if identifier.hasPrefix(prefix)
				{
					return handler
				}
			}
			else if id == identifier
			{
				return handler
			}
		}
		
		return nil
	}
	
	
	func validate(_ menuItem:NSMenuItem, with handler:BXMenuItemHandler) -> Bool
	{
		guard let handler = self.handler(for:menuItem) else { return false }

		// If the handler provided a new title, then change the title of the menu item
		
		if let title = handler.title(menuItem)
		{
			menuItem.title = title
		}
		
		// Set menu item state according to handler
		
		let isEnabled = handler.isEnabled(menuItem)
		menuItem.image = handler.image(menuItem)
		menuItem.state = handler.state(menuItem)
		menuItem.isEnabled = isEnabled

		return isEnabled
	}
	
	
	func execute(_ menuItem:NSMenuItem, with handler:BXMenuItemHandler)
	{
		self.handler(for:menuItem)?.action(menuItem)
	}
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

public extension NSMenu
{
	/// Return the main menu of the application

	class var main:NSMenu?
	{
		NSApp.mainMenu
	}

	/// Performs a recursive search for a NSMenuItem with the specified identifier

	func menuItems(forIdentifier identifier:String) -> [NSMenuItem]
	{
		var menuItems:[NSMenuItem] = []
		let prefix = identifier.replacingOccurrences(of:"*", with:"")
		
		for item in self.items
		{
			if let id = item.identifier?.rawValue
			{
				if identifier.hasSuffix("*") && id.hasPrefix(prefix)
				{
					menuItems += item
				}
				else if id == identifier
				{
					menuItems += item
				}
			}
			
			if let submenu = item.submenu
			{
				menuItems += submenu.menuItems(forIdentifier:identifier)
			}
		}

		return menuItems
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// This dummy object only exists so we have a known executeMenuItem IBAction to create a #selector in init() of BXMenuItemHandler.

class BXProxyObject : NSObject
{
	@IBAction func executeMenuItem(_ menuItem:NSMenuItem!)
	{

	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
