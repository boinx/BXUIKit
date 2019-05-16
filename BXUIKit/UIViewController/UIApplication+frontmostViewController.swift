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
    	return self.frontmostViewController(excluding: [UIAlertController.self])
    }

	/// Returns the frontmost UIViewController that is not any of the specified classTypes

    func frontmostViewController(excluding classTypes: [UIViewController.Type]) -> UIViewController?
    {
        return self.keyWindow?.rootViewController?.frontmostViewController(excluding: classTypes)
    }
}


//----------------------------------------------------------------------------------------------------------------------


public extension UIViewController
{
    /// Returns the frontmost UIViewController that is not a UIAlertController

    var frontmostViewController: UIViewController?
    {
        return self.frontmostViewController(excluding: [UIAlertController.self])
    }

	/// Returns the frontmost UIViewController that is not any of the specified classTypes

    func frontmostViewController(excluding classTypes: [UIViewController.Type]) -> UIViewController?
    {
        if let navigationController = self as? UINavigationController
        {
            return navigationController.topViewController?.frontmostViewController(excluding:classTypes)
        }
        else if let tabBarController = self as? UITabBarController
        {
            return tabBarController.selectedViewController?.frontmostViewController(excluding:classTypes)
        }
        else if let presentedViewController = presentedViewController
        {
            return presentedViewController.frontmostViewController(excluding:classTypes)
        }

		for classType in classTypes
		{
			if self.isKind(of:classType)
			{
				return nil
			}
		}
		
		return self
    }

}


//----------------------------------------------------------------------------------------------------------------------

#endif
