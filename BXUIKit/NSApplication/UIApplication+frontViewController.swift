//**********************************************************************************************************************
//
//  UIApplication+frontViewController.swift
//	Adds convenience methods
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)

import UIKit
import UserNotifications


//----------------------------------------------------------------------------------------------------------------------


public extension UIApplication
{
	/// Returns the root UIViewController of the app
	
	static var baseViewController : UIViewController?
	{
		return UIApplication.shared.activeKeyWindow?.rootViewController
	}
	
	/// Returns the frontmost UIViewcontroller starting at the specified base
	
    static func frontViewController(base: UIViewController? = UIApplication.baseViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return frontViewController(base: nav.visibleViewController)
        }
        else if let tab = base as? UITabBarController
        {
            return frontViewController(base: tab.selectedViewController)
        }
        else if let presented = base?.presentedViewController
        {
            return frontViewController(base: presented)
        }
        
        return base
    }
}


//----------------------------------------------------------------------------------------------------------------------


#endif
