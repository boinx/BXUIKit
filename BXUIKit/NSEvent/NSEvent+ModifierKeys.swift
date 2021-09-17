//**********************************************************************************************************************
//
//  NSEvent+ModifierKeys.swift
//	Adds convenience methods for checking modified keys
//  Copyright ©2017-21 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************

#if os(macOS)

import AppKit


//----------------------------------------------------------------------------------------------------------------------


extension NSEvent
{
	/// Returns the key, useful for arrow keys or other function keys. THis accessor return ASCII values, so space is 32 or ESC is 27
	///
	/// Please note that the returned values are DIFFERENT from the keyCode accessor, which return virtual codes, e.g. keyCode for spacebar doesn't return 32.
	
    public var key:Int
	{
        guard let str = charactersIgnoringModifiers?.utf16  else { return 0 }
        let i = str.startIndex
        guard i < str.endIndex else { return 0 }
        return Int(str[i])
    }

	/// Returns true if the command key is down.
	
    public var isCommandDown:Bool
	{
		return self.modifierFlags.contains(.command)
	}
	
	/// Returns true if the option key is down.
	
    public var isOptionDown:Bool
	{
		return self.modifierFlags.contains(.option)
	}
	
	/// Returns true if the control key is down.
	
	public var isControlDown:Bool
	{
		return self.modifierFlags.contains(.control)
	}
	
	/// Returns true if the shift key is down.
	
    public var isShiftDown:Bool
	{
		return self.modifierFlags.contains(.shift)
	}
	
	/// Returns true if the capslock key is down.
	
	public var isCapsLockDown:Bool
	{
		return self.modifierFlags.contains(.capsLock)
	}
	
	/// Returns true if no modifier keys are pressed.
	
	public var isNoModifierDown:Bool
	{
		return self.modifierFlags.intersection([.command,.option,.control,.shift,.capsLock]).isEmpty
	}

	/// Returns true if this is a context menu event, i.e. a right click or a left click with pressed control key.
	
	public var isContextMenu:Bool
	{
		return self.type == .rightMouseDown || (self.type == .leftMouseDown && self.isControlDown)
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
