//**********************************************************************************************************************
//
//  UIApplication+frontmostViewController.swift
//	Returns the frontmost UIViewController that is not a UIAlertController
//  Copyright ©2019 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)

import UIKit


//----------------------------------------------------------------------------------------------------------------------


public extension UIApplication
{
	/// Returns the frontmost UIViewController that is not a UIAlertController

    var frontmostViewController: UIViewController?
    {
        return self.keyWindow?.rootViewController?.frontmostViewController
    }
}


//----------------------------------------------------------------------------------------------------------------------


public extension UIViewController
{
    /// Returns the frontmost UIViewController that is not a UIAlertController

    var frontmostViewController: UIViewController?
    {
        if let navigationController = self as? UINavigationController
        {
            return navigationController.topViewController?.frontmostViewController
        }
        else if let tabBarController = self as? UITabBarController
        {
            return tabBarController.selectedViewController?.frontmostViewController
        }
        else if let presentedViewController = presentedViewController
        {
            return presentedViewController.frontmostViewController
        }
        else if self is UIAlertController
        {
            return nil
        }
        else
        {
            return self
        }
    }
}


//----------------------------------------------------------------------------------------------------------------------

#endif
