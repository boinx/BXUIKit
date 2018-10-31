//**********************************************************************************************************************
//
//  BXColumnView.swift
//	A conainter view that supports two column layout that automatically reflows when the container gets too narrow
//  Copyright ©2018 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(iOS)
import UIKit
#else
import AppKit
#endif


//----------------------------------------------------------------------------------------------------------------------


public class BXColumnView : NSUIView
{
	// Outlets
	
	@IBOutlet weak var columnView1:UIView! = nil
	@IBOutlet weak var columnView2:UIView! = nil

	// Stores the size of the columns at design time
	
	private var columnFrame1 = CGRect.zero
	private var columnFrame2 = CGRect.zero
	
	// Padding and spacing
	
	public var paddingTop:CGFloat = 20.0
	public var paddingLeft:CGFloat = 20.0
	public var paddingRight:CGFloat = 20.0
	public var paddingBottom:CGFloat = 20.0
	
	public var columnSpacing = CGSize(width:20.0,height:20.0)
	

//----------------------------------------------------------------------------------------------------------------------


	// Remember the design-time sizes of each column
	
	public override func awakeFromNib()
	{
		super.awakeFromNib()
		self.columnFrame1 = columnView1.frame
		self.columnFrame2 = columnView2.frame
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


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
		// Remove all existing constraints
		
		self.removeAllConstraints()
		self.columnView1.removeAllConstraints()
		self.columnView2.removeAllConstraints()

		// Column 1 is always anchored at the top left
		
		self.columnView1.defineLayout
		{
			$0.top == self.top + self.paddingTop //columnFrame1.minY
			$0.left == self.left + self.paddingLeft //columnFrame1.minX
			$0.width == columnFrame1.width
			$0.height == columnFrame1.height
		}
		
		// If this container view is wide enough, then column 2 beside column 1
		
		if self.bounds.width >= self.paddingLeft + columnFrame1.width + self.columnSpacing.width + columnFrame2.width + self.paddingRight
		{
			self.columnView2.defineLayout
			{
				$0.top == self.columnView1.top
				$0.left == self.columnView1.right + self.columnSpacing.width
				$0.width == columnFrame2.width
				$0.height == columnFrame2.height
			}
		}

		// Otherwise column 2 will reflow below column 1

		else
		{
			self.columnView2.defineLayout
			{
				$0.top == self.columnView1.bottom + self.columnSpacing.height
				$0.left == self.columnView1.left
				$0.width == columnFrame2.width
				$0.height == columnFrame2.height
			}
		}
		
		super.updateConstraints()
	}


//----------------------------------------------------------------------------------------------------------------------


}
