//**********************************************************************************************************************
//
//  UIViewController+presentAlert.swift
//	Displays an alert
//  Copyright ©2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)

import UIKit


//----------------------------------------------------------------------------------------------------------------------


public extension UIViewController
{
	/// Display an alert with the specified title, message and button name
	
    func showAlert(title:String, message:String, okTitle:String, okHandler:(()->Void)? = nil)
    {
        let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        
        if let okHandler = okHandler
        {
			let okAction = UIAlertAction(title:okTitle, style:.default)
			{
				_ in okHandler()
			}

			alert.addAction(okAction)
		}
		
        self.present(alert, animated:true)
    }

}


//----------------------------------------------------------------------------------------------------------------------

#endif
