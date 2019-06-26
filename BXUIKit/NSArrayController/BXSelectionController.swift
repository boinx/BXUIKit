//**********************************************************************************************************************
//
//  BXSelectionController.swift
//	Replacement for the multiple selection functionality of NSArrayController without all the costly overhead
//  Copyright ©2019 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Foundation
import BXSwiftUtils


//----------------------------------------------------------------------------------------------------------------------


/// This protocol provides a way to uniquely identify objects

public protocol Identifiable
{
	/// The type of the identifier
	
	associatedtype ID: Hashable
	
	/// Returns the identifier for an object
	
	var id: Self.ID { get }
}


//----------------------------------------------------------------------------------------------------------------------


// MARK: -

open class BXSelectionController<Object:NSObject> : NSObject where Object:Identifiable
{

	/// Selected objects are stored in a dictionary key by their id. That way each object can only be in
	/// the selection once.
	
	private var selection: [Object.ID:ObjectWrapper] = [:]
	
	/// ObjectWrapper hold a weak reference to an object and manages the property observers
	
	private class ObjectWrapper
	{
		/// The object is stored in a weak ref so we do not retain it just because it was selected
		
		weak var object: Object? = nil
		
		/// A list of property observers. Will be replaced by Combine subscriptions in the future
		
		var observers: [Any] = []
		
		/// Creates a new ObjectWrapper
		
		init(_ object:Object)
		{
			self.object = object
		}

		/// Adds the registered property observers
		
		func addObservers(for controller:BXSelectionController)
		{
			guard let object = object else { return }
			
			for (keyPath,_) in controller.registeredProperties
			{
				self.observers += KVO(object:object, keyPath:keyPath)
				{
					_,_ in controller.publish(forKey:keyPath)
				}
			}
		}
		
		/// Removes all property observers
		
		func removeObservers()
		{
			self.observers.removeAll()
		}
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Register Properties
	
	open func registerProperty(keypath:String, type:Any.Type)
	{
//		let outputPublisher = PassthroughSubject<[T],Never>()
		self.registeredProperties[keypath] = type
	}
	
	fileprivate var registeredProperties: [String:Any.Type] = [:]
	
	
//----------------------------------------------------------------------------------------------------------------------


	// MARK: - Manage Selection


	/// Adds a new object to the selection
	
	open func addToSelectedObjects(_ object:Object)
	{
		let id = object.id
		
		if selection[id] == nil
		{
			let wrappedObject = ObjectWrapper(object)
			wrappedObject.addObservers(for:self)
			selection[id] = wrappedObject
			
			self.publish()
		}
	}


	/// Removes an object from the selection
	
	open func removeFromSelectedObjects(_ object:Object)
	{
		if let wrappedObject = selection[object.id]
		{
			wrappedObject.removeObservers()
			selection[object.id] = nil
			self.publish()
		}
		
	}


	/// Deselects all objects
	
	open func deselectAll()
	{
		for (_,wrappedObject) in self.selection
		{
			wrappedObject.removeObservers()
		}
		
		self.selection = [:]
		self.publish()
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Replaces the current selection with a new one
	
	open func setSelectedObjects(_ objects: [Object])
	{
		var newSelection: [Object.ID:ObjectWrapper] = [:]
		
		for object in objects
		{
			let wrappedObject = ObjectWrapper(object)
			wrappedObject.addObservers(for:self)
			newSelection[object.id] = wrappedObject
		}
		
		self.selection = newSelection
		self.publish()
	}
	
	
	/// Returns all selected objects as an array. The objects are not in any particular order.

	open var selectedObjects: [Object]
	{
		return self.selection.values.compactMap { $0.object }
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Removes wrappers with released objects from the selection.
	
	open func purgeReleasedObjectsFromSelection()
	{
		for (id,wrappedObject) in self.selection
		{
			if wrappedObject.object == nil
			{
				self.selection[id] = nil
			}
		}
	}
	

//----------------------------------------------------------------------------------------------------------------------


	// MARK: - KVC Accessors
	
	
	/// Sets the new value on all selected objects
	
	override open func setValue(_ value:Any?, forKey key:String)
	{
		self.selectedObjects.forEach { $0.setValue(value,forKey:key) }
	}

	
	/// Gets the values from all selected objects. If the value is unique it will be returned, otherwise
	/// NSMultipleValuesMarker will be returned.
	
	override open func value(forKey key:String) -> Any?
	{
		var uniqueValue: Any? = nil
		
		for object in self.selectedObjects
		{
			if let value = object.value(forKey:key)
			{
				if uniqueValue == nil
				{
					uniqueValue = value
				}
				else if let value1 = uniqueValue as? NSObject, let value2 = value as? NSObject, !value1.isEqual(value2)
				{
					return NSMultipleValuesMarker
				}
			}
		}
		
		return uniqueValue
	}
	
	
	/// Returns an array of values. If the selection is empty, the returned array will also be empty. If the
	/// property values for the selected objects is unique, the array will contain a single value. In case of
	/// multiple values, the array will contain more than one value.
	
	public func values<T:Equatable>(forKey key:String) -> [T]
	{
		var values: [T] = []
		
		for object in self.selectedObjects
		{
			if let value = object.value(forKey:key) as? T
			{
				if !values.contains { $0 == value }
				{
					values += value
				}
			}
		}
		
		return values
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


	/// Publishes a value change for all registered properties
	
	fileprivate func publish()
	{
		self.registeredProperties.keys.forEach { self.publish(forKey:$0) }
	}
	
	
	/// Publishes a value change for the specified property
	
	fileprivate func publish(forKey key:String)
	{
		self.willChangeValue(forKey:key)
		self.didChangeValue(forKey:key)
	}
	
	
//----------------------------------------------------------------------------------------------------------------------


}
