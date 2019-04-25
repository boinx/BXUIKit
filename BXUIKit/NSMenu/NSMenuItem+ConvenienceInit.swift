//
//  NSMenuItem+EnumCaseInit.swift
//  BXSwiftUtils
//
//  Created by Stefan Fochler on 27.06.18.
//  Copyright © 2018 Boinx Software Ltd. & Imagine GbR. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSMenuItem
{
    /**
     Convenience initializer that creates a menu item with a given `title` and `value` which will be used as the item's
     `representedObject`.
     
     - parameter title: The item's displayable title.
     - parameter value: The value that is represented by this item.
     - parameter indentationLevel: The item's indentationLevel, typically 0.
     - parameter enabled: Wheter the item should be enabled (if the parent menu doesn't auto-enable items itself).
     */
    @objc public convenience init(title: String, value: Any?, indentationLevel: Int, enabled: Bool)
    {
        self.init(title: title, action: nil, keyEquivalent: "")
        self.representedObject = value
        self.indentationLevel = indentationLevel
        self.isEnabled = enabled
    }
    
    /**
     Convenience initializer setting the title and represented object.
     
     Same as `NSMenuItem(title:value:indentationLevel:enabled)`, but with `indentationLevel = 0` and `enabled = true`.
     Listed as a seperate method for Objective C accessibility.
     */
    @objc public convenience init(title: String, value: Any?)
    {
        self.init(title: title, value: value, indentationLevel: 0, enabled: true)
    }
    
    /**
     Convenience initializer that creates a menu item with the given `value` used as the item's `representedObject`.
     The item's `title` will be set to `value`'s `rawValue`, which must be a `String`.
     
     - parameter value: The value that is represented by this item and the raw value of which must be a String.
     */
    public convenience init<Value>(for value: Value) where Value: RawRepresentable, Value.RawValue == String
    {
        self.init(title: value.rawValue, value: value)
    }
}

#endif
