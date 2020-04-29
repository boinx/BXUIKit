//
//  NSMenu.swift
//  BXSwiftUtils-macOS
//
//  Created by Stefan Fochler on 27.06.18.
//  Copyright © 2018 Boinx Software Ltd. & Imagine GbR. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSMenu
{
    /// Appends a menu item to a menu using a conventient notation.

    public static func +=(menu: NSMenu, item: NSMenuItem)
    {
        menu.addItem(item)
    }


	/// Appends a submenu with the specified title.
	/// - returns: The newly created submenu
	
	public func addSubMenu(title:String) -> NSMenu
	{
		let item = NSMenuItem(title:title, action:nil, keyEquivalent:"")
		self.addItem(item)

		let submenu = NSMenu()
		submenu.autoenablesItems = false
		self.setSubmenu(submenu, for:item)
		return submenu
	}
}

#endif
