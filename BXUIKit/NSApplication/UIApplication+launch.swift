//**********************************************************************************************************************
//
//  UIApplication+launch.swift
//	Adds convenience methods
//  Copyright ©2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)

import UIKit
import UserNotifications


//----------------------------------------------------------------------------------------------------------------------


public extension UIApplication
{
	/// Brings the Mail.app to the front.
	///
	/// This relies on a non-documented URL. While it works for now, it might break in the future.
	
	func launchMailApp()
	{
		guard let url = URL(string:"message://") else { return }

		if UIApplication.shared.canOpenURL(url)
		{
			UIApplication.shared.open(url)
		}
	}
	
	/// Sends a user notification to let the user return to FotoMagico (if it is currently in the background)
	
	func sendUserNotification(title:String, message:String, delay:TimeInterval = 0.05)
	{
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = message
		content.sound = .default
		if #available(iOS 15.0,*)
		{
			content.interruptionLevel = .timeSensitive
		}
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval:delay, repeats:false)
		let request = UNNotificationRequest(identifier: "return_to_app", content:content, trigger:trigger)

		UNUserNotificationCenter.current().add(request)
	}
	
}


//----------------------------------------------------------------------------------------------------------------------


#endif
