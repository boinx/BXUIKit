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
    
	/// Helper function to display a modal alert on the frontmost UIViewController

	func displayAlert(title:String, message:String, buttons:[(String,(UIAlertAction)->Void)] = [("OK",{ _ in })])
	{
		let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)

		for buttonInfo in buttons
		{
			let action = UIAlertAction(title:buttonInfo.0, style:.default, handler:buttonInfo.1)
			alert.addAction(action)
		}

		self.frontmostViewController?.present(alert, animated:true, completion:nil)
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
