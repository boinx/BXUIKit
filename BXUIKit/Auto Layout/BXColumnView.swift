//**********************************************************************************************************************
//
//  BXColumnView.swift
//	A conainter view that supports two column layout that automatically reflows when the container gets too narrow
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import BXSwiftUtils

#if os(iOS)
import UIKit
#else
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


public class BXColumnView : NSUIView
{
	// Outlets
	
	@IBOutlet var columnViews:[NSUIView] = []

	#if os(macOS)
	@IBOutlet weak var columnView1:NSUIView? = nil			// Since @IBOutletCollection is not available on macOS,
	@IBOutlet weak var columnView2:NSUIView? = nil			// separate @IBOutlets will have to be used in this case
	#endif
	
	// Padding and spacing
	
	@IBInspectable public var paddingTop:CGFloat = 20.0
	@IBInspectable public var paddingLeft:CGFloat = 20.0
	@IBInspectable public var paddingRight:CGFloat = 20.0
	@IBInspectable public var paddingBottom:CGFloat = 20.0
	@IBInspectable public var spacingX:CGFloat = 20.0
	@IBInspectable public var spacingY:CGFloat = 20.0

	// Sizes of the columns at IB design time
	
	private var columnFrames:[CGRect] = []
	

//----------------------------------------------------------------------------------------------------------------------


	public override func awakeFromNib()
	{
		super.awakeFromNib()

		// Copy separate macOS outlets into iOS-style IBOutletCollection - This more extendable for the future
		
		#if os(macOS)
		columnViews += columnView1
		columnViews += columnView2
		#endif
		
		assert(columnViews.count == 2,"At this time only two 2 column layout is supported")
		
		// Remember the design-time sizes of each column
	
		self.columnFrames = columnViews.map { $0.frame }
	}
	
	
	// Update layout when the size of the container changes
	
	public override var frame: CGRect
	{
		didSet { self.setNeedsUpdateConstraints() }
	}
	
	public override var bounds: CGRect
	{
		didSet { self.setNeedsUpdateConstraints() }
	}


//----------------------------------------------------------------------------------------------------------------------


	public override func updateConstraints()
	{
		var size = CGSize.zero
		let frame0 = columnFrames[0]
		let frame1 = columnFrames[1]
		let twoColumnWidth = self.paddingLeft + frame0.width + self.spacingX + frame1.width + self.paddingRight
		
		// Remove all existing constraints
		
		self.removeAllConstraints()
		self.columnViews.forEach { $0.removeAllConstraints() }

		// Column 1 is always anchored at the top left
		
		self.columnViews[0].defineLayout
		{
			$0.top == self.top + self.paddingTop
			$0.left == self.left + self.paddingLeft
			$0.width == frame0.width
			$0.height == frame0.height
		}
		
		// If this container view is wide enough, then put column 2 next to column 1
		
		if self.bounds.width >= twoColumnWidth
		{
			self.columnViews[1].defineLayout
			{
				$0.top == self.columnViews[0].top
				$0.left == self.columnViews[0].right + self.spacingX
				$0.width == columnFrames[1].width
				$0.height == columnFrames[1].height
			}

			size.width = twoColumnWidth
			size.height = self.paddingTop + max(frame0.height,frame1.height) + self.paddingBottom
		}

		// Otherwise column 2 will reflow below column 1

		else
		{
			self.columnViews[1].defineLayout
			{
				$0.top == self.columnViews[0].bottom + self.spacingY
				$0.left == self.columnViews[0].left
				$0.width == columnFrames[1].width
				$0.height == columnFrames[1].height
			}

			size.width = self.paddingLeft + max(frame0.width,frame1.width) + self.paddingRight
			size.height = self.paddingTop + frame0.height + self.spacingY + frame1.height + self.paddingBottom
		}

		// Set size so that an enclosingScrollView works correctly
		
		self.enclosingScrollView?.contentSize = size

		// Make UIKit/AppKit happy
		
		super.updateConstraints()
	}


//----------------------------------------------------------------------------------------------------------------------


}
