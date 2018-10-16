//
//  NSUIView+Hierarchy.swift
//  BXUIKit
//
//  Created by Stefan Fochler on 16.10.18.
//  Copyright © 2018 Boinx Software Ltd. All rights reserved.
//

import Foundation

public extension NSUIView
{
    /// Returns a flattened list of all descendants of a view
    
    public var recursiveSubviews : [NSUIView]
    {
        var subviews:[NSUIView] = self.flattenedViewHierarchy
        subviews.removeAll(where: { $0 === self })
        return subviews
    }
    
    /// Returns a flattened list of views starting at a specific point in the view hierarchy
    
    public var flattenedViewHierarchy : [NSUIView]
    {
        var views:[NSUIView] = []
        self.gatherViewsInViewHierarchy(with:&views)
        return views
    }
    
    private func gatherViewsInViewHierarchy(with array: inout [NSUIView])
    {
        array.append(self)
        
        for subview in self.subviews
        {
            subview.gatherViewsInViewHierarchy(with:&array)
        }
    }
    

    /// Returns the enclosing UIScrollView, providing a similar API as available on macOS.
    
    #if os(iOS)
    
    public var enclosingScrollView : UIScrollView?
    {
        if let scrollview = self as? UIScrollView
        {
            return scrollview
        }
        
        return self.superview?.enclosingScrollView
    }
    
    #endif
}
