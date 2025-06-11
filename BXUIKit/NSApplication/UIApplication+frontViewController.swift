//**********************************************************************************************************************
//
//  UIApplication+frontViewController.swift
//	Adds convenience methods
//  Copyright ©2025 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)

import UIKit


public extension UIApplication
{
	/// Returns the root UIViewController of the app
	
	static var baseViewController : UIViewController?
	{
		if #available(iOS 15,*)
		{
			return UIApplication.shared
				.connectedScenes
				.compactMap { ($0 as? UIWindowScene)?.keyWindow }
				.first?
				.rootViewController
		}
		else
		{
			return UIApplication.shared
				.windows
				.first?
				.rootViewController
		}
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

#endif


//----------------------------------------------------------------------------------------------------------------------
